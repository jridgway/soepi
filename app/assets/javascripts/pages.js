$(document).ready(function () {
  if($('.page h1, .page h2, .page h3 .page h4, .page h5, .page h6').length > 1) {
    $('#toc .inner').tableOfContents('.page', {startLevel:2});
    $('#toc').show();
  } else {
    $('#toc').hide();
  }
});