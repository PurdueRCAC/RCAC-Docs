document.addEventListener("DOMContentLoaded", function () {
  var form = document.querySelector(".md-feedback");
  if (!form) return;

  // Show the form (template renders it hidden pending JS)
  form.removeAttribute("hidden");

  var buttons = form.querySelectorAll(".md-feedback__icon");
  var notes = form.querySelectorAll(".md-feedback__note [data-md-value]");

  buttons.forEach(function (btn) {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      var value = btn.getAttribute("data-md-value");

      // Hide buttons, show matching note
      form.querySelector(".md-feedback__list").style.display = "none";
      notes.forEach(function (note) {
        if (note.getAttribute("data-md-value") === value) {
          note.removeAttribute("hidden");
        }
      });
    });
  });
});
