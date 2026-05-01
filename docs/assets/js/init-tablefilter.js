document.addEventListener("DOMContentLoaded", function () {

  // Determine which table we're dealing with
  const appTable = document.getElementById('appTable');
  const datasetTable = document.getElementById('datasetTable');
  const tableId = appTable ? 'appTable' : (datasetTable ? 'datasetTable' : null);
  
  if (!tableId) return;  // No table found on this page
  
  const isDatasetTable = tableId === 'datasetTable';

  // Count visible tbody rows directly from the DOM (reliable after any filter)
  function updateCounter() {
    const span = document.getElementById('tf-row-counter');
    if (!span) return;
    const table = document.getElementById(tableId);
    if (!table) return;
    let count = 0;
    table.querySelectorAll('tbody tr').forEach(function (row) {
      if (row.style.display !== 'none') count++;
    });
    span.textContent = isDatasetTable ? 'Dataset(s): ' + count : 'Application(s): ' + count;
  }

  var tf = new TableFilter(tableId, {
    base_path: '/assets/js/tablefilter/',
    paging: false,
    rows_counter: false,
    btn_reset: false,
    mark_active_columns: true,
    highlight_keywords: true,
    col_0: 'input',              // Application/Dataset → text input
    col_1: 'input',             // Topic/Category → text input
    col_2: 'input',             // Available at/Discipline → text input
    alternate_rows: false,
    themes: [{ name: 'transparent'}],
    extensions: [],
    watermark: isDatasetTable 
      ? ['Start typing...', 'Category...', 'Discipline...']
      : ['Start typing...', 'Topic...', 'Avalable cluster...'],
    auto_filter: { delay: 100 },
    msg_filter: 'Filtering...',
    help_instructions: false,
    on_after_filter: updateCounter  // fires after every filter operation
  });

  tf.init();

  // Helper: build a small dropdown (select) of unique tokens for a column,
  // place it next to the column's input filter and wire it so selecting a token
  // sets the input value and triggers filtering.
  function buildTokensDropdown(colIndex, placeholderText) {
    const table = document.getElementById(tableId);
    if (!table) return;

    // collect unique tokens from the column (split by comma)
    const tokensSet = new Set();
    const tbody = table.tBodies[0];
    if (!tbody) return;
    for (let r = 0; r < tbody.rows.length; r++) {
      const cell = tbody.rows[r].cells[colIndex];
      if (!cell) continue;
      const txt = (cell.textContent || cell.innerText || '').trim();
      if (!txt) continue;
      txt.split(',').map(s => s.trim()).filter(Boolean).forEach(t => tokensSet.add(t));
    }
    if (tokensSet.size === 0) return;

    const tokens = Array.from(tokensSet).sort((a,b) =>
      a.localeCompare(b, undefined, { sensitivity: 'base' })
    );

    const fltRow = table.querySelector('.fltrow') || (table.tHead && table.tHead.rows[0]);
    if (!fltRow) return;
    const fltCell = fltRow.cells[colIndex];
    if (!fltCell) return;

    const select = document.createElement('select');
    select.className = 'tf-token-select';
    select.setAttribute('aria-label', placeholderText || 'Select filter token');

    const emptyOpt = document.createElement('option');
    emptyOpt.value = '';
    emptyOpt.textContent = placeholderText || '—';
    select.appendChild(emptyOpt);

    tokens.forEach(tok => {
      const opt = document.createElement('option');
      opt.value = tok;
      opt.textContent = tok;
      select.appendChild(opt);
    });

    select.style.marginLeft = '6px';
    select.style.fontSize = '0.9em';
    select.style.padding = '2px 4px';

    fltCell.appendChild(select);

    select.addEventListener('change', function () {
      const inp = fltCell.querySelector('input');
      if (!inp) return;
      inp.value = this.value || '';
      inp.dispatchEvent(new Event('input', { bubbles: true }));
      tf.filter();
    });
  }

  // Show dropdowns for both tables - different columns for each
  if (isDatasetTable) {
    buildTokensDropdown(1, 'Any Category');
    buildTokensDropdown(2, 'Any Discipline');
  } else {
    buildTokensDropdown(1, 'Any Topic');
    buildTokensDropdown(2, 'Any Cluster');
  }

  // Inject counter span into the first filter cell, below "Start typing..."
  function setupInlineCounter() {
    const table = document.getElementById(tableId);
    if (!table) return;
    const fltRow = table.querySelector('.fltrow');
    if (!fltRow) return;
    const firstCell = fltRow.cells[0];
    if (!firstCell) return;

    const counterSpan = document.createElement('span');
    counterSpan.id = 'tf-row-counter';
    firstCell.appendChild(counterSpan);

    updateCounter();
  }

  setupInlineCounter();
});
