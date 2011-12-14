var editor;

$(document).ready(function() {
  if(controller_name == 'r_scripts') {
    $('#delete').click(function() {
      $('#delete-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-delete').click(function() {
      $('#delete-message').dialog('destroy');
    });
    $('#forkit').click(function() {
      $('#forkit-message').dialog({width:520, height:200, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-forkit').click(function() {
      $('#forkit-message').dialog('destroy');
    });
    $('#run-btn').click(function() {
      $('body').append('<div id="please-wait">Please wait...</div>');
    });
  }
  if(controller_name == 'r_scripts' && action_name == 'code' ) {
    init_code_editor();
  }
});

function init_code_editor() {
  editor = CodeMirror(document.getElementById('cm-editor'), {
    mode: 'r',
    matchBrackets: true,
    theme: 'night',
    lineNumbers: true,
    electricChars: true,
    extraKeys: {"Ctrl-Space": function(cm) {CodeMirror.simpleHint(cm, CodeMirror.rHint);}}
  });
  editor.setValue($('#r_script_code').val());
  $('#r-script-save-and-run, #r-script-save-and-continue, #r-script-save-and-exit').submit(function() {
    $('body').append('<div id="please-wait">Please wait...</div>');
    $('input[name="r_script[code]"]').val(editor.getValue());
  });
}

function check_ec2(report_id) {
  $.ajax({
    type: 'PUT',
    url: $('#run-btn').attr('href') + '?report_id=' + report_id,
    dataType: 'script'
  });
}
