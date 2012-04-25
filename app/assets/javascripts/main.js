function init_main() {
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
  init_common_elements();
  init_message_recipient_nicknames();
  init_external_links();
  Shadowbox.init({overlayColor:'#999'});
}

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
  $('html').click(function(event) {
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
  $('a[href^="/account/sign_in"]').live('click', function () {
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
    $('#sign-in-dialog').load('/account/sign_in?xhr=1&member_return_to=' + return_to, function () {
      init_common_elements();
    });
  } 
  $('#sign-in-dialog').dialog({width:800, height:450, modal:true, zIndex:9, resizable:false}).show('blind');
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
  $('textarea[class!="manualgrow"]').elastic();
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

function init_message_recipient_nicknames() {
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

function init_collaboration_nicknames() {
	if($('#collaborator_nickname').length > 0) {
	  $("#collaborator_nickname").bind("keydown", function(event) {
    	if(event.keyCode === $.ui.keyCode.TAB && $(this).data("autocomplete").menu.active) {
    		event.preventDefault();
    	}
    })
    .autocomplete({
    	source: '/members/autocomplete.js',
    	focus: function() {
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

function wait() {
  $('#wait').remove();
  $('body').append('<div id="wait" class="ui-widget-overlay"><div id="wait-inner"><img src="/assets/ajax-loader.gif" /> Please Wait</div></div>');
  $('#wait').css('height', $(document).height());
  $('#wait').css('z-index', '999999');
  $('#wait-inner').css('z-index', '1000000');
}

function finished() {
  $('#wait').remove();
}

function load_sharethis() {
  if(typeof stLight === 'undefined') {
    var switchTo5x=true;
    $.getScript('https://ws.sharethis.com/button/buttons.js', function() {
      stLight.options({publisher: 'f83b9100-5d77-4829-9992-248efad6aa95', onhover: false});
    });
  }
}