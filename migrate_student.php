<?php
// migrate_student.php — push ONE enrolled applicant into HEIMS.
// Validates and sanitizes ALL input BEFORE any row is written.
// Inserts are wrapped in a transaction: a student is loaded in full or not at all.

// Consolidated WampServer MySQL 8.4.7 on 3306 (holds heims + the 770). For staging, switch host/port/creds.
$conn = new mysqli("127.0.0.1", "root", "", "heims", 3306);
if ($conn->connect_error) { http_response_code(500); die("error: db connection failed"); }
$conn->set_charset("latin1"); // heims tables are latin1

// ---------- helpers ----------
// trim, fold common UTF-8 smart punctuation to ASCII, then down-convert to latin1
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
function fail($msg, $code) { http_response_code($code); echo "error: $msg"; exit; }

$in = $_POST;

// ---------- VALIDATE (no insert happens until this all passes) ----------
$errors = array();

// required, non-empty
$required = array('regnum', 'firstnames', 'surname', 'programmeid', 'attendancetypeid', 'dob');
foreach ($required as $k) {
    if (!isset($in[$k]) || trim((string)$in[$k]) === '') $errors[] = "missing required field: $k";
}
if (!empty($errors)) fail(implode('; ', $errors), 400);

$regnum = clean($in['regnum']);
if (!preg_match('/^[A-Za-z0-9]{1,50}$/', $regnum))
    $errors[] = "regnum must be 1-50 alphanumeric characters";

$programmeid = filter_var($in['programmeid'], FILTER_VALIDATE_INT);
if ($programmeid === false || $programmeid <= 0) $errors[] = "programmeid must be a positive integer";

$attendancetypeid = filter_var($in['attendancetypeid'], FILTER_VALIDATE_INT);
if ($attendancetypeid === false || $attendancetypeid <= 0) $errors[] = "attendancetypeid must be a positive integer";

$dob = clean($in['dob']);
$dt = DateTime::createFromFormat('Y-m-d', $dob);
if (!$dt || $dt->format('Y-m-d') !== $dob) $errors[] = "dob must be a valid date (YYYY-MM-DD)";

$firstnames = cap(strtoupper(clean($in['firstnames'])), 255);
$surname    = cap(strtoupper(clean($in['surname'])), 255);
if ($firstnames === '') $errors[] = "firstnames is empty after cleaning";
if ($surname === '')    $errors[] = "surname is empty after cleaning";

if (!empty($errors)) fail(implode('; ', $errors), 400);

// optional fields: clean, default, and length-guard to their column sizes
$title         = clean(isset($in['title']) ? $in['title'] : '');         $title = $title !== '' ? cap($title, 100) : '--';
$sex           = strtoupper(clean(isset($in['sex']) ? $in['sex'] : ''));  if (!in_array($sex, array('MALE', 'FEMALE'))) $sex = '--';
$maritalstatus = strtoupper(clean(isset($in['maritalstatus']) ? $in['maritalstatus'] : '')); $maritalstatus = $maritalstatus !== '' ? cap($maritalstatus, 20) : '--';
$nationality   = clean(isset($in['nationality']) ? $in['nationality'] : ''); $nationality = $nationality !== '' ? cap($nationality, 200) : '--';
$placeofbirth  = clean(isset($in['placeofbirth']) ? $in['placeofbirth'] : ''); $placeofbirth = $placeofbirth !== '' ? cap($placeofbirth, 150) : '--';
$citizenship   = clean(isset($in['citizenship']) ? $in['citizenship'] : ''); $citizenship = $citizenship !== '' ? cap($citizenship, 200) : $nationality;
$permanent     = isset($in['permanent']) ? (int)$in['permanent'] : 1; if ($permanent !== 0 && $permanent !== 1) $permanent = 1;
$nationalid    = cap(clean(isset($in['nationalid']) ? $in['nationalid'] : ''), 200);
$passport      = cap(clean(isset($in['passport']) ? $in['passport'] : ''), 100);
$sponsor       = clean(isset($in['sponsor']) ? $in['sponsor'] : ''); $sponsor = $sponsor !== '' ? cap($sponsor, 100) : '--';
$address       = clean(isset($in['address']) ? $in['address'] : '');
$mobile        = cap(clean(isset($in['mobile']) ? $in['mobile'] : ''), 100);
$home          = cap(clean(isset($in['home']) ? $in['home'] : ''), 100);
$email         = clean(isset($in['email']) ? $in['email'] : '');
if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) $email = ''; // drop a bad email, don't reject the student
$email         = cap($email, 100);

// ---------- idempotency: skip a regnum that already exists ----------
$check = $conn->query("SELECT id FROM student WHERE regnum='" . $conn->real_escape_string($regnum) . "'");
if ($check && $check->num_rows > 0) { $r = $check->fetch_assoc(); echo "skipped " . $r['id']; exit; }

// ---------- the programme/attendance combo must map to a real intake ----------
$ir = $conn->query("SELECT id FROM intake WHERE programmeid=$programmeid AND attendancetypeid=$attendancetypeid LIMIT 1");
if (!$ir || $ir->num_rows == 0) fail("no intake for programmeid=$programmeid attendancetypeid=$attendancetypeid", 422);
$intakeid = (int)$ir->fetch_assoc()['id'];

// ---------- SANITIZE for SQL: escape every string value ----------
$rg = $conn->real_escape_string($regnum);
$fn = $conn->real_escape_string($firstnames);
$sn = $conn->real_escape_string($surname);
$db = $conn->real_escape_string($dob);
$ti = $conn->real_escape_string($title);
$sx = $conn->real_escape_string($sex);
$ms = $conn->real_escape_string($maritalstatus);
$na = $conn->real_escape_string($nationality);
$pb = $conn->real_escape_string($placeofbirth);
$ci = $conn->real_escape_string($citizenship);
$ni = $conn->real_escape_string($nationalid);
$pp = $conn->real_escape_string($passport);
$sp = $conn->real_escape_string($sponsor);
$ad = $conn->real_escape_string($address);
$mo = $conn->real_escape_string($mobile);
$ho = $conn->real_escape_string($home);
$em = $conn->real_escape_string($email);

// ---------- insert: all-or-nothing ----------
$conn->begin_transaction();
$ok = true;

$ok = $ok && $conn->query("INSERT INTO student (regnum,firstnames,surname) VALUES ('$rg','$fn','$sn')");
$sid = $conn->insert_id;

$ok = $ok && $conn->query("INSERT INTO programmesession (studentid,intakeid) VALUES ($sid,$intakeid)");
$ok = $ok && $conn->query("INSERT INTO student_personal (id,dob,title,religion,sex,maritalstatus) VALUES ($sid,'$db','$ti','--','$sx','$ms')");
$ok = $ok && $conn->query("INSERT INTO student_national (id,nationality,placeofbirth,citizenship,permanent) VALUES ($sid,'$na','$pb','$ci',$permanent)");
if ($ok && $ni !== '') $ok = $conn->query("INSERT INTO student_nationalid (id,nationalid) VALUES ($sid,'$ni')");
$ok = $ok && $conn->query("INSERT INTO student_sponsorship (id,sponsor,staffdependent,staffmember) VALUES ($sid,'$sp',0,NULL)");
if ($ok && $ad !== '') $ok = $conn->query("INSERT INTO studentaddress (studentid,addresstype,address,active) VALUES ($sid,'homeaddress','$ad',1)");
if ($ok && $mo !== '') $ok = $conn->query("INSERT INTO studentphonenumber (studentid,phonetype,phonenumber,active) VALUES ($sid,'mobile','$mo',1)");
if ($ok && $ho !== '') $ok = $conn->query("INSERT INTO studentphonenumber (studentid,phonetype,phonenumber,active) VALUES ($sid,'home','$ho',1)");
if ($ok && $em !== '') $ok = $conn->query("INSERT INTO studentemail (studentid,email,active) VALUES ($sid,'$em',1)");
if ($ok && $pp !== '') $ok = $conn->query("INSERT INTO student_passport (id,passport) VALUES ($sid,'$pp')");

if ($ok) {
    $conn->commit();
    echo "created " . $sid;
} else {
    $err = $conn->error;
    $conn->rollback();
    http_response_code(500);
    echo "error: insert failed, rolled back - " . $err;
}
$conn->close();
?>
