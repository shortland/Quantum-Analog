/**
* hamburger.js
*
* Mobile Menu Hamburger
* =====================
* A hamburger menu for mobile websites
*
* Created by Thomas Zinnbauer YMC AG | http://www.ymc.ch
* Date: 21.05.13
* Edit by Ilan Kleiman
* Date: 29.01.15 +=
*/


jQuery(document).ready(function () {

jQuery("#hamburger").click(function () {
var menu_action = localStorage.getItem('menu_action');
if(menu_action == "open")
{
	var menu_action = "open_d";
}
else
{
	var menu_action = "closed_d";
}
if(menu_action == "closed_d")
{
jQuery('#header_title').hide();
jQuery('#content').css('min-height', jQuery(window).height());
jQuery('#mobile_menu_buttons').css('opacity', 1);
var contentWidth = jQuery('#content').width();
jQuery('#content').css('width', contentWidth);
jQuery('#contentLayer').css('display', 'block');
jQuery('#container').bind('touchmove', function (e) {
e.preventDefault()
});
jQuery("#container").animate({"marginLeft": ["70%", 'easeOutExpo']}, {
duration: 0
});
localStorage.setItem('menu_action', 'open');
}
if(menu_action == "open_d")
{
jQuery('#header_title').show();
jQuery('#container').unbind('touchmove');
jQuery("#container").animate({"marginLeft": ["-1", 'easeOutExpo']}, {
duration: 0,
complete: function () {
jQuery('#content').css('width', 'auto');
jQuery('#contentLayer').css('display', 'none');
jQuery('#mobile_menu_buttons').css('opacity', 0);
jQuery('#content').css('min-height', 'auto');
}
});
localStorage.setItem('menu_action', 'closed');
}
});
jQuery("#contentLayer").click(function () {
jQuery('#header_title').show();
jQuery('#container').unbind('touchmove');
jQuery("#container").animate({"marginLeft": ["-1", 'easeOutExpo']}, {
duration: 0,
complete: function () {
jQuery('#content').css('width', 'auto');
jQuery('#contentLayer').css('display', 'none');
jQuery('#mobile_menu_buttons').css('opacity', 0);
jQuery('#content').css('min-height', 'auto');
}
});
});

});

function hamburger_close()
{
jQuery('#header_title').show();
jQuery('#container').unbind('touchmove');
jQuery("#container").animate({"marginLeft": ["-1", 'easeOutExpo']}, {
duration: 0,
complete: function () {
jQuery('#content').css('width', 'auto');
jQuery('#contentLayer').css('display', 'none');
jQuery('#mobile_menu_buttons').css('opacity', 0);
jQuery('#content').css('min-height', 'auto');
}
});
localStorage.setItem('menu_action', 'closed');
}