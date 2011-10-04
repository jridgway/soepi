/*
 * jQuery.appear
 * http://code.google.com/p/jquery-appear/
 *
 * Copyright (c) 2009 Michael Hixson
 * Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
*/
(function(a){a.fn.appear=function(b,c){var d=a.extend({one:!0},c);return this.each(function(){var c=a(this);c.appeared=!1;if(!b){c.trigger("appear",d.data);return}var e=a(window),g=function(){if(!c.is(":visible")){c.appeared=!1;return}var a=e.scrollLeft(),b=e.scrollTop(),f=c.offset(),g=f.left,h=f.top;h+c.height()>=b&&h<=b+e.height()&&g+c.width()>=a&&g<=a+e.width()?c.appeared||c.trigger("appear",d.data):c.appeared=!1},h=function(){c.appeared=!0;if(d.one){e.unbind("scroll",g);var h=a.inArray(g,a.fn.appear.checks);h>=0&&a.fn.appear.checks.splice(h,1)}b.apply(this,arguments)};d.one?c.one("appear",d.data,h):c.bind("appear",d.data,h),e.scroll(g),a.fn.appear.checks.push(g),g()})},a.extend(a.fn.appear,{checks:[],timeout:null,checkAll:function(){var b=a.fn.appear.checks.length;if(b>0)while(b--)a.fn.appear.checks[b]()},run:function(){a.fn.appear.timeout&&clearTimeout(a.fn.appear.timeout),a.fn.appear.timeout=setTimeout(a.fn.appear.checkAll,20)}}),a.each(["append","prepend","after","before","attr","removeAttr","addClass","removeClass","toggleClass","remove","css","show","hide"],function(b,c){var d=a.fn[c];d&&(a.fn[c]=function(){var b=d.apply(this,arguments);return a.fn.appear.run(),b})})})(jQuery)