document.addEventListener("DOMContentLoaded", function () {
  var path = window.location.pathname;
  if (path === "/" || path.endsWith("/index.html")) {
    var toc = document.querySelector(".md-sidebar--secondary");
    if (toc) toc.style.display = "none";
    var content = document.querySelector(".md-content");
    if (content) content.style.maxWidth = "100%";
  }
});
