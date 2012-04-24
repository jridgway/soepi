$(document).ready(function () {
  init_tips();
  init_form_tips();
  var form_errors_not_in_tabs = $('.input').filter(function() {
    return $(this).closest('.tabs').length == 0
  });
  init_form_errors(form_errors_not_in_tabs);
});

function init_tips() {
  $('[hint]').each(function() {
    $(this).qtip({
      content: $(this).attr('hint'),
      position: {
        at: 'top right',
        my: 'bottom left',
        viewport: $(window),
        adjust: {
          method: 'flip flip'
        }
      },
      style: {
        classes: 'tip',
        tip: {
         border: 5,
         offset: 10,
         height: 7
        }
      }
    });
  });
}

function init_form_tips() {
  $('form .input').each(function() { 
    var target = false;
    var event_show = 'focus';
    var event_hide = 'blur';
    if($(this).hasClass('check_boxes') || $(this).hasClass('radio') || $(this).hasClass('boolean') ||
    $(this).hasClass('select') || $(this).hasClass('country') || $(this).children('input[type="file"]').length > 0) {
      target = $(this);
      event_show = 'mouseenter';
      event_hide = 'mouseleave';
    } else if($(this).children('.tagit').length > 0) {
      target = $(this).children('.tagit .tagit-new input:visible');
    } else if($(this).children('input[type!="hidden"], select, textarea').length > 0) {
      target = $(this).children('input[type!="hidden"], select, textarea');
    } else {
      target = $(this);
    }
    $(target).bind(event_show, function() { 
      var hints = $(target).closest('.input').children('.hint');
      if(hints.length == 0) {
        hints = $(target).children('.hint');
      }
      if(hints.length > 0) {      
        var text = $(hints).map(function() {
          return $(this).html();
        }).toArray().join('<p/><p>') + '</p>';    
        $(this).qtip({
          content: text,
          position: {
            at: 'top right',
            my: 'bottom left',
            viewport: $(window),
            adjust: {
              method: 'flip flip'
            }
          },
          show: {
            event: false,
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
      }
    });      
    $(target).bind(event_hide, function() {
      $(this).qtip('destroy');
    });
  });
  $('.hint').hide();
}

function init_form_errors(input_divs) {
  var text = '';
  var target = false;
  $('.error2').each(function() {
    $(this).qtip('destroy');
  });
  $(input_divs).each(function() {
    if($(this).children('.error').length > 0) {
      text = '<p>' + $(this).children('.error').map(function() {
        return $(this).html();
      }).toArray().join('<p/><p>') + '</p>';
      if($(this).hasClass('check_boxes') || $(this).hasClass('radio')) {
        target = $(this).find('span label').first();
      } else if($(this).hasClass('boolean')) {
        target = $(this).find('label').first();
        if(!$(target).attr('id') + $(target).attr('for')) {
          $(target).attr('id', $(target).attr('for') + '_label')
        } else {
          $(target).attr('id', 'rand_id_' + Math.random().toString().replace('.', ''));
        }
      } else if($(this).find('.tagit-new input').length > 0) {
        target = $(this).find('.tagit-new input').first();
      } else if($(this).find('input[type!="hidden"], select, textarea').length > 0) {
        target = $(this).find('input[type!="hidden"], select, textarea').last();
      } else {
        target = $(this);
      }
      $(target).qtip({
        content: text,
        position: {
          at: 'right top',
          my: 'left top',
          adjust: {
            y: 15
          },
          viewport: $(window)
        },
        show: {
          event: true,
          ready: true
        },
        hide: false,
        style: {
          classes: 'tip error2',
          tip: {
           border: 5
          }
        }
      }).attr('id');
      $(this).find('.error').attr('qtip-target-id', $(target).attr('id'));
      if($(this).hasClass('check_boxes') || $(this).hasClass('radio')) {    
        $(this).find('input').change(function() {
          $(this).parents('.input').find('span label').first().qtip('destroy');
        });
      }
      if($(this).hasClass('boolean')) {    
        $(this).find('input').change(function() {
          $(this).parents('.input').find('label').first().qtip('destroy');
        });
      }
      if($(this).hasClass('select')) {    
        $(this).find('select').change(function() {
          $(this).qtip('destroy');
          $(this).closest('.input').find('.error').remove();
        });
      }
    }
  });
  $('.error').hide();
}