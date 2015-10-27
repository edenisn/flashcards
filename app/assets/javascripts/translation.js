/**
 * Created by edenisn on 10/27/15.
 */
$(document).ready(function() {
  var form = $('#form-translation');

  $(form).submit(function(event) {
    event.preventDefault();

    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      success: function(data) {
        if (data) {
          console.log(data);
          $("p.text-danger").html("Правильно");
        }
        else {
          console.log(data);
          $("p.text-danger").html("Неправильно!");
        }
        setTimeout(function() { location.href = "/reviews/new" }, 1500);
      },
      error: function(data) {
        console.log("There seems to be an error");
      },

      dataType: 'JSON'
    });
  });
});