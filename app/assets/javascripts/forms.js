$(document).ready(function () {
  $('input.tags, textarea.tags').tagit({allowSpaces:true});
  $('#member_ethnicity_ids_1').change(function() {
    if($(this).attr('checked')) {
      $('#member_ethnicity_ids_2, #member_ethnicity_ids_3, ' +
      '#member_ethnicity_ids_4, #member_ethnicity_ids_5').attr('checked', false);
    }
  });
  $('#member_ethnicity_ids_2, #member_ethnicity_ids_3, ' +
  '#member_ethnicity_ids_4, #member_ethnicity_ids_5').change(function() {
    if($(this).attr('checked')) {
      $('#member_ethnicity_ids_1').attr('checked', false);
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
  $('.tagit-new input').autoGrowInput({minWidth:30, maxWidth:520, comfortZone:20})
  $('.tagit-new input').width('30px');
});