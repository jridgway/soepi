/**
 * jQuery.LocalScroll - Animated scrolling navigation, using anchors.
 * Copyright (c) 2007-2009 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * Date: 3/11/2009
 * @author Ariel Flesler
 * @version 1.2.7
 **/
(function(a){function d(b,c,d){var e=c.hash.slice(1),f=document.getElementById(e)||document.getElementsByName(e)[0];if(!f)return;b&&b.preventDefault();var g=a(d.target);if(d.lock&&g.is(":animated")||d.onBefore&&d.onBefore.call(d,b,f,g)===!1)return;d.stop&&g.stop(!0);if(d.hash){var h=f.id==e?"id":"name",i=a("<a> </a>").attr(h,e).css({position:"absolute",top:a(window).scrollTop(),left:a(window).scrollLeft()});f[h]="",a("body").prepend(i),location=c.hash,i.remove(),f[h]=e}g.scrollTo(f,d).trigger("notify.serialScroll",[f])}var b=location.href.replace(/#.*/,""),c=a.localScroll=function(b){a("body").localScroll(b)};c.defaults={duration:1e3,axis:"y",event:"click",stop:!0,target:window,reset:!0},c.hash=function(b){if(location.hash){b=a.extend({},c.defaults,b),b.hash=!1;if(b.reset){var e=b.duration;delete b.duration,a(b.target).scrollTo(0,b),b.duration=e}d(0,location,b)}},a.fn.localScroll=function(e){function f(){return!!this.href&&!!this.hash&&this.href.replace(this.hash,"")==b&&(!e.filter||a(this).is(e.filter))}return e=a.extend({},c.defaults,e),e.lazy?this.bind(e.event,function(b){var c=a([b.target,b.target.parentNode]).filter(f)[0];c&&d(b,c,e)}):this.find("a,area").filter(f).bind(e.event,function(a){d(a,this,e)}).end().end()}})(jQuery)