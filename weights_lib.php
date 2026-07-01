<?php
// Shared weight-application logic used by batch_weights.php (one-shot) and
// batch_weights_parallel.php (chunked/parallel). Keep the upsert semantics in
// one place so the two pages can never drift apart.

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

// Push one weight onto every registered student's mark row for a module.
// id is the primary key, so a native upsert handles both the "row exists"
// and "row missing" cases.
function applyWeight($conn, $table, $ids, $pct) {
    $stmt = $conn->prepare("INSERT INTO `$table` (id, percentage) VALUES (?, ?)
                            ON DUPLICATE KEY UPDATE percentage = VALUES(percentage)");
    foreach ($ids as $id) {
        $stmt->bind_param("id", $id, $pct);
        if (!$stmt->execute()) { $stmt->close(); return false; }
    }
    $stmt->close();
    return true;
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
// student row for one module. Returns [label, status] for the report.
// Per-module transaction: a module is all-or-nothing, never half-weighted.
// Retries on deadlock (1213) / lock-wait-timeout (1205): parallel writers on
// the same mark tables collide, InnoDB kills one, retrying the loser resolves
// it. ponytail: linear backoff + 5 tries; lower "Parallel batches" if the
// retry rate ever gets high.
function processModule($conn, $mid, $modules, $retries = 5) {
    $label = $modules[$mid] ?? "module #$mid";

    $cw = readWeight($conn, 'module_coursework', $mid);
    $pr = readWeight($conn, 'module_practical',  $mid);
    $ex = readWeight($conn, 'module_exam',       $mid);

    $ids = [];
    $r = $conn->query("SELECT id FROM registeredmodule WHERE moduleid = " . (int) $mid);
    while ($r && $row = $r->fetch_assoc()) { $ids[] = (int) $row['id']; }

    if (!$ids) {
        return [$label, 'skipped — no registered students'];
    }

    for ($attempt = 1; ; $attempt++) {
        try {
            $conn->begin_transaction();
            applyWeight($conn, 'registeredmodule_courseworkmark', $ids, $cw);
            applyWeight($conn, 'registeredmodule_practicalmark',  $ids, $pr);
            applyWeight($conn, 'registeredmodule_exammark',       $ids, $ex);
            $conn->commit();
            return [$label, "done — weights $cw/$pr/$ex applied to " . count($ids) . " students"];
        } catch (mysqli_sql_exception $e) {
            $conn->rollback();
            if (($e->getCode() === 1213 || $e->getCode() === 1205) && $attempt < $retries) {
                usleep(50000 * $attempt);  // 50ms, 100ms, … back off then retry
                continue;
            }
            return [$label, 'error — ' . $e->getMessage()];
        }
    }
}
