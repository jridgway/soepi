$(document).ready(function() {
  init_survey_form();
  if(controller_name == 'survey_questions') {
    init_survey_question_form();
  }
  init_participate();
  init_global_sidebar();
});

function init_survey_form() {
  $('#survey_irb').change(function () {
    if($(this).attr('checked')) {
      $('#irb-inner').show('blind');
    } else {
      $('#irb-inner').hide('blind');
    }
  }).change();
  $('#survey_organization').change(function () {
    if($(this).attr('checked')) {
      $('#organization-inner').show('blind');
    } else {
      $('#organization-inner').hide('blind');
    }
  }).change();
  $('#survey_cohort').change(function () {
    if($(this).attr('checked')) {
      $('#cohort-inner').show('blind');
    } else {
      $('#cohort-inner').hide('blind');
    }
  }).change();
  init_targeting();
}

function init_participate() {
  $('#participate, #participate2').click(function() {
    setTimeout("disable_button($('#participate'));", 100);
    setTimeout("disable_button($('#participate2'));", 100);
  });
  $('#send-pin').live('click', function() {
    disable_button($(this));
  });
}

function init_global_sidebar() {
  $('#launch').click(function() {
    $('#launch-message').dialog({width:500, height:250, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-launch').click(function() {
    $('#launch-message').dialog('destroy');
  });
  $('#launch2').click(function() {
    $('#launch2-message').dialog({width:500, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-launch2').click(function() {
    $('#launch2-message').dialog('destroy');
  });
  $('#request-changes').click(function() {
    $('#request-changes-message').dialog({width:600, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-request-changes').click(function() {
    $('#request-changes-message').dialog('destroy');
  });
  $('#reject').click(function() {
    $('#reject-message').dialog({width:500, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-reject').click(function() {
    $('#reject-message').dialog('destroy');
  });
  $('#delete').click(function() {
    $('#delete-message').dialog({width:500, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-delete').click(function() {
    $('#delete-message').dialog('destroy');
  });
  $('#close').click(function() {
    $('#close-message').dialog({width:500, height:300, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-close').click(function() {
    $('#close-message').dialog('destroy');
  });
  $('#forkit').click(function() {
    $('#forkit-message').dialog({width:500, height:200, modal:true, zIndex:9, resizable:false}).show('blind');
  });
  $('#cancel-forkit').click(function() {
    $('#forkit-message').dialog('destroy');
  });
}

function init_survey_question_form() {
  $('#root-questions li.survey_question').each(function(q) {
    if($(this).attr('data-question-required') == 'true') {
      $(this).find('p:first').prepend('<strong class="q-tag">QUESTION</strong> <strong class="q-type-tag">' + 
        $(this).attr('data-question-qtype') + '</strong> <abbr class="r-tag" title="Required">*</abbr> &mdash; ');
    } else {
      $(this).find('p:first').prepend('<strong class="q-tag">QUESTION</strong> <strong class="q-type-tag">' + 
        $(this).attr('data-question-qtype') + '</strong> &mdash; ');
    }
  });
  no_questions_message();
  $('#order-questions').click(function() {
    make_questions_sortable();
  });
  $('#done-ordering-questions').click(function() {
    save_question_positions();
  });
  $('#cancel-ordering-questions').click(function() {
    cancel_ordering_questions();
  });
  $('#add-question').click(function() {
    $('#new-question').toggle('blind');
    $('#edit-question:visible').hide('blind');
  });
  $('#cancel-new-question').live('click', function() {
    $('#new-question').hide('blind');
    return false;
  });
  $('.button.destroy').live('click', function(e) {
    if(confirm("Are you sure?")) {
      disable_button($(this));
      $.post(this.href, {_method:'delete'}, null, "script");
    }
    e.preventDefault();
    return false;
  });
  $('.button.edit,').live('click', function() {
    $('#new-question:visible').hide('blind');
    $('#edit-question').html('<img src="/assets/ajax-loader.gif" class="ajax-loader" />').show('blind');
    disable_button($(this));
  });
  $('.cancel').live('click', function() {
    $('#edit-question').hide('blind');
  });
  $('.question-type').live('change', function() {
    if($(this).val() == 'Select One' || $(this).val() == 'Select Multiple') {
      root($(this)).find('.choice_labels').show();
    } else {
      root($(this)).find('.choice_labels').hide();
    }
  });
  $('.question-type').change();
  $('input.new-choice').live('focus', function() {
    add_survey_question_choice($(this));
  });
  $('.ui-icon-plus').live('click', function() {
    add_survey_question_choice($(this));
  });
  $('.ui-icon-close').live('click', function() {
    remove_survey_question_choice($(this));
  });
  $('.choices input[type="text"]').live('keydown', function(e) {
    if((e.which == 8 || e.which == 46) && $(this).val() == '' && choices_count($(this)) > 1) {
      remove_survey_question_choice($(this));
      return false;
    }           
  });
  init_choices();
  $('#question-search').keyup(function() {
    $('#root-questions li.survey_question:not(contains("' + $(this).val() + '"))').css({height:'0px', borderTop:'1px solid #cfcfcf', overflow:'hidden'});
    $('#root-questions li.survey_question:contains("' + $(this).val() + '")').css({height:'auto', borderTop:'none', overflow:'visible'});
  });
}

function init_choices() {
  $('form .choices').sortable({
    axis: "y",
    scroll: true,
    update: function (event, ui) {
      ui.item.closest('ol').find('.position').each(function() {
        $(this).val($(this).closest('li').index());
      });
    }
  });
}

function choices_count(ref) {
  return root(ref).find('.choices li').length;
}

function add_survey_question_choice(ref) {
  ts = new Date().getTime();
  root($(ref)).find('.choices').append('<li>' +
    '<div class="input string required">' +
    '<input type="hidden" name="survey_question[choices_attributes[' + ts + '][position]]" ' +
    ' id="survey_question_choices_attributes_' + ts + '_position" value="' + choices_count($(ref)) + '" /> ' +
    '<input type="text" name="survey_question[choices_attributes[' + ts + '][label]]" maxlength="255" ' +
    ' id="survey_question_choices_attributes_' + ts + '_label" /> ' +
    '<span class="ui-icon ui-icon-arrowthick-2-n-s">Move</span> ' +
    '<span class="ui-icon ui-icon-close">Remove</span></li></div>')
  .find('input[type="text"]').focus();
  if($('#sidebar').height() > $(window).height()) {
    $.scrollTo(root($(ref)).find('.choices li:last'));
  } else {
    $(window).scroll();
  }
}

function remove_survey_question_choice(ref) {
  prev_sibling = $(ref).closest('li').prev(); 
  next_sibling = $(ref).closest('li').next();
  if($(ref).closest('li').find('input._destroy').length > 0) {
    $(ref).closest('li').find('input._destroy').val(1);
    $(ref).closest('li').hide();
  } else {
    $(ref).closest('li').remove();
  }
  if(prev_sibling.length > 0) {
    prev_sibling.find('input[type="text"]').focus();
  } else if(next_sibling.length > 0) {
    next_sibling.find('input[type="text"]').focus();
  }
  $(window).scroll();
}

function root(ref) {
  return $(ref).closest('form');
}

var initial_sorting = '';
function make_questions_sortable() {
  $('#root-questions-container').find('.button').button('destroy')
  initial_sorting = $('#root-questions-container').html();
  $('#root-questions').surveySortable({
    items: 'li',
    placeholder: 'placeholder',
    handle: '.handle',
    tolerance: 'pointer',
    toleranceElement: '> div',
    scroll: true,
		forcePlaceholderSize: true,
		helper:	'clone',
		opacity: .6,
		revert: 250
  });
  $('#root-questions').surveySortable('enable');
  $('#view-all-surveys, #delete-survey, #launch, .divider, #add-question, #new-question, #edit-question, #order-questions').hide('blind');
  $('#done-ordering-questions, #cancel-ordering-questions').show('blind');
  $('#done-ordering-questions-alert').show('blind').delay(50).show('highlight', {color:'#0296d4'});
  $('#root-questions-container').removeClass('not-ordering');
  $('#root-questions-container').addClass('ordering');
}

function save_question_positions() {
  disable_button('#done-ordering-questions');
  $.ajax({
    type: 'PUT', 
    data: $('#root-questions').surveySortable('serialize'),
    url: 'questions/update_positions',
    success: function() {
      done_ordering_questions();
      load_new_choice_options();
    },
    error: function() {
      alert('Sorry, an error occurred. Please try again.')
      enable_button('#done-ordering-questions');
    }
  });
}

function cancel_ordering_questions() {
  if(confirm('Are you sure?')) {
    $('#root-questions-container').html(initial_sorting);
    done_ordering_questions();
    initial_sorting = '';
  }
}

function done_ordering_questions() {
  enable_button('#done-ordering-questions');
  $('#root-questions').surveySortable('disable');
  $('#view-all-surveys, #delete-survey, #launch, .divider, #add-question, #order-questions').show('blind');
  $('#done-ordering-questions, #cancel-ordering-questions, #done-ordering-questions-alert').hide('blind');
  $('#root-questions-container').addClass('not-ordering');
  $('#root-questions-container').removeClass('ordering');
  init_common_elements();
  init_choices();
  $('.question-type').change();
}

function no_questions_message() {
  if($('#root-questions').children().length > 0) {
    $('#no-questions').hide();
    $('#order-questions').show();
  } else {
    $('#no-questions').show();
    $('#order-questions').hide();
  }
}

function load_new_choice_options() {
  $('select[name="survey_question[survey_question_choice_id]"]').load('questions/survey_question_choice_id_options');
}

function init_targeting() {
  $('.check').change(function() {
    if($(this).attr('checked')) {
      $(this).parent().next('.inner').show('blind');
    } else {
      $(this).parent().next('.inner').hide('blind');
    }
  });
  $('.check').change();
  $('#survey_target_attributes_ethnicity_ids_1').change(function() {
    if($(this).attr('checked')) {
      $('#survey_target_attributes_ethnicity_ids_2, #survey_target_attributes_ethnicity_ids_3, ' +
      '#survey_target_attributes_ethnicity_ids_4, #survey_target_attributes_ethnicity_ids_5').attr('checked', false);
    }
  });
  $('#survey_target_attributes_ethnicity_ids_2, #survey_target_attributes_ethnicity_ids_3, ' +
  '#survey_target_attributes_ethnicity_ids_4, #survey_target_attributes_ethnicity_ids_5').change(function() {
    if($(this).attr('checked')) {
      $('#survey_target_attributes_ethnicity_ids_1').attr('checked', false);
    }
  });
  $('#targeting .tabs').bind('tabsshow', function(event, ui) {
    $('#targeting .tabs li a span').removeClass('ui-icon-check');
    $('#targeting .tabs li a span').addClass('ui-icon-cancel');
    $('#targeting .tabs li.ui-tabs-selected a span').removeClass('ui-icon-cancel');
    $('#targeting .tabs li.ui-tabs-selected a span').addClass('ui-icon-check');
    if(ui.panel.id == 'by-address') {
      $('#survey_target_attributes_location_target_by_address').val('t');
    } else {
      $('#survey_target_attributes_location_target_by_address').val('f');
    }
  });
  if($('#survey_target_attributes_location_target_by_address').val() == 't') {
    $('#targeting .tabs').tabs('select', 0);
  } else {
    $('#targeting .tabs').tabs('select', 1);
  }
  $('#targeting .tabs li a span').removeClass('ui-icon-check');
  $('#targeting .tabs li a span').addClass('ui-icon-cancel');
  $('#targeting .tabs li.ui-tabs-selected a span').removeClass('ui-icon-cancel');
  $('#targeting .tabs li.ui-tabs-selected a span').addClass('ui-icon-check');
  init_targeting_map();
}
      
var geocoder;
var geocodeTimer;
var map;
var marker;
    
function init_targeting_map() {
  if($('#map-canvas').length == 0) {
    return false;
  }

  if(isNaN(parseFloat($('#survey_target_attributes_lat').val()))) {
    $('#survey_target_attributes_lat').val(40.3487181);
  }
  if(isNaN(parseFloat($('#survey_target_attributes_lng').val()))) {
    $('#survey_target_attributes_lng').val(-74.65904720000003);
  }
  if(isNaN(parseFloat($('#survey_target_attributes_radius').val()))) {
    $('#survey_target_attributes_radius').val(50);
  }

  var latlng = new google.maps.LatLng(
      parseFloat($('#survey_target_attributes_lat').val()), 
      parseFloat($('#survey_target_attributes_lng').val())
    );
  var options = {
    zoom: 8,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
        
  map = new google.maps.Map(document.getElementById('map-canvas'), options);
        
  geocoder = new google.maps.Geocoder();
  
  marker = new DistanceWidget({
    map: map,
    distance: parseFloat($('#survey_target_attributes_radius').val()),
    maxDistance: 100000,
    color: '#000000',
    activeColor: '#5599bb',
    sizerIcon: new google.maps.MarkerImage('/assets/resize-off.png'),
    activeSizerIcon: new google.maps.MarkerImage('/assets/resize.png')
  });
  
  google.maps.event.addListener(marker, 'distance_changed', update_distance);	
  google.maps.event.addListener(marker, 'position_changed', update_position);
  update_distance();
  update_position();

  map.fitBounds(marker.get('bounds'));
  
  $('#by-vicinity').appear(function() {
    google.maps.event.trigger(map, 'resize');
    map.fitBounds(marker.get('bounds'));
  });
  
  $('#survey_target_attributes_approximate_address').autocomplete({
    source: function(request, response) {
      geocoder.geocode( {'address': request.term }, function(results, status) {
        response($.map(results, function(item) {
          return {
            label: item.formatted_address,
            value: item.formatted_address,
            latitude: item.geometry.location.lat(),
            longitude: item.geometry.location.lng()
          }
        }));
      })
    },
    select: function(event, ui) {
      $('#survey_target_attributes_lat').val(ui.item.latitude);
      $('#survey_target_attributes_lng').val(ui.item.longitude);
      var location = new google.maps.LatLng(ui.item.latitude, ui.item.longitude);
      marker.set('position', location);
      map.fitBounds(marker.get('bounds'));
    }
  });
  
  $('#survey_target_attributes_radius').change(function() {
    radius_changed();
  });  
  $('#survey_target_attributes_radius').bind('keypress', function(e){
    if(e.keyCode == 13) {
      radius_changed();
      return false;
    }
  });
  
  $('#survey_target_attributes_lat, #survey_target_attributes_lng').change(function() {
    ll_changed();
  });
  $('#survey_target_attributes_lat, #survey_target_attributes_lng').bind('keypress', function(e){
    if(e.keyCode == 13) {
      ll_changed();
      return false;
    }
  });
}
  
function radius_changed() {
  if(isNaN(parseFloat($('#survey_target_attributes_radius').val()))) {
    $('#survey_target_attributes_radius').val(50.0);
  }
  marker.set('distance', parseFloat($('#survey_target_attributes_radius').val()));
  map.fitBounds(marker.get('bounds'));
}

function ll_changed() {    
  if(isNaN(parseFloat($('#survey_target_attributes_lat').val()))) {
    $('#survey_target_attributes_lat').val(0.0);
  }
  if(isNaN(parseFloat($('#survey_target_attributes_lng').val()))) {
    $('#survey_target_attributes_lng').val(0.0);
  }
  var latlng = new google.maps.LatLng(
      parseFloat($('#survey_target_attributes_lat').val()), 
      parseFloat($('#survey_target_attributes_lng').val())
    );
  marker.set('position', latlng);
  map.fitBounds(marker.get('bounds'));
  update_position();
}

function update_distance() {
  var distance = marker.get('distance');
  $('#survey_target_attributes_radius').val(distance.toFixed(2));
  if(isNaN(parseFloat($('#survey_target_attributes_radius').val()))) {
    $('#survey_target_attributes_radius').val(50.0);
  }
}

function update_position() {
  geocoder.geocode({'latLng': marker.get('position')}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[0]) {
        $('#survey_target_attributes_approximate_address').val(results[0].formatted_address);
        $('#survey_target_attributes_lat').val(marker.get('position').lat());
        $('#survey_target_attributes_lng').val(marker.get('position').lng());
      }
    }
  });
}
