<?php
// Shared weight-application logic used by batch_weights.php (one-shot) and
// batch_weights_parallel.php (chunked/parallel). Keep the upsert semantics in
// one place so the two pages can never drift apart.
//
// Target runtime is PHP 5.5.9: no ?? , no [$a,$b]= destructuring, no Throwable.
// mysqli must NOT throw — 5.5 doesn't by default, and 8.x does, so pin it OFF
// on both so execute() consistently returns false and we branch on errno.
mysqli_report(MYSQLI_REPORT_OFF);

// Read one stored weight for a module, defaulting to 0 when none exists.
function readWeight($conn, $table, $moduleid) {
    $stmt = $conn->prepare("SELECT percentage FROM `$table` WHERE id = ?");
    $stmt->bind_param("i", $moduleid);
    $stmt->execute();
    $stmt->bind_result($pct);
    $pct = null;
    $stmt->fetch();
    $stmt->close();
    return ($pct === null || $pct === '') ? 0 : $pct;
}

// Push one weight onto every registered student's mark row for a module in a
// SINGLE set-based upsert (INSERT...SELECT...ON DUPLICATE KEY UPDATE) instead
// of one statement per student. This shrinks the transaction from ~hundreds of
// row locks to one short burst, which is what actually stops the parallel
// deadlocks — and it is far faster. Returns 0 on success, else the MySQL errno
// (message via $errmsg) so the caller can retry deadlocks.
function applyWeight($conn, $table, $moduleid, $pct, &$errmsg = '') {
    $stmt = $conn->prepare(
        "INSERT INTO `$table` (id, percentage)
         SELECT id, ? FROM registeredmodule WHERE moduleid = ?
         ON DUPLICATE KEY UPDATE percentage = VALUES(percentage)");
    if (!$stmt) { $errmsg = $conn->error; return $conn->errno; }
    $stmt->bind_param("di", $pct, $moduleid);
    if (!$stmt->execute()) {
        $errno = $stmt->errno;
        $errmsg = $stmt->error;
        $stmt->close();
        return $errno;
    }
    $stmt->close();
    return 0;
}

// id => "courseid unitcode - name", ordered for display.
function loadModules($conn) {
    $modules = [];
    $res = $conn->query("SELECT id, courseid, unitcode, name FROM module ORDER BY courseid, unitcode");
    while ($row = $res->fetch_assoc()) {
        $modules[(int)$row['id']] = $row['courseid'] . $row['unitcode'] . ' - ' . $row['name'];
    }
    return $modules;
}

// Apply the stored coursework/practical/exam weights to every registered
// student row for one module. Returns array(label, status) for the report.
// Per-module transaction: a module is all-or-nothing, never half-weighted.
// Retries on deadlock (1213) / lock-wait-timeout (1205): parallel writers on
// the same mark tables collide, InnoDB kills one, retrying the loser resolves
// it. ponytail: linear backoff + 5 tries; lower "Parallel batches" if the
// retry rate ever gets high.
function processModule($conn, $mid, $modules, $retries = 5) {
    $label = isset($modules[$mid]) ? $modules[$mid] : "module #$mid";

    $cw = readWeight($conn, 'module_coursework', $mid);
    $pr = readWeight($conn, 'module_practical',  $mid);
    $ex = readWeight($conn, 'module_exam',       $mid);

    // Count registrations once, for the skip check and the report line.
    $count = 0;
    $res = $conn->query("SELECT COUNT(*) AS c FROM registeredmodule WHERE moduleid = " . (int) $mid);
    if ($res && $row = $res->fetch_assoc()) { $count = (int) $row['c']; }

    if ($count === 0) {
        return [$label, 'skipped -- no registered students'];
    }

    // Note: no "SET ... READ COMMITTED" here. On a server with binary logging
    // in STATEMENT format, InnoDB refuses to write under READ COMMITTED
    // ("impossible to write to binary log"). The set-based upsert below is the
    // real deadlock fix; it works fine under the default REPEATABLE READ.
    for ($attempt = 1; ; $attempt++) {
        $conn->begin_transaction();
        $msg = '';
        $err = applyWeight($conn, 'registeredmodule_courseworkmark', $mid, $cw, $msg);
        if ($err === 0) $err = applyWeight($conn, 'registeredmodule_practicalmark', $mid, $pr, $msg);
        if ($err === 0) $err = applyWeight($conn, 'registeredmodule_exammark',      $mid, $ex, $msg);

        if ($err === 0) {
            $conn->commit();
            return [$label, "done -- weights $cw/$pr/$ex applied to $count students"];
        }

        $conn->rollback();
        if (($err === 1213 || $err === 1205) && $attempt < $retries) {
            usleep(50000 * $attempt);  // 50ms, 100ms, ... back off then retry
            continue;
        }
        return [$label, 'error -- ' . $msg];
    }
}
