!function(t){function a(t){t.addClass("countdownHolder")}function i(a,i){var o=a.find(".digit");if(o.is(":animated"))return!1;if(a.data("digit")==i)return!1;a.data("digit",i);var n=t("<span>",{"class":"digit",css:{top:"-2.1em",opacity:0},html:i});o.before(n).removeClass("static").animate({top:"2.5em",opacity:0},"fast",function(){o.remove()}),n.delay(100).animate({top:0,opacity:1},"fast",function(){n.addClass("static")})}var o=86400,n=3600,e=60;t.fn.countdown=function(s){function c(t,a,o){i(m.eq(t),Math.floor(o/10)%10),i(m.eq(a),o%10)}var f,r,d,l,u,m,p=t.extend({callback:function(){},timestamp:0},s);return a(this,p),m=this.find(".position"),function h(){(f=Math.floor((p.timestamp-new Date)/1e3))<0&&(f=0),c(0,1,r=Math.floor(f/o)),f-=r*o,c(2,3,d=Math.floor(f/n)),f-=d*n,c(4,5,l=Math.floor(f/e)),c(6,7,u=f-=l*e),p.callback(r,d,l,u),setTimeout(h,1e3)}(),this}}(jQuery);