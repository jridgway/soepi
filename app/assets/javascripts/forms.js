$(document).ready(function () {
  setTimeout("focus_first_form_field();", 100);
  $('[placeholder]').defaultValue();
  $('input.tags, textarea.tags').tagit({allowSpaces:true});
  $('input.tags, textarea.tags').each(function() {
    if($(this).closest('.input').find('[placeholder]').length > 0) {
      $(this).closest('.input').find('.tagit-new input').attr(
        'placeholder', $(this).closest('.input').find('[placeholder]').attr('placeholder'));
    };
  });
  $('form.uneditable .tagit-close').remove();
  $('form.uneditable .tagit input:visible').remove();
  $('#participant_ethnicity_ids_1').live('change', function() {
    if($(this).attr('checked')) {
      $('#participant_ethnicity_ids_2, #participant_ethnicity_ids_3, ' +
      '#participant_ethnicity_ids_4, #participant_ethnicity_ids_5').attr('checked', false);
    }
  });
  $('#participant_ethnicity_ids_2, #participant_ethnicity_ids_3, ' +
  '#participant_ethnicity_ids_4, #participant_ethnicity_ids_5').live('change', function() {
    if($(this).attr('checked')) {
      $('#participant_ethnicity_ids_1').attr('checked', false);
    }
  });
  $('.tabs').tabs({
    show: function(event, ui) {
      $('.error2').each(function() {
        $(this).qtip('destroy');
      });
      init_form_errors($('.tabs #' + ui.panel.id + ' .input'));
    }
  });
  var tab_with_errors = $('.tabs .error').first().parents('.ui-tabs-panel').last();
  $(tab_with_errors).closest('.tabs').tabs('select', tab_with_errors.index()-1);
  $('.tagit-new input').autoGrowInput({minWidth:60, maxWidth:520, comfortZone:20})
  $('.tagit-new input').width('60px');
});

function focus_first_form_field() {
  $('form.simple_form:not(.uneditable) input:visible,  form.simple_form:not(.uneditable) textarea:visible').first().each(function() {
    if($(this).attr('placeholder') == undefined) {
      $(this).focus();
    }
  });
}