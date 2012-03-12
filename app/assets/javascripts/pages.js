$(document).ready(function () {
  if($('#page-content h1, #page-content h2, #page-content h3, #page-content h4, #page-content h5, #page-content h6').length > 1) {
    $('#toc .inner').tableOfContents('#page-content');
    $('#toc').show();
  } else {
    $('#toc').hide();
  }
});