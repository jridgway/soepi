$(document).ready(function() {
  if(controller_name == 'reports') {
    $('#delete').click(function() {
      $('#delete-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-delete').click(function() {
      $('#delete-message').dialog('destroy');
    });
  }
});