/*global jQuery */
/*jslint white: true, browser: true, onevar: true, undef: true, nomen: true, eqeqeq: true, bitwise: true, regexp: true, newcap: true, strict: true, maxerr: 50, indent: 4 */
/**
 * Set all passed elements to the same height as the highest element.
 * 
 * Copyright (c) 2010 Ewen Elder
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * @author: Ewen Elder <glomainn at yahoo dot co dot uk> <ewen at jainaewen dot com>
 * @version: 1.0
**/
"use strict",function(a){a.fn.equalHeightColumns=function(b){var c,d;return b=a.extend({},a.equalHeightColumns.defaults,b),c=b.height,d=a(this),a(this).each(function(){b.children&&(d=a(this).children(b.children)),b.height||(b.children?d.each(function(){a(this).outerHeight()>c&&(c=a(this).outerHeight())}):a(this).outerHeight()>c&&(c=a(this).outerHeight()))}),c-=b.heightOffset,b.minHeight&&c<b.minHeight&&(c=b.minHeight),b.maxHeight&&c>b.maxHeight&&(c=b.maxHeight),d.animate({minHeight:c},b.speed),a(this)},a.equalHeightColumns={version:1,defaults:{children:!1,height:0,minHeight:0,maxHeight:0,speed:0,heightOffset:0}}}(jQuery)