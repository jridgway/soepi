var previousDocTop;

$(document).ready(function () {
  previousDocTop = $(window).scrollTop();
  $('.ui-widget-overlay').live('click', function () {
    $('.ui-dialog-content').dialog('close');
  });
  $('.accordian').accordion({
    autoHeight: false, 
    navigation: true, 
    collapsible: true, 
    active: false, 
    change: function() {
      $(window).scroll();
    }
  });
  init_pop_navs();
  load_quick_search();
  select_nav_item();
  init_sidebar();
  init_common_elements();
  init_nickname_autocomplete();
  init_external_links();
});

function member_return_to() {
  if(controller_name != 'sessions' && controller_name != 'registrations' && controller_name != 'passwords' && 
  (controller_name != 'authentications' || action_name == 'index') && 
  (controller_name != 'accounts' || action_name == 'account')) {
    return jQuery.url.attr('relative');
  } else {
    return '';
  }
}

var pop_nav_was_visible;

function init_pop_navs() {
  $('.pop-nav-link').live('click', function(event) {
    var inner = $(this).closest('.pop-nav').find('.pop-nav-inner');
    if(pop_nav_was_visible.length > 0 && pop_nav_was_visible[0] == inner[0]) {
      $(inner).hide();
      $(this).removeClass('active');
    } else {
      $(inner).show();
      $(this).addClass('active');
    }
    event.stopPropagation();
    return false;
  });
  $('body').click(function(event) {
    pop_nav_was_visible = $('.pop-nav-inner:visible');
    $('.pop-nav-link').removeClass('active');
    $('.pop-nav-inner').hide();
    return true;
  });
}

function select_nav_item() {
  var relative = jQuery.url.attr('relative');
  $('#menu .secondary ul li a[href="' + relative + '"]').addClass('active');
  $('#menu .secondary ul li a[href="/' + relative.split('/')[1] + '"]').addClass('active');
}


function init_sign_in_links() {
  $('a[href="/members/sign_in"]').live('click', function () {
    sign_in_dialog();
    return false;
  });
}

function sign_in_dialog(return_to) {
  if(return_to == null) {
    return_to = member_return_to();
  }
  if($('#sign-in-dialog').length == 0) {
    $('body').append('<div id="sign-in-dialog" style="display:none" title="Sign In">' +
      '<img src="/assets/ajax-loader.gif" class="ajax-loader" /></div>');
    $('#sign-in-dialog').load('/members/sign_in?xhr=1&member_return_to=' + return_to, function () {
      init_common_elements();
    });
  } 
  $('#sign-in-dialog').dialog({width:800, height:350, modal:true, zIndex:9, resizable:false}).show('blind');
}

function init_common_elements() {
  $('form.uneditable :input').attr("disabled", true);
  $('form.uneditable .tagit-close').remove();
  $('form.uneditable .tagit input:visible').remove();
  $('input.date_picker').datepicker({dateFormat:'MM d, yy', changeMonth:true, changeYear:true});
  $('input.datetime_picker').datetimepicker({dateFormat:'MM d, yy', changeMonth:true, changeYear:true, ampm:true});
  $('input.time_picker').timepicker({ampm:true});
  $('.button, .create, .update .destroy').each(function() {
    $(this).button({
      icons: {
        primary: $(this).attr('icon'), 
        secondary: $(this).attr('secondary_icon')
      }
    });
  });
  $('abbr.timeago').timeago();
  $('textarea[class!="manualgrow"]').autogrow();
  $('.expandable').each(function() {
    if($(this).find('.read-more').length == 0) {
      $(this).expander({
        slicePoint: 200, 
        expandText: 'Read More', 
        collapseTimer: 0, 
        userCollapseText: 'Read Less'
      });
    }
  });
  $(".progressbar").each(function() {
    $(this).progressbar({
  		value: parseInt($(this).attr('data-value'))
  	});
  });
}

function disable_button(button) {
  $(button).button('disable');
  $('body').append('<div id="please-wait">Please wait...</div>');
}

function enable_button(button) {
  $(button).button('enable');
  $('#please-wait').remove();
}

function init_sidebar() {
  var initial_sidebar_width = $('#sidebar').width() + 'px';
  $(window).scroll(function() {
    var height = $('#sidebar').height();
    var begin_at = $('#content-top').position({my:'top'}).top + $('#content-top').outerHeight();
    if($(this).scrollTop() >= begin_at && $('#body_content_left').height() > height) {
      var docHeight = $(window).height();
      var docTop = $(window).scrollTop();
      var docBottom = docTop + docHeight;
      var top = $('#sidebar').offset().top;
      var bottom = top + height;
      var movingUp = previousDocTop > docTop;
      var movingDown = !movingUp;
      previousDocTop = docTop;
      if(height + 75 > docHeight && docBottom + 75 > $(document).height()) {
        $('#sidebar').css({
          position: 'fixed', 
          bottom: (95 - ($(document).height() - docBottom)) + 'px', 
          top: 'auto', 
          width: initial_sidebar_width
        });
      } else if(height <= docHeight || (top >= docTop && movingUp)) {
        $('#sidebar').css({
          position: 'fixed', 
          top: '10px', 
          bottom: 'auto', 
          width:initial_sidebar_width
        });
      } else if(bottom <= docBottom && movingDown) {
        $('#sidebar').css({
          position: 'fixed', 
          bottom: '10px', 
          top: 'auto', 
          width: initial_sidebar_width
        });
      } else if(bottom > docBottom || top < docTop) {
        $('#sidebar').css({
          position: 'absolute', 
          top: $('#sidebar').position().top + 'px', 
          bottom: 'auto', 
          width: initial_sidebar_width
        });
      }
    } else {
      $('#sidebar').css({position:'static'});
    }
  });
}

function isWhollyVisible(elem) {
  var docViewTop = $(window).scrollTop();
  var docViewBottom = docViewTop + $(window).height();
  var elemTop = $(elem).offset().top;
  var elemBottom = elemTop + $(elem).height();
  return ((elemBottom >= docViewTop) && (elemTop <= docViewBottom)
    && (elemBottom <= docViewBottom) &&  (elemTop >= docViewTop));
}

var quick_search_cache = {}, lastXhr;

function load_quick_search() {
  if($('#q').length > 0) {
    $('#q').autocomplete({
      minLength: 2,
      delay: 100,
      source: function(request, response) {
        var term = request.term;
        if(term in quick_search_cache) {
          response(quick_search_cache[term]);
          return;
        }
        lastXhr = $.getJSON('/quick_search', request, function(data, status, xhr) {
          quick_search_cache[term] = data;
          if(xhr === lastXhr) {
            response(data);
          }
        });
      },
      focus: function(item) {
       return false;
      },
      select: function(event, ui) {
        location.href = ui.item.value;
        return false;
      }
    })
    .data("autocomplete")._renderItem = function(ul, item) {
      return $("<li></li>")
        .data("item.autocomplete", item)
        .append('<a>' + item.logo + '<h4>' + item.label + '</h4><small>' + item.description + '</small></a>')
        .appendTo(ul);
    };
  }
}

function split(val) {
	return val.split(/,\s*/);
}

function extractLast(term) {
	return split(term).pop();
}

function init_nickname_autocomplete() {
	if($('#message_recipient_nicknames').length > 0) {
	  $("#message_recipient_nicknames").bind("keydown", function(event) {
    	if(event.keyCode === $.ui.keyCode.TAB && $(this).data("autocomplete").menu.active) {
    		event.preventDefault();
    	}
    })
    .autocomplete({
    	source: function(request, response) {
    		$.getJSON('/members/autocomplete.js', {term: extractLast(request.term)}, response);
    	},
    	focus: function() {
    		return false;
    	},
    	select: function(event, ui) {
    		var terms = split(this.value);
    		terms.pop();
    		terms.push(ui.item.value);
    		terms.push("");
    		this.value = terms.join(", ");
    		return false;
    	}
    })
    .data("autocomplete")._renderItem = function(ul, item) {
      return $("<li></li>")
        .data("item.autocomplete", item)
        .append('<a>' + item.logo + '<h4>' + item.label + '</h4><small>' + item.description + '</small></a>')
        .appendTo(ul);
    }
	}
}


var external_re = new RegExp( "^https?:\/\/(?!" + location.hostname + ").*$" );

function init_external_links() {
  $('a').live('click', function() {
    if(external_re.test(this.href)) {
      if(!this.target) {
        this.target = '_blank';
      }
    }
  });
}

function select_details_menu_item() {
  var relative = jQuery.url.attr('relative').replace(/\?.*/, '').replace(/#.*/, '').replace(/\/+$/, '');
  var available_items = 0;
  $('#details ul.menu li').each(function(index, value) {
    if($(this).css('display') != 'none') {
      available_items += 1;
    }
  });
  if(available_items == 0) {
    $('#details').hide();
  } else {
    $('#details').show();
    $('#details ul.menu li a').each(function() {
      if($(this).attr('href') == relative || $(this).attr('href') == unescape(relative)) {
        $(this).addClass('active');
      }
    });
  }
}