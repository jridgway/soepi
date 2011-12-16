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

function init_code_editor(val) {
  editor = CodeMirror(document.getElementById('cm-editor'), {
    mode: 'r',
    matchBrackets: true,
    theme: 'night',
    lineNumbers: true,
    firstLineNumber: editor2.lineCount() + 1,
    electricChars: true,
    extraKeys: {"Ctrl-Space": function(cm) {CodeMirror.simpleHint(cm, CodeMirror.rHint);}}
  });
  if(val) {
    editor.setValue(val);
  } else {
    editor.setValue($('#r_script_code').val());
  }
  $('#r-script-save-and-run, #r-script-save-and-continue, #r-script-save-and-exit').submit(function() {
    $('body').append('<div id="please-wait">Please wait...</div>');
    $('input[name="r_script[code]"]').val(editor.getValue());
  });
  $('#show-inputs-code-a').click(function() {
    $('#cm-editor-inputs-code-editor').show('blind');
    $(this).hide();
    $('#hide-inputs-code-a').show();
  });
  $('#hide-inputs-code-a').click(function() {
    $('#cm-editor-inputs-code-editor').hide('blind');
    $(this).hide();
    $('#show-inputs-code-a').show();
  });
}

function check_ec2(report_id) {
  $.ajax({
    type: 'PUT',
    url: $('#run-btn').attr('href') + '?report_id=' + report_id,
    dataType: 'script'
  });
}

var surveys_auto_complete_cache = [];

function init_r_script_input_form() {
  $('#r_script_input_itype').change(function() {
    if($(this).val() == 'Survey results') {
      $('#default-survey').show();
      $('#default-character').hide();
      $('#default-numeric').hide();
    } else if($(this).val() == 'Character') {
      $('#default-survey').hide();
      $('#default-character').show();
      $('#default-numeric').hide();
    } else if($(this).val() == 'Numeric') {
      $('#default-survey').hide();
      $('#default-character').hide();
      $('#default-numeric').show();
    }
  });
  $('#r_script_input_itype').change();
  $('#r_script_input_survey_label').autocomplete({
    minLength: 2,
    delay: 100,
    source: function(request, response) {
      var term = request.term;
      if(term in surveys_auto_complete_cache) {
        response(surveys_auto_complete_cache[term]);
        return;
      }
      lastXhr = $.getJSON('inputs/surveys_auto_complete.js', request, function(data, status, xhr) {
        surveys_auto_complete_cache[term] = data;
        if(xhr === lastXhr) {
          response(data);
        }
      });
    },
    focus: function(item) {
     return false;
    },
    select: function(event, ui) {
      $('#r_script_input_survey_id').val(ui.item.value);
      $('#r_script_input_survey_label').val(ui.item.label);
      return false;
    },
    change: function(event, ui) {
      if(!ui.item) {
        $('#r_script_input_survey_id').val('');
        $('#r_script_input_survey_label').val('');
      }
    }
  })
  .data("autocomplete")._renderItem = function(ul, item) {
    return $("<li></li>")
      .data("item.autocomplete", item)
      .append('<a>' + item.logo + '<h4>' + item.label + '</h4><small>' + item.description + '</small></a>')
      .appendTo(ul);
  };
}

function init_multiple_r_script_input_forms(count) {
  for(var i=0; i < count; i++) {
    var hidden_field = '#r_script_inputs_attributes_' + i + '_survey_id';
    var label_field = '#r_script_inputs_attributes_' + i + '_survey_label';
    $(label_field).autocomplete({
      minLength: 2,
      delay: 100,
      source: function(request, response) {
        var term = request.term;
        if(term in surveys_auto_complete_cache) {
          response(surveys_auto_complete_cache[term]);
          return;
        }
        lastXhr = $.getJSON('inputs/surveys_auto_complete.js', request, function(data, status, xhr) {
          surveys_auto_complete_cache[term] = data;
          if(xhr === lastXhr) {
            response(data);
          }
        });
      },
      focus: function(item) {
       return false;
      },
      select: function(event, ui) {
        $(hidden_field).val(ui.item.value);
        $(this).val(ui.item.label);
        return false;
      }
    })
    .keydown(function() {
      $(hidden_field).val('');
    })
    .data("autocomplete")._renderItem = function(ul, item) {
      return $("<li></li>")
        .data("item.autocomplete", item)
        .append('<a>' + item.logo + '<h4>' + item.label + '</h4><small>' + item.description + '</small></a>')
        .appendTo(ul);
    };
  }
}
