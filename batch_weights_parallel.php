<?php
include '../db.php';
require_once __DIR__ . '/weights_lib.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

// AJAX batch endpoint: process one batch of module ids, return JSON.
// No session_start() here on purpose — PHP serializes requests that share a
// session on the session-file lock, which would turn our parallel batches back
// into a single queue. This page is reached from the same admin area as
// batch_weights.php; if you add auth, validate a token, don't open the session.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Never let a PHP warning/notice print into the body — it would be HTML
    // and corrupt the JSON the browser is parsing. Report failures as JSON.
    ini_set('display_errors', '0');
    // A batch is ~25 modules × ~200 students × 3 tables of upserts, plus
    // deadlock-retry backoff; well past the 30s default. Each batch is bounded
    // by design, so lift the ceiling for this request only.
    set_time_limit(0);
    header('Content-Type: application/json');

    try {
        $body = json_decode(file_get_contents('php://input'), true);
        $ids = array_map('intval', $body['module_ids'] ?? []);
        $modules = loadModules($conn);

        $out = [];
        foreach ($ids as $mid) {
            [$label, $status] = processModule($conn, $mid, $modules);
            $out[] = ['label' => $label, 'status' => $status];
        }
        // Tables are latin1; a stray non-UTF-8 byte in a name would make
        // json_encode return false and blank the body. Substitute, don't fail.
        echo json_encode($out, JSON_INVALID_UTF8_SUBSTITUTE);
    } catch (Throwable $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit;
}

// GET: render the page. Modules go into the page as JS data (not 1000 form
// fields), so max_input_vars never enters into it — batches are posted as JSON.
$modules = loadModules($conn);
$moduleList = [];
foreach ($modules as $id => $label) {
    $moduleList[] = ['id' => $id, 'label' => $label];
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Batch Update Weights (Parallel) - HIT Academics System</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
    .container { max-width: 760px; margin: 40px auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,.1); }
    h2 { text-align: center; color: #333; }
    .bar { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin: 12px 0; }
    label.cfg { font-size: 14px; color: #555; }
    input[type=number] { width: 70px; padding: 6px; }
    button { padding: 10px 16px; background: #4caf50; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
    button:disabled { background: #9e9e9e; cursor: default; }
    button:hover:not(:disabled) { background: #45a049; }
    #progress { margin: 14px 0; font-weight: bold; }
    #bar-outer { height: 14px; background: #eee; border-radius: 7px; overflow: hidden; margin: 8px 0 16px; }
    #bar-inner { height: 100%; width: 0; background: #4caf50; transition: width .2s; }
    .results { list-style: none; padding: 0; }
    .batch { border: 1px solid #ddd; border-radius: 4px; margin-bottom: 8px; }
    .batch > .head { padding: 8px 10px; font-weight: bold; background: #fafafa; border-radius: 4px 4px 0 0; }
    .batch.pending > .head { background: #fafafa; }
    .batch.running > .head { background: #e3f2fd; }
    .batch.done > .head { background: #f1f8e9; }
    .rows { list-style: none; margin: 0; padding: 0; }
    .rows li { padding: 4px 12px; border-top: 1px solid #f0f0f0; font-size: 13px; display: flex; justify-content: space-between; gap: 10px; }
    .rows .st { white-space: nowrap; }
    .pending-txt { color: #999; } .running { color: #1565c0; } .ok { color: #2e7d32; } .skip { color: #b26a00; } .err { color: #c62828; }
    .toggle { cursor: pointer; font-size: 12px; color: #1565c0; text-decoration: underline; font-weight: normal; margin-left: 8px; }
  </style>
</head>
<body>
<div class="container">
  <h2>Batch Update Weights — Parallel</h2>
  <p style="text-align:center;color:#666">Processes <strong><?= count($moduleList) ?></strong> modules in parallel batches. Each batch reports back as it finishes.</p>

  <div class="bar">
    <label class="cfg">Batch size <input type="number" id="batchSize" value="25" min="1" max="500"></label>
    <label class="cfg">Parallel batches <input type="number" id="pool" value="4" min="1" max="10"></label>
    <button id="start">Start update</button>
  </div>

  <div id="progress">Idle.</div>
  <div id="bar-outer"><div id="bar-inner"></div></div>
  <ul class="results" id="results"></ul>
</div>

<script>
  const MODULES = <?= json_encode($moduleList, JSON_INVALID_UTF8_SUBSTITUTE) ?>;

  const $ = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
  const cls = s => s.startsWith('done') ? 'ok' : s.startsWith('skipped') ? 'skip' : 'err';
  const chunk = (a, n) => { const o = []; for (let i = 0; i < a.length; i += n) o.push(a.slice(i, i + n)); return o; };

  let batches = [];      // array of arrays of {id,label}
  let rowEls = [];       // rowEls[batchIndex][j] = <li> for that course
  let batchEls = [];     // batchEls[batchIndex] = { box, head, list }

  // Pre-render every course grouped into batches, all "pending". Re-runs
  // whenever batch size changes so the preview matches what Start will do.
  function preview() {
    const size = Math.max(1, parseInt($('batchSize').value, 10) || 25);
    batches = chunk(MODULES, size);
    rowEls = [];
    batchEls = [];
    $('results').innerHTML = '';

    batches.forEach((batch, i) => {
      const box = document.createElement('li');
      box.className = 'batch pending';

      const head = document.createElement('div');
      head.className = 'head';
      head.innerHTML = `Batch ${i + 1} — ${batch.length} courses <span class="st pending-txt">pending</span>` +
                       `<span class="toggle">hide/show</span>`;

      const list = document.createElement('ul');
      list.className = 'rows';
      rowEls[i] = batch.map(m => {
        const li = document.createElement('li');
        li.innerHTML = `<span>${esc(m.label)}</span><span class="st pending-txt">pending</span>`;
        list.appendChild(li);
        return li;
      });

      head.querySelector('.toggle').onclick = () =>
        list.style.display = list.style.display === 'none' ? '' : 'none';

      box.appendChild(head);
      box.appendChild(list);
      $('results').appendChild(box);
      batchEls[i] = { box, head, list };
    });

    $('progress').textContent = `${MODULES.length} courses in ${batches.length} batches — ready.`;
    $('bar-inner').style.width = '0';
  }

  function setRow(li, text, klass) {
    li.querySelector('.st').className = 'st ' + klass;
    li.querySelector('.st').textContent = text;
  }

  async function run() {
    preview();  // rebuild fresh from current batch size
    const pool = Math.max(1, parseInt($('pool').value, 10) || 4);
    const total = batches.length;
    let done = 0;

    const update = () => {
      $('progress').textContent = `${done} / ${total} batches complete`;
      $('bar-inner').style.width = (total ? (done / total * 100) : 0) + '%';
    };

    let next = 0;
    async function worker() {
      while (next < batches.length) {
        const i = next++;
        const batch = batches[i];
        const { box, head, list } = batchEls[i];

        box.className = 'batch running';
        head.querySelector('.st').className = 'st running';
        head.querySelector('.st').textContent = 'running…';
        rowEls[i].forEach(li => setRow(li, 'updating…', 'running'));

        try {
          const res = await fetch(location.pathname, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ module_ids: batch.map(m => m.id) })
          });
          const rows = await res.json();  // same order as sent
          if (!res.ok || rows.error) throw new Error(rows.error || ('HTTP ' + res.status));

          let okN = 0, skN = 0, erN = 0;
          rows.forEach((r, j) => {
            const k = cls(r.status);
            k === 'ok' ? okN++ : k === 'skip' ? skN++ : erN++;
            if (rowEls[i][j]) setRow(rowEls[i][j], r.status, k);
          });

          box.className = 'batch done';
          head.querySelector('.st').className = 'st';
          head.querySelector('.st').innerHTML =
            `<span class="ok">${okN} applied</span>, <span class="skip">${skN} skipped</span>` +
            (erN ? `, <span class="err">${erN} error</span>` : '');
        } catch (e) {
          box.className = 'batch';
          head.querySelector('.st').className = 'st err';
          head.querySelector('.st').textContent = `failed — ${e.message} (re-run)`;
          rowEls[i].forEach(li => setRow(li, 'not applied', 'err'));
        }
        done++;
        update();
      }
    }

    $('start').disabled = true;
    $('batchSize').disabled = true;
    $('progress').textContent = 'Starting…';
    await Promise.all(Array.from({ length: pool }, worker));
    $('progress').textContent = `All ${total} batches complete.`;
    $('start').disabled = false;
    $('batchSize').disabled = false;
  }

  $('start').onclick = run;
  $('batchSize').oninput = preview;
  preview();  // show the course list on page load
</script>
</body>
</html>
