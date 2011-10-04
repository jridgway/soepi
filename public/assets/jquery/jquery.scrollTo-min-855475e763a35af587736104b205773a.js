/**
 * jQuery.ScrollTo - Easy element scrolling using jQuery.
 * Copyright (c) 2007-2009 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * Date: 3/9/2009
 * @author Ariel Flesler
 * @version 1.4.1
 *
 * http://flesler.blogspot.com/2007/10/jqueryscrollto.html
 */
(function(a){function c(a){return typeof a=="object"?a:{top:a,left:a}}var b=a.scrollTo=function(b,c,d){a(window).scrollTo(b,c,d)};b.defaults={axis:"xy",duration:parseFloat(a.fn.jquery)>=1.3?0:1},b.window=function(b){return a(window).scrollable()},a.fn.scrollable=function(){return this.map(function(){var b=this,c=!b.nodeName||a.inArray(b.nodeName.toLowerCase(),["iframe","#document","html","body"])!=-1;if(!c)return b;var d=(b.contentWindow||b).document||b.ownerDocument||b;return a.browser.safari||d.compatMode=="BackCompat"?d.body:d.documentElement})},a.fn.scrollTo=function(d,e,f){return typeof e=="object"&&(f=e,e=0),typeof f=="function"&&(f={onAfter:f}),d=="max"&&(d=9e9),f=a.extend({},b.defaults,f),e=e||f.speed||f.duration,f.queue=f.queue&&f.axis.length>1,f.queue&&(e/=2),f.offset=c(f.offset),f.over=c(f.over),this.scrollable().each(function(){function o(a){g.animate(k,e,f.easing,a&&function(){a.call(this,d,f)})}function p(a){var c="scroll"+a;if(!m)return b[c];var d="client"+a,e=b.ownerDocument.documentElement,f=b.ownerDocument.body;return Math.max(e[c],f[c])-Math.min(e[d],f[d])}var b=this,g=a(b),h=d,i,k={},m=g.is("html,body");switch(typeof h){case"number":case"string":if(/^([+-]=)?\d+(\.\d+)?(px)?$/.test(h)){h=c(h);break}h=a(h,this);case"object":if(h.is||h.style)i=(h=a(h)).offset()}a.each(f.axis.split(""),function(a,c){var d=c=="x"?"Left":"Top",e=d.toLowerCase(),j="scroll"+d,l=b[j],n=c=="x"?"Width":"Height";i?(k[j]=i[e]+(m?0:l-g.offset()[e]),f.margin&&(k[j]-=parseInt(h.css("margin"+d))||0,k[j]-=parseInt(h.css("border"+d+"Width"))||0),k[j]+=f.offset[e]||0,f.over[e]&&(k[j]+=h[n.toLowerCase()]()*f.over[e])):k[j]=h[e],/^\d+$/.test(k[j])&&(k[j]=k[j]<=0?0:Math.min(k[j],p(n))),!a&&f.queue&&(l!=k[j]&&o(f.onAfterFirst),delete k[j])}),o(f.onAfter)}).end()}})(jQuery)