<?php
/**
 * migrate_import.php  —  DEPLOY ON THE HEIMS SERVER (.50, later .10)
 * PHP 5.5 compatible.
 *
 * Browser-based import of migrate_students.json (from migrate_export.php).
 * The page parses the JSON in the browser and sends it to the server in small
 * batches via AJAX, showing a live progress bar and detailed per-record errors.
 * Each student is inserted with the same rules as the API: validate + sanitize,
 * idempotent (skip existing regnum), all-or-nothing per student (transaction).
 */

/* ---------------- config: THIS HEIMS box's DB ---------------- */
$DB_HOST = '127.0.0.1';
$DB_PORT = 3306;
$DB_USER = 'heims';
$DB_PASS = '2oi8H31m52oi7h1T';
$DB_NAME = 'heims';
$BATCH_HINT = 25; /* how many records the browser sends per request */
/* ------------------------------------------------------------- */

function clean($s) {
    $s = trim((string)$s);
    $s = strtr($s, array(
        "\xE2\x80\x99" => "'", "\xE2\x80\x98" => "'", "\xCA\xBC" => "'", "\xCA\xBB" => "'",
        "\xE2\x80\x9C" => '"', "\xE2\x80\x9D" => '"',
        "\xE2\x80\x93" => '-', "\xE2\x80\x94" => '-', "\xE2\x80\xA6" => '...',
    ));
    $c = @iconv('UTF-8', 'ISO-8859-1//TRANSLIT//IGNORE', $s);
    return $c === false ? $s : $c;
}
function cap($s, $n) { return strlen($s) > $n ? substr($s, 0, $n) : $s; }
function g($rec, $k) { return isset($rec[$k]) ? $rec[$k] : ''; }

/* Insert ONE record. Returns array(status => created|skipped|error, id, msg, regnum). */
function process_one($conn, $rec) {
    $regnum = isset($rec['regnum']) ? clean($rec['regnum']) : '';
    foreach (array('regnum','firstnames','surname','programmeid','attendancetypeid','dob') as $k) {
        if (!isset($rec[$k]) || trim((string)$rec[$k]) === '')
            return array('status'=>'error','regnum'=>$regnum,'msg'=>"missing required field: $k");
    }
    if (!preg_match('/^[A-Za-z0-9]{1,50}$/', $regnum))
        return array('status'=>'error','regnum'=>$regnum,'msg'=>'regnum must be 1-50 alphanumeric characters');

    $programmeid = filter_var($rec['programmeid'], FILTER_VALIDATE_INT);
    if ($programmeid === false || $programmeid <= 0)
        return array('status'=>'error','regnum'=>$regnum,'msg'=>"programmeid not a positive integer (got '".g($rec,'programmeid')."')");
    $attendancetypeid = filter_var($rec['attendancetypeid'], FILTER_VALIDATE_INT);
    if ($attendancetypeid === false || $attendancetypeid <= 0)
        return array('status'=>'error','regnum'=>$regnum,'msg'=>'attendancetypeid not a positive integer');

    $dob = clean($rec['dob']);
    $dt = DateTime::createFromFormat('Y-m-d', $dob);
    if (!$dt || $dt->format('Y-m-d') !== $dob)
        return array('status'=>'error','regnum'=>$regnum,'msg'=>"dob must be YYYY-MM-DD (got '".g($rec,'dob')."')");

    $firstnames = cap(strtoupper(clean($rec['firstnames'])), 255);
    $surname    = cap(strtoupper(clean($rec['surname'])), 255);
    if ($firstnames === '') return array('status'=>'error','regnum'=>$regnum,'msg'=>'firstnames empty after cleaning');
    if ($surname === '')    return array('status'=>'error','regnum'=>$regnum,'msg'=>'surname empty after cleaning');

    $title         = clean(g($rec,'title')); $title = $title !== '' ? cap($title,100) : '--';
    $sex           = strtoupper(clean(g($rec,'sex'))); if (!in_array($sex, array('MALE','FEMALE'))) $sex = '--';
    $maritalstatus = strtoupper(clean(g($rec,'maritalstatus'))); $maritalstatus = $maritalstatus !== '' ? cap($maritalstatus,20) : '--';
    $nationality   = clean(g($rec,'nationality')); $nationality = $nationality !== '' ? cap($nationality,200) : '--';
    $placeofbirth  = clean(g($rec,'placeofbirth')); $placeofbirth = $placeofbirth !== '' ? cap($placeofbirth,150) : '--';
    $citizenship   = clean(g($rec,'citizenship')); $citizenship = $citizenship !== '' ? cap($citizenship,200) : $nationality;
    $permanent     = isset($rec['permanent']) ? $rec['permanent'] : 1; $permanent = ((int)$permanent === 0) ? 0 : 1;
    $nationalid    = cap(clean(g($rec,'nationalid')),200);
    $passport      = cap(clean(g($rec,'passport')),100);
    $sponsor       = clean(g($rec,'sponsor')); $sponsor = $sponsor !== '' ? cap($sponsor,100) : '--';
    $address       = clean(g($rec,'address'));
    $mobile        = cap(clean(g($rec,'mobile')),100);
    $home          = cap(clean(g($rec,'home')),100);
    $email         = clean(g($rec,'email'));
    if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) $email = '';
    $email         = cap($email,100);

    $check = $conn->query("SELECT id FROM student WHERE regnum='" . $conn->real_escape_string($regnum) . "'");
    if ($check === false) return array('status'=>'error','regnum'=>$regnum,'msg'=>'lookup failed: '.$conn->error);
    if ($check->num_rows > 0) { $row = $check->fetch_assoc(); return array('status'=>'skipped','id'=>$row['id'],'regnum'=>$regnum); }

    $ir = $conn->query("SELECT id FROM intake WHERE programmeid=$programmeid AND attendancetypeid=$attendancetypeid LIMIT 1");
    if ($ir === false) return array('status'=>'error','regnum'=>$regnum,'msg'=>'intake lookup failed: '.$conn->error);
    if ($ir->num_rows == 0) return array('status'=>'error','regnum'=>$regnum,'msg'=>"no intake for programmeid=$programmeid attendancetypeid=$attendancetypeid");
    $intakeRow = $ir->fetch_assoc(); $intakeid = (int)$intakeRow['id'];

    $e = function($v) use ($conn) { return $conn->real_escape_string($v); };
    $rg=$e($regnum);$fn=$e($firstnames);$sn=$e($surname);$db=$e($dob);$ti=$e($title);$sx=$e($sex);$ms=$e($maritalstatus);
    $na=$e($nationality);$pb=$e($placeofbirth);$ci=$e($citizenship);$ni=$e($nationalid);$pp=$e($passport);$sp=$e($sponsor);
    $ad=$e($address);$mo=$e($mobile);$ho=$e($home);$em=$e($email);

    $conn->autocommit(false);   /* PHP 5.5-safe transaction control */
    $ok = true; $failSql = '';
    $steps = array(
        "INSERT INTO student (regnum,firstnames,surname) VALUES ('$rg','$fn','$sn')",
    );
    $ok = $conn->query($steps[0]); if (!$ok) $failSql = 'student';
    $sid = $conn->insert_id;
    if ($ok) { $ok = $conn->query("INSERT INTO programmesession (studentid,intakeid) VALUES ($sid,$intakeid)"); if (!$ok) $failSql='programmesession'; }
    if ($ok) { $ok = $conn->query("INSERT INTO student_personal (id,dob,title,religion,sex,maritalstatus) VALUES ($sid,'$db','$ti','--','$sx','$ms')"); if (!$ok) $failSql='student_personal'; }
    if ($ok) { $ok = $conn->query("INSERT INTO student_national (id,nationality,placeofbirth,citizenship,permanent) VALUES ($sid,'$na','$pb','$ci',$permanent)"); if (!$ok) $failSql='student_national'; }
    if ($ok && $ni !== '') { $ok = $conn->query("INSERT INTO student_nationalid (id,nationalid) VALUES ($sid,'$ni')"); if (!$ok) $failSql='student_nationalid'; }
    if ($ok) { $ok = $conn->query("INSERT INTO student_sponsorship (id,sponsor,staffdependent,staffmember) VALUES ($sid,'$sp',0,NULL)"); if (!$ok) $failSql='student_sponsorship'; }
    if ($ok && $ad !== '') { $ok = $conn->query("INSERT INTO studentaddress (studentid,addresstype,address,active) VALUES ($sid,'homeaddress','$ad',1)"); if (!$ok) $failSql='studentaddress'; }
    if ($ok && $mo !== '') { $ok = $conn->query("INSERT INTO studentphonenumber (studentid,phonetype,phonenumber,active) VALUES ($sid,'mobile','$mo',1)"); if (!$ok) $failSql='studentphonenumber(mobile)'; }
    if ($ok && $ho !== '') { $ok = $conn->query("INSERT INTO studentphonenumber (studentid,phonetype,phonenumber,active) VALUES ($sid,'home','$ho',1)"); if (!$ok) $failSql='studentphonenumber(home)'; }
    if ($ok && $em !== '') { $ok = $conn->query("INSERT INTO studentemail (studentid,email,active) VALUES ($sid,'$em',1)"); if (!$ok) $failSql='studentemail'; }
    if ($ok && $pp !== '') { $ok = $conn->query("INSERT INTO student_passport (id,passport) VALUES ($sid,'$pp')"); if (!$ok) $failSql='student_passport'; }

    if ($ok) { $conn->commit(); $conn->autocommit(true); return array('status'=>'created','id'=>$sid,'regnum'=>$regnum); }
    $err = $conn->error; $conn->rollback(); $conn->autocommit(true);
    return array('status'=>'error','regnum'=>$regnum,'msg'=>"insert into $failSql failed, rolled back: $err");
}

/* ---------------- AJAX batch endpoint ---------------- */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_GET['action']) && $_GET['action'] === 'process') {
    header('Content-Type: application/json; charset=utf-8');
    $conn = @new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $DB_PORT);
    if ($conn->connect_error) { echo json_encode(array('fatal' => 'DB connection failed: ' . $conn->connect_error)); exit; }
    $conn->set_charset('latin1');

    $raw = file_get_contents('php://input');
    $batch = json_decode($raw, true);
    if (!is_array($batch)) { echo json_encode(array('fatal' => 'invalid batch payload (not a JSON array)')); exit; }

    $out = array('created' => 0, 'skipped' => 0, 'errors' => array());
    foreach ($batch as $rec) {
        $res = process_one($conn, $rec);
        if ($res['status'] === 'created') $out['created']++;
        elseif ($res['status'] === 'skipped') $out['skipped']++;
        else $out['errors'][] = array('regnum' => isset($res['regnum']) ? $res['regnum'] : '?', 'msg' => $res['msg']);
    }
    $conn->close();
    echo json_encode($out);
    exit;
}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>HEIMS — Import Applicants</title>
<style>
 body{font-family:sans-serif;max-width:820px;margin:32px auto;color:#222}
 h2{margin-bottom:4px}
 .box{border:1px solid #ddd;border-radius:8px;padding:16px;margin-top:16px}
 progress{width:100%;height:22px}
 .counts span{display:inline-block;margin-right:18px;font-weight:bold}
 .ok{color:#127a1f}.warn{color:#b26a00}.err{color:#c0392b}
 #log{margin-top:12px;max-height:280px;overflow:auto;background:#fbfbfb;border:1px solid #eee;padding:8px;font-family:monospace;font-size:13px;white-space:pre-wrap}
 button{padding:8px 16px;font-size:14px}
</style>
</head>
<body>
<h2>HEIMS — Import Applicants</h2>
<p>Select <code>migrate_students.json</code> (exported from the online-application server) and click Import.</p>

<div class="box">
  <input type="file" id="file" accept=".json,application/json">
  <button id="go">Import</button>
  <div id="status" style="margin-top:12px"></div>
  <progress id="bar" value="0" max="1" style="display:none"></progress>
  <div class="counts" style="margin-top:10px;display:none" id="counts">
    <span class="ok">Created: <span id="c">0</span></span>
    <span class="warn">Skipped: <span id="s">0</span></span>
    <span class="err">Errors: <span id="e">0</span></span>
    <span>Processed: <span id="p">0</span>/<span id="t">0</span></span>
  </div>
  <div id="log"></div>
</div>

<script>
(function(){
  var BATCH = <?php echo (int)$BATCH_HINT; ?>;
  var fileEl=document.getElementById('file'), go=document.getElementById('go');
  var statusEl=document.getElementById('status'), bar=document.getElementById('bar'), counts=document.getElementById('counts');
  var cEl=document.getElementById('c'), sEl=document.getElementById('s'), eEl=document.getElementById('e'), pEl=document.getElementById('p'), tEl=document.getElementById('t');
  var logEl=document.getElementById('log');
  function log(msg, cls){ var d=document.createElement('div'); if(cls)d.className=cls; d.textContent=msg; logEl.appendChild(d); logEl.scrollTop=logEl.scrollHeight; }

  go.onclick=function(){
    if(!fileEl.files.length){ statusEl.textContent='Choose a file first.'; return; }
    go.disabled=true; fileEl.disabled=true; logEl.innerHTML=''; statusEl.textContent='Reading file...';
    var reader=new FileReader();
    reader.onerror=function(){ statusEl.innerHTML='<span class="err">Could not read the file.</span>'; go.disabled=false; fileEl.disabled=false; };
    reader.onload=function(){
      var data;
      try { data=JSON.parse(reader.result); }
      catch(ex){ statusEl.innerHTML='<span class="err">Invalid JSON: '+ex.message+'</span>'; go.disabled=false; fileEl.disabled=false; return; }
      var list = (data && data.students) ? data.students : (Array.isArray(data)? data : null);
      if(!list){ statusEl.innerHTML='<span class="err">No "students" array found in the file.</span>'; go.disabled=false; fileEl.disabled=false; return; }
      runBatches(list);
    };
    reader.readAsText(fileEl.files[0]);
  };

  function runBatches(list){
    var total=list.length, i=0, created=0, skipped=0, errors=0;
    bar.style.display='block'; counts.style.display='block'; bar.max=total; tEl.textContent=total;
    statusEl.textContent='Importing '+total+' records...';

    function nextBatch(){
      if(i>=total){
        statusEl.innerHTML='<b>Done.</b> Created '+created+', skipped '+skipped+', errors '+errors+'.';
        go.disabled=false; fileEl.disabled=false; return;
      }
      var slice=list.slice(i, i+BATCH);
      fetch('?action=process', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(slice)})
        .then(function(r){ return r.text(); })
        .then(function(txt){
          var res;
          try { res=JSON.parse(txt); }
          catch(ex){ throw new Error('Bad server response: '+txt.slice(0,300)); }
          if(res.fatal){ throw new Error(res.fatal); }
          created+=res.created; skipped+=res.skipped; errors+=res.errors.length;
          for(var k=0;k<res.errors.length;k++){ log('ERROR '+res.errors[k].regnum+': '+res.errors[k].msg, 'err'); }
          i+=slice.length;
          bar.value=i; cEl.textContent=created; sEl.textContent=skipped; eEl.textContent=errors; pEl.textContent=i;
          nextBatch();
        })
        .catch(function(err){
          statusEl.innerHTML='<span class="err">Stopped: '+err.message+'</span>';
          log('FATAL: '+err.message+' (batch starting at record '+(i+1)+')','err');
          go.disabled=false; fileEl.disabled=false;
        });
    }
    nextBatch();
  }
})();
</script>
</body>
</html>
