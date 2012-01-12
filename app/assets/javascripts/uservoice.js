var uservoiceOptions = {
  /* required */
  key: 'soepihub',
  host: 'soepihub.uservoice.com', 
  forum: '105523',
  showTab: true,  
  /* optional */
  alignment: 'right',
  background_color:'#cccccc', 
  text_color: 'white',
  hover_color: '#49c4f7',
  lang: 'en'
};

function _loadUserVoice() {
  var s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js");
  document.getElementsByTagName('head')[0].appendChild(s);
}

$(document).ready(function() {
  _loadUserVoice();
});