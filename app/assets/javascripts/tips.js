$(document).ready(function () {
  init_tips();
  init_form_tips();
  var form_errors_not_in_tabs = $('.input').filter(function() {$(this).closest('.tabs').length == 0});
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
  $('input[type!="hidden"], select, textarea').focus(function() {
    var text = $(this).attr('hint') == undefined ? $(this).siblings('.hint').first().html() : $(this).attr('hint');
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
  });
  $('.hint').hide();
  $('input, select, textarea').blur(function() {
    $(this).qtip('destroy');
  });
}

function init_form_errors(input_divs) {
  $('.error2').each(function() {
    $(this).qtip('destroy');
  });
  $(input_divs).each(function() {
    if($(this).children('.error').length > 0) {
      var text = '<p>' + $(this).children('.error').map(function() {
        return $(this).html();
      }).toArray().join('<p/><p>') + '</p>';
      if($(this).hasClass('check_boxes') || $(this).hasClass('radio')) {
        var target = $(this).find('span label').first();
      } else if($(this).hasClass('boolean')) {
        var target = $(this).find('label').first();
        if(!$(target).attr('id') + $(target).attr('for')) {
          $(target).attr('id', $(target).attr('for') + '_label')
        } else {
          $(target).attr('id', 'rand_id_' + Math.random().toString().replace('.', ''));
        }
      } else if($(this).find('input[type!="hidden"], select, textarea').length > 0) {
        var target = $(this).find('input[type!="hidden"], select, textarea').last();
      } else {
        var target = $(this);
      }
      if(target) {
        $(target).qtip({
          content: text,
          position: {
            at: 'right top',
            my: 'left top',
            adjust: {
              y: 15
            },
            viewport: $(window),
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
      }
    }
  });
  $('.error').hide();
}