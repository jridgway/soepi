var city_cache={}, lastXhr;

$(document).ready(function() {
  $('form select.country').live('change', function() {
    $.get('/addresses/states_for_country' +
      '?country=' + $(this).val() + 
      '&field_prefix=' + $(this).attr('data-field-prefix') + 
      '&field_prefix_name=' + $(this).attr('data-field-prefix-name') + 
      '&current_state=' + $(this).attr('data-current-state') + 
      '&field_id=' + $(this).attr('id'));
  });
  $('form select.country').change();
});