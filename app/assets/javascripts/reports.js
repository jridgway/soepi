$(document).ready(function() {
  if(controller_name == 'reports') {
    $('#delete').click(function() {
      $('#delete-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-delete').click(function() {
      $('#delete-message').dialog('destroy');
    });
    $('#publish').click(function() {
      $('#publish-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-publish').click(function() {
      $('#publish-message').dialog('destroy');
    });
    $('#forkit').click(function() {
      $('#forkit-message').dialog({width:520, height:200, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-forkit').click(function() {
      $('#forkit-message').dialog('destroy');
    }); 
  }
  if(controller_name == 'reports' && action_name == 'code' ) {
    init_code_editor(false);
  }
  if(controller_name == 'reports' && action_name == 'view_code' ) {
    init_code_editor(true);
  }
});

function init_code_editor(readOnly, val) {
  editor = CodeMirror(document.getElementById('cm-editor'), {
    mode: 'r',
    matchBrackets: true,
    theme: 'night',
    lineNumbers: true,
    electricChars: true,
    readOnly: readOnly,
    copy: true
  });
  if(val) {
    editor.setValue(val);
  } else {
    editor.setValue($('#report_code').val());
  }
  $('#report-save-and-run, #report-save-and-continue, #report-save-and-exit').submit(function() {
    $('body').append('<div id="please-wait">Please wait...</div>');
    $('input[name="report[code]"]').val(editor.getValue());
  });
}

function check_ec2(job_id) {
  $.ajax({
    type: 'PUT',
    url: 'save_and_run?job_id=' + job_id,
    dataType: 'script'
  });
}