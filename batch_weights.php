<?php
session_start();
include '../db.php';
require_once __DIR__ . '/weights_lib.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Build the module list once; used for both the report labels and the checklist.
$modules = loadModules($conn);

$results = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && (!empty($_POST['module_ids']) || !empty($_POST['all_modules']))) {
    // "Select all" posts a single flag, not 1000+ checkboxes — otherwise PHP's
    // max_input_vars (default 1000) silently drops every module past the 1000th.
    if (!empty($_POST['all_modules'])) {
        $selected = array_keys($modules);
    } else {
        $selected = array_map('intval', (array) $_POST['module_ids']);
        // Guard against a truncated POST: if the count hit the ceiling, the
        // browser almost certainly sent more than arrived. Fail loud, don't
        // half-apply and report success.
        $cap = (int) ini_get('max_input_vars');
        if ($cap && count($selected) >= $cap) {
            die("Too many modules selected at once (PHP max_input_vars = $cap). "
              . "Use 'Select all modules' or select fewer than $cap at a time.");
        }
    }

    foreach ($selected as $mid) {
        $results[] = processModule($conn, $mid, $modules);
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Batch Update Weights - HIT Academics System</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
    .container { max-width: 700px; margin: 40px auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,.1); }
    h2 { text-align: center; color: #333; }
    #filter { width: 100%; padding: 10px; margin: 10px 0; box-sizing: border-box; }
    .list { max-height: 360px; overflow-y: auto; border: 1px solid #ddd; border-radius: 4px; padding: 8px; }
    .list label { display: block; padding: 4px 2px; }
    .bar { display: flex; gap: 10px; align-items: center; margin: 10px 0; }
    button { padding: 10px 16px; background: #4caf50; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background: #45a049; }
    .results { margin-top: 20px; }
    .results li { padding: 6px 0; border-bottom: 1px solid #eee; }
    .ok { color: #2e7d32; } .skip { color: #b26a00; } .err { color: #c62828; }
  </style>
</head>
<body>
<div class="container">
  <h2>Batch Update Weights</h2>

  <?php if ($results): ?>
    <ul class="results">
      <?php foreach ($results as list($label, $status)):
            $cls = strpos($status, 'done') === 0 ? 'ok' : (strpos($status, 'skipped') === 0 ? 'skip' : 'err'); ?>
        <li><strong><?= htmlspecialchars($label) ?></strong>: <span class="<?= $cls ?>"><?= htmlspecialchars($status) ?></span></li>
      <?php endforeach; ?>
    </ul>
    <hr>
  <?php endif; ?>

  <form method="post">
    <input id="filter" placeholder="Filter modules…">
    <div class="bar">
      <label><input type="checkbox" id="all"> Select all (visible)</label>
      <label><input type="checkbox" name="all_modules" value="1" id="allModules"> <strong>Select ALL modules</strong> (every module, ignores filter)</label>
    </div>
    <div class="list" id="list">
      <?php foreach ($modules as $id => $label): ?>
        <label><input type="checkbox" name="module_ids[]" value="<?= $id ?>"> <?= htmlspecialchars($label) ?></label>
      <?php endforeach; ?>
    </div>
    <div class="bar">
      <button type="submit">Update weights for selected modules</button>
    </div>
  </form>
</div>

<script>
  const list = document.getElementById('list');
  document.getElementById('filter').oninput = e => {
    const q = e.target.value.toLowerCase();
    list.querySelectorAll('label').forEach(l =>
      l.style.display = l.textContent.toLowerCase().includes(q) ? '' : 'none');
  };
  document.getElementById('all').onchange = e => {
    list.querySelectorAll('label').forEach(l => {
      if (l.style.display !== 'none') l.querySelector('input').checked = e.target.checked;
    });
  };
</script>
</body>
</html>
