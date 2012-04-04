var previousDocTop;

$(document).ready(function () {
  previousDocTop = $(window).scrollTop();
  setTimeout('init_sidebar()', 100);
});

function init_sidebar() {
  var initial_sidebar_width = $('#sidebar').width() + 'px';
  $(window).scroll(function() {
    var height = $('#sidebar').height();
    var begin_at = $('#content-top').position({my:'top'}).top + $('#content-top').outerHeight();
    var docHeight, docTop, docBottom, top, bottom, movingUp, movingDown;
    if($(this).scrollTop() >= begin_at && $('#body_content_left').height() > height) {
      docHeight = $(window).height();
      docTop = $(window).scrollTop();
      docBottom = docTop + docHeight;
      top = $('#sidebar').offset().top;
      bottom = top + height;
      movingUp = previousDocTop > docTop;
      movingDown = !movingUp;
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