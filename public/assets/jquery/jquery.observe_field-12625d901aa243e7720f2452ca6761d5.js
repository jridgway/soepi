// jquery.observe_field.js
(function(a){jQuery.fn.observe_field=function(b,c){return b=b*1e3,this.each(function(){var d=a(this),e=d.val(),f=function(){var a=d.val();e!=a&&(e=a,d.map(c))},g=function(){h&&(clearInterval(h),h=setInterval(f,b))};f();var h=setInterval(f,b);d.bind("keyup click mousemove",g)})}})(jQuery)