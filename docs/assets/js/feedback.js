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

      // Disable the fieldset — triggers :disabled .md-feedback__note { opacity:1 } in CSS
      form.querySelector("fieldset").disabled = true;
      // Unhide the matching note
      notes.forEach(function (note) {
        if (note.getAttribute("data-md-value") === value) {
          note.removeAttribute("hidden");
        }
      });
    });
  });
});
