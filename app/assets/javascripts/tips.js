$(document).ready(function () {
  init_tips();
  init_form_tips();
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
  $('input, select, textarea').focus(function() {
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