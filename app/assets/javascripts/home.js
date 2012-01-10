var notifications_page = 1;

$(document).ready(function () {
  $('#home-accordian').accordion({
    autoHeight: false, 
    navigation: true, 
    collapsible: false, 
    active: 0
  });
  $('#member_status_body').focus(function() {
    $('#status-extra').not(':visible').show('blind');
    init_form_tips();
  });
});