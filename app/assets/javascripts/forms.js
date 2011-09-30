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
});