// Accessibility fixes for Material for MkDocs elements that cannot be
// patched via template overrides (generated in base.html).
document.addEventListener("DOMContentLoaded", function () {
  // base.html override changed <label class="md-overlay"> to <div role="button">.
  // This block is kept as a no-op fallback in case an older cached build serves
  // the original label — it removes the for= attribute so no orphaned/multiple
  // label errors appear even on stale builds.
  var overlay = document.querySelector("label.md-overlay");
  if (overlay) {
    overlay.removeAttribute("for");
  }

  // Headerlink anchors (¶) are purely decorative: the heading's id attribute
  // is the actual anchor target. Material hides them with opacity:0 by default,
  // but WAVE evaluates opacity-0 elements and flags the low-contrast rgba color.
  // Mark as aria-hidden + tabindex=-1 so contrast tools skip them and screen
  // readers do not announce "¶" for every heading.
  document.querySelectorAll(".md-typeset .headerlink").forEach(function (el) {
    el.setAttribute("aria-hidden", "true");
    el.setAttribute("tabindex", "-1");
  });
});
