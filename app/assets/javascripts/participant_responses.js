$('body').ready(function() {
  $('form.new_participant_response, form.edit_participant_response').live('submit', function() {
    wait();
  });
});