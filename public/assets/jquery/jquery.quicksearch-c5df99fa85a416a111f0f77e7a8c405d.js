(function(a,b,c,d){a.fn.quicksearch=function(c,d){var e,f,g,h,i="",j=this,k=a.extend({delay:100,selector:null,stripeRows:null,loader:null,noResults:"",bind:"keyup",onBefore:function(){return},onAfter:function(){return},show:function(){this.style.display=""},hide:function(){this.style.display="none"},prepareQuery:function(a){return a.toLowerCase().split(" ")},testQuery:function(a,b,c){for(var d=0;d<a.length;d+=1)if(b.indexOf(a[d])===-1)return!1;return!0}},d);return this.go=function(){var a=0,b=!0,c=k.prepareQuery(i),d=i.replace(" ","").length===0;for(var a=0,e=g.length;a<e;a++)d||k.testQuery(c,f[a],g[a])?(k.show.apply(g[a]),b=!1):k.hide.apply(g[a]);return b?this.results(!1):(this.results(!0),this.stripe()),this.loader(!1),k.onAfter(),this},this.stripe=function(){if(typeof k.stripeRows=="object"&&k.stripeRows!==null){var b=k.stripeRows.join(" "),c=k.stripeRows.length;h.not(":hidden").each(function(d){a(this).removeClass(b).addClass(k.stripeRows[d%c])})}return this},this.strip_html=function(b){var c=b.replace(new RegExp("<[^<]+>","g"),"");return c=a.trim(c.toLowerCase()),c},this.results=function(b){return typeof k.noResults=="string"&&k.noResults!==""&&(b?a(k.noResults).hide():a(k.noResults).show()),this},this.loader=function(b){return typeof k.loader=="string"&&k.loader!==""&&(b?a(k.loader).show():a(k.loader).hide()),this},this.cache=function(){h=a(c),typeof k.noResults=="string"&&k.noResults!==""&&(h=h.not(k.noResults));var b=typeof k.selector=="string"?h.find(k.selector):a(c).not(k.noResults);return f=b.map(function(){return j.strip_html(this.innerHTML)}),g=h.map(function(){return this}),this.go()},this.trigger=function(){return this.loader(!0),k.onBefore(),b.clearTimeout(e),e=b.setTimeout(function(){j.go()},k.delay),this},this.cache(),this.results(!0),this.stripe(),this.loader(!1),this.each(function(){a(this).bind(k.bind,function(){i=a(this).val(),j.trigger()})})}})(jQuery,this,document)