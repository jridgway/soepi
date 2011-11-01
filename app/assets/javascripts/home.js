var notifications_page = 1;

$(document).ready(function () {
  init_auto_load_notifications();
  init_slider();
});

function init_slider() {
  if($('bp.home #slider img').length > 0) {
    $('bp.home #slider').coinslider({
      height: 350
    });
  } else {
    $('bp.home #slider').hide();
  }
}

function init_auto_load_notifications() {
  if($('.home #notifications').length > 0) {
    $('#footer').appear(function() {
      notifications_page += 1;
      $('#notifications').append('<li class="ajax-loader-container"><img src="/assets/ajax-loader.gif" class="ajax-loader" /></li>');
      $.get('/notifications?page=' + notifications_page, function(data) {
        $('#notifications .ajax-loader-container').remove();
        $('#notifications').append(data);
        if(data != '') {
          init_auto_load_notifications();
        }
      });
    });
  }
}