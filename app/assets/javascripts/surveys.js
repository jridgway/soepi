var stop_arrows = false;

$.extend($.expr[':'], {
  'containsi': function(elem, i, match, array)
  {
    return (elem.textContent || elem.innerText || '').toLowerCase()
    .indexOf((match[3] || "").toLowerCase()) >= 0;
  }
});

$(document).ready(function() {
  $('#participate').click(function(e) {
    if(!$('#survey-participation-agreement').is(':checked')) {
      $('#survey-participation-agreement-container').show('shake', 50);
      e.preventDefault();
      return false;
    }
  });
  $('#survey-participation-agreement').change();
  init_survey_form();
  if(controller_name == 'survey_questions') {
    init_survey_question_form();
  }
  if(controller_name == 'survey_questions' || controller_name == 'surveys') {    
    $('#launch, #launch3').click(function() {
      $('#launch-message').dialog({width:520, height:250, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-launch').click(function() {
      $('#launch-message').dialog('destroy');
    });
    $('#launch2').click(function() {
      $('#launch2-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-launch2').click(function() {
      $('#launch2-message').dialog('destroy');
    });
    $('#launch3').click(function() {
      $('#launch3-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#request-changes').click(function() {
      $('#request-changes-message').dialog({width:620, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-request-changes').click(function() {
      $('#request-changes-message').dialog('destroy');
    });
    $('#reject').click(function() {
      $('#reject-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-reject').click(function() {
      $('#reject-message').dialog('destroy');
    });
    $('#delete').click(function() {
      $('#delete-message').dialog({width:520, height:175, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-delete').click(function() {
      $('#delete-message').dialog('destroy');
    });
    $('#close').click(function() {
      $('#close-message').dialog({width:600, height:200, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-close').click(function() {
      $('#close-message').dialog('destroy');
    });
    $('#forkit').click(function() {
      $('#forkit-message').dialog({width:520, height:200, modal:true, zIndex:9, resizable:false}).show('blind');
    });
    $('#cancel-forkit').click(function() {
      $('#forkit-message').dialog('destroy');
    }); 
  }
  if(controller_name == 'surveys' && action_name == 'downloads') {
    $('#downloads a.copy').each(function() {
      $(this).zclip({
        path:'/ZeroClipboard.swf',
        copy: $(this).siblings('input.url').val(),
        afterCopy: function() {
          id = 'copied' + Math.random().toString().replace('.', '');
          $(this).after(' <strong id="' + id + '">Copied!</strong>');
          setTimeout("$('#" + id + "').hide('fade');", 5000);
        }
      });
    });
  }
  if(controller_name == 'surveys' && action_name == 'demographics') {
    $('#demographic-links').localScroll();
  }
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

function init_survey_question_form() {
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
  $('.survey_question_body').live('blur', function() {
    if($('.survey_question_label').val() == '') {
      if($(this).val().length > 50) {
        $('.survey_question_label').val($(this).val().substr(0, 49));
      } else {
        $('.survey_question_label').val($(this).val());
      }
    }
  });
  $('#add-question').click(function() {    
    if($('#new-question-dialog').length == 0) {
      $('body').append('<div id="new-question-dialog" style="display:none" title="New Question">' +
        '<img src="/assets/ajax-loader.gif" class="ajax-loader" /></div>');
      $('#new-question-dialog').load('questions/new', function () {
        init_common_elements();
        init_choices();
        init_form_tips();
        $('.question-type').change();
      });
    } 
    $('#new-question-dialog').dialog({
      width:750, 
      height:450, 
      modal:true, 
      zIndex:9, 
      resizable:true,
      beforeClose: function() {
        $('.error2').qtip('destroy');
      }
    }).show('blind');
  });
  $('.button.destroy').live('click', function(e) {
    if(confirm("Are you sure?")) {
      disable_button($(this));
      $.post(this.href, {_method:'delete'}, null, "script");
    }
    e.preventDefault();
    return false;
  });
  $('.button.edit').live('click', function() {  
    if($('#edit-question-dialog').length == 0) {
      $('body').append('<div id="edit-question-dialog" style="display:none" title="Edit Question">' +
        '<img src="/assets/ajax-loader.gif" class="ajax-loader" /></div>');
    } 
    $('#edit-question-dialog').dialog({
      width:750, 
      height:450, 
      modal:true, 
      zIndex:9, 
      resizable:true,
      beforeClose: function() {
        $('.error2').qtip('destroy');
      }
    }).show('blind');
  });
  $('.cancel').live('click', function() {
    $('#edit-question').hide('blind');
  });
  $('.question-type').live('change', function() {
    root($(this)).find('.choice_labels .aria-describedby').each(function() {
      $(this).qtip('destroy');
    });
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
  $('#question-search').keyup(function() {
    $('#root-questions li.survey_question:not(containsi("' + $(this).val() + '"))').css({height:'0px', borderTop:'1px solid #cfcfcf', overflow:'hidden'});
    $('#root-questions li.survey_question:containsi("' + $(this).val() + '")').css({height:'auto', borderTop:'none', overflow:'visible'});
  });
  $('#question-search').focus(function() {
    remove_question_results_tip();
    if($('#root-questions:visible').length == 0) {
      $.history.load('all');
    }
  });
  $('.not-editable #root-questions a').first().qtip({
    content:'<p>Click a question to view its results.</p>',
    position: {
      at: 'top middle',
      my: 'bottom middle',
      viewport: $(window),
      adjust: {
        method: 'flip flip'
      }
    },
    show: {
      event: true,
      ready: true
    },
    hide: false,
    style: {
      classes: 'tip',
      tip: {
       border: 5,
       offset: 10,
       height: 7
      }
    }
  });
  setTimeout("$('#ui-tooltip-0').remove();", 5000);
  if($('.results-available').length > 0) {
    $(document).keydown(function(e) {
      if(!stop_arrows) {
        if(e.keyCode == 37 && ! e.metaKey && ! e.ctrlKey) {
          stop_arrows = true;
          if($('.nav button.previous').length == 0 && $('#results:visible').length > 0) {            
            $.history.load('all');
          } else if($('#results:visible').length == 0) {
             window.location = $('#root-questions a').last().attr('href');
          } else {
            $('.nav button.previous').click();
          }
          return false;
        }
        if(e.keyCode == 39 && ! e.metaKey && ! e.ctrlKey) {
          stop_arrows = true;
          if($('.nav button.next:visible').length == 0 && $('#results:visible').length > 0) {          
            $.history.load('all');
          } else if($('#results:visible').length == 0) {
            window.location = $('#root-questions a').first().attr('href');
          } else {
            $('.nav button.next').click();
          }
          return false;
        }
      }
    });
    $.history.init(load_content);
  }
}

function load_content(hash) {
  if(hash == '' || hash == 'all') {
    show_all_questions();
  } else {
    $.getScript('questions/' + hash + '/results.js?h=1');
  }
}

function show_all_questions() {
  if($('#root-questions:visible').length == 0) {
    $('#results').hide('slide', function() {
      $('#root-questions').show('slide'); 
      $('#all-questions').hide()
      stop_arrows = false;
    });
  }
}

function remove_question_results_tip() {
  $('#root-questions a').first().qtip('destroy');
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
  return root(ref).find('.choices li').length - 1;
}

function add_survey_question_choice(ref) {
  ts = new Date().getTime();
  root($(ref)).find('.choices li:last').before('<li>' +
    '<div class="input string required">' +
    '<input type="hidden" name="survey_question[choices_attributes[' + ts + '][position]]" ' +
    ' id="survey_question_choices_attributes_' + ts + '_position" value="' + choices_count($(ref)) + '" /> ' +
    '<input type="text" name="survey_question[choices_attributes[' + ts + '][label]]" maxlength="255" ' +
    ' id="survey_question_choices_attributes_' + ts + '_label" /> ' +
    '<span class="ui-icon ui-icon-arrowthick-2-n-s">Move</span> ' +
    '<span class="ui-icon ui-icon-close">Remove</span></li></div>');
  root($(ref)).find('.choices li:not(.new-choice-container):last input[type="text"]').focus();
  if(choices_count > 6) {
    $.scrollTo(root($(ref)).find('.choices li:last'));
  }
}

function remove_survey_question_choice(ref) {
  prev_sibling = $(ref).closest('li').prev(); 
  next_sibling = $(ref).closest('li').next();
  $(ref).closest('li').find('input[type="text"]').qtip('destroy');
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
  $('#questions').find('.button').button('destroy')
  initial_sorting = $('#questions').html();
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
  $('#add-question, #order-questions').hide('blind');
  $('#done-ordering-questions, #cancel-ordering-questions').show('blind');
  $('#done-ordering-questions-alert').show('blind').delay(50).show('highlight', {color:'#49c4f7'});
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
    $('#questions').html(initial_sorting);
    done_ordering_questions();
    initial_sorting = '';
  }
}

function done_ordering_questions() {
  enable_button('#done-ordering-questions');
  $('#root-questions').surveySortable('disable');
  $('#add-question, #order-questions').show('blind');
  $('#done-ordering-questions, #cancel-ordering-questions, #done-ordering-questions-alert').hide('blind');
  $('#root-questions-container').addClass('not-ordering');
  $('#root-questions-container').removeClass('ordering');
  init_common_elements();
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

function load_new_choice_options(current) {
  $('select[name="survey_question[survey_question_choice_id]"]').load('questions/survey_question_choice_id_options', function() {
    $(this).val(current);
  });
}

function init_targeting() {
  $('.check').change(function() {
    if($(this).attr('checked')) {
      $(this).closest('.target').find('.inner').show('blind');
    } else {
      $(this).closest('.target').find('.inner').hide('blind');
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
      $('#survey_target_attributes_location_type').val('address');
    } else if(ui.panel.id == 'by-vicinity') {
      $('#survey_target_attributes_location_type').val('vicinity');
    } else if(ui.panel.id == 'by-region') {
      $('#survey_target_attributes_location_type').val('region');
    }
  });
  if($('#survey_target_attributes_location_type').val() == 'vicinity') {
    $('#targeting .tabs').tabs('select', 0);
  } else if($('#survey_target_attributes_location_type').val() == 'address') {
    $('#targeting .tabs').tabs('select', 1);
  } else if($('#survey_target_attributes_location_type').val() == 'region') {
    $('#targeting .tabs').tabs('select', 2);
  }
  $('#targeting .tabs li a span').removeClass('ui-icon-check');
  $('#targeting .tabs li a span').addClass('ui-icon-cancel');
  $('#targeting .tabs li.ui-tabs-selected a span').removeClass('ui-icon-cancel');
  $('#targeting .tabs li.ui-tabs-selected a span').addClass('ui-icon-check');
  init_targeting_map();
  init_targeting_survey();
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

function init_targeting_survey() {
  $('.remove-target-survey').live('click', function() {
    $(this).closest('li').find('input[type="hidden"]').val('');
    $(this).closest('li').hide('explode');
  });
}
