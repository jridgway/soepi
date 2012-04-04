$(document).ready(function () {
  $('#member_status_body').focus(function() {
    $('#status-extra').not(':visible').show('blind');
    init_form_tips();
  });
});