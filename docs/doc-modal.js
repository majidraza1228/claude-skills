/* Doc viewer modal — fetches a .md file from this site, renders it in a styled popup.
   Usage in any page:
     <link rel="stylesheet" href="doc-modal.css">
     <script src="https://cdn.jsdelivr.net/npm/marked@9/marked.min.js"></script>
     <script src="doc-modal.js" defer></script>
   Then on any link or button:
     <a href="claude-code-setup.md"
        onclick="return openDoc(event, 'claude-code-setup.md', 'Setup — Claude Code')">Setup →</a>
   The href is kept as a fallback if JS is disabled. */

(function () {
  const GH_BASE = 'https://github.com/majidraza1228/claude-skills/blob/main/docs/';
  const COPY_SVG = '<svg width="13" height="13" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="5" width="9" height="9" rx="2"/><path d="M3 11V3a2 2 0 0 1 2-2h8"/></svg>';
  const CHECK_SVG = '<svg width="13" height="13" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="2 8 6 12 14 4"/></svg>';

  const MODAL_HTML = `
    <div class="doc-modal-bg" id="docModalBg" role="dialog" aria-modal="true" aria-label="Document viewer">
      <div class="doc-modal">
        <div class="doc-modal-hd">
          <div class="doc-modal-dots"><s></s><s></s><s></s></div>
          <span class="doc-modal-fname" id="docFname"></span>
          <button class="doc-copy-btn" id="docCopyBtn" type="button">${COPY_SVG} Copy</button>
          <button class="doc-close-btn" id="docCloseBtn" type="button" aria-label="Close">✕</button>
        </div>
        <div class="doc-modal-body">
          <div class="doc-md" id="docMd"></div>
        </div>
        <div class="doc-modal-ft">
          <a id="docGhLink" href="#" class="doc-gh-link" target="_blank" rel="noopener">Open on GitHub ↗</a>
        </div>
      </div>
    </div>`;

  let currentText = '';
  let initialized = false;

  function init() {
    if (initialized) return;
    initialized = true;
    document.body.insertAdjacentHTML('beforeend', MODAL_HTML);
    const bg = document.getElementById('docModalBg');
    document.getElementById('docCloseBtn').addEventListener('click', closeDoc);
    document.getElementById('docCopyBtn').addEventListener('click', copyDoc);
    bg.addEventListener('click', e => { if (e.target === bg) closeDoc(); });
    document.addEventListener('keydown', e => {
      if (e.key === 'Escape' && bg.classList.contains('open')) closeDoc();
    });
  }

  function escapeHtml(s) {
    return s.replace(/[<>&]/g, c => ({ '<': '&lt;', '>': '&gt;', '&': '&amp;' }[c]));
  }

  async function openDoc(event, path, title) {
    if (event && event.preventDefault) event.preventDefault();
    init();
    const md = document.getElementById('docMd');
    const fname = document.getElementById('docFname');
    const gh = document.getElementById('docGhLink');
    const bg = document.getElementById('docModalBg');
    fname.textContent = title || path;
    gh.href = GH_BASE + path;
    md.innerHTML = '<div class="doc-loading">Loading…</div>';
    bg.classList.add('open');
    document.body.style.overflow = 'hidden';
    try {
      const res = await fetch(path);
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const raw = await res.text();
      currentText = raw;
      md.innerHTML = (typeof marked !== 'undefined')
        ? marked.parse(raw)
        : '<pre>' + escapeHtml(raw) + '</pre>';
      md.scrollTop = 0;
    } catch (err) {
      currentText = '';
      md.innerHTML = '<div class="doc-error">Could not load <code>' + escapeHtml(path) + '</code>: ' + escapeHtml(err.message) + '. <a href="' + gh.href + '" target="_blank" rel="noopener">Open on GitHub ↗</a></div>';
    }
    return false;
  }

  function closeDoc() {
    const bg = document.getElementById('docModalBg');
    if (!bg) return;
    bg.classList.remove('open');
    document.body.style.overflow = '';
    document.getElementById('docMd').innerHTML = '';
    currentText = '';
    const btn = document.getElementById('docCopyBtn');
    btn.innerHTML = COPY_SVG + ' Copy';
    btn.classList.remove('copied');
  }

  async function copyDoc() {
    if (!currentText) return;
    const btn = document.getElementById('docCopyBtn');
    try {
      await navigator.clipboard.writeText(currentText);
      btn.innerHTML = CHECK_SVG + ' Copied!';
      btn.classList.add('copied');
      setTimeout(() => {
        btn.innerHTML = COPY_SVG + ' Copy';
        btn.classList.remove('copied');
      }, 2000);
    } catch {
      btn.textContent = 'Copy failed';
    }
  }

  window.openDoc = openDoc;
  window.closeDoc = closeDoc;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
