document.addEventListener("DOMContentLoaded", function () {
  var iconSVG = '<svg class="external-link-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="0.75em" height="0.75em" style="vertical-align:middle;margin-left:0.25em;opacity:0.7" aria-hidden="true"><path fill="currentColor" d="M3.75 2h3.5a.75.75 0 0 1 0 1.5h-3.5a.25.25 0 0 0-.25.25v8.5c0 .138.112.25.25.25h8.5a.25.25 0 0 0 .25-.25v-3.5a.75.75 0 0 1 1.5 0v3.5A1.75 1.75 0 0 1 12.25 14h-8.5A1.75 1.75 0 0 1 2 12.25v-8.5C2 2.784 2.784 2 3.75 2Zm6.854-1h4.146a.25.25 0 0 1 .25.25v4.146a.25.25 0 0 1-.427.177L13.03 4.03 9.28 7.78a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042l3.75-3.75-1.543-1.543A.25.25 0 0 1 10.604 1Z"/></svg>';

  document.querySelectorAll("a[href^='http']").forEach(function (link) {
    // Skip internal links
    if (link.href.indexOf("docs.rcac.purdue.edu") !== -1) return;
    // Skip icon-only links (no visible text — e.g. footer social icons, image links)
    if (!link.textContent.trim()) return;
    // Skip links that already have the external link icon
    if (link.querySelector(".external-link-icon")) return;

    // Open in new tab
    link.setAttribute("target", "_blank");
    link.setAttribute("rel", "noopener noreferrer");

    // Append external link icon
    link.insertAdjacentHTML("beforeend", iconSVG);
  });
});
