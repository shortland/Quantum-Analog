/*
* functions.js
* Author: Ilan Kleiman
* Start Date: 1/26/15
* Made for QuantumAnalog.com
* Beautifulness of jQuery & Javascript
*/

// Global variables
var logged_in = localStorage.getItem('logged');
var u_cookie = localStorage.getItem('u_cookie');
var p_cookie = localStorage.getItem('p_cookie');

function loaded()
{
//alert($(window).width());
$("#content").load("posts.pl", function()
{
	if(logged_in != "true")
	{
	$("#suggestion").html("Members can post and have more options then visitors! <br/>Create an account today: <span style='color:lightblue;cursor:pointer;border-bottom:1px solid blue;padding-bottom:0px;' onClick='logout()'>Register</span><br/>");
	}
	
	makesize();
});

	page_id = "page1";
	var old_hide = localStorage.getItem('hidden');
	var old_show = localStorage.getItem('showing');
	$("#"+old_show).css({"display":"none"}); 
	$("#"+old_hide).fadeIn("fast");
	localStorage.setItem('hidden', page_id);
	localStorage.setItem('showing', page_id+"_b");
	$("#"+page_id+"_b").fadeIn("fast");
	$("#"+page_id).css({"display":"none"}); 
}

function begin(page_id)
{
	var old_hide = localStorage.getItem('hidden');
	var old_show = localStorage.getItem('showing');

	if(page_id == "page1")
	{
		$("#override").html("");
		$("#content").load("posts.pl", function(response,status,xhr)
		{
			makesize();
		});
	}
	if(page_id == "page1_b")
	{
		$("#override").html("");
		$("#content").load("posts.pl", function(response,status,xhr)
		{
			makesize();
		});
	}
	if(page_id == "page2")
	{
		var half_screen_width = $(window).width() / 2;
		$("#override").html("");
		$("#content").load("post.pl");
	}
	if(page_id == "page2_b")
	{
		var half_screen_width = $(window).width() / 2;
		$("#override").html("");
		localStorage.removeItem('e_tag');
		$("#content").load("post.pl");
	}
	if(page_id == "page21")
	{
		$("#override").html("");
		$("#content").load("photos.pl");
	}
	if(page_id == "page21_b")
	{
		$("#override").html("");
		$("#content").load("photos.pl");
	}
	if(page_id == "page3")
	{
		$("#override").html("");
		$("#content").load("chat.pl");
	}
	if(page_id == "page3_b")
	{
		$("#override").html("");
		$("#content").load("chat.pl");
	}
	if(page_id == "page4")
	{
		$("#override").html("");
		if(logged_in != "true")
		{
			window.location.href = 'main.html';
		}
		else
		{
			$("#content").load("profile.pl");
		}
	}
	if(page_id == "page4_b")
	{
		$("#override").html("");
		if(logged_in != "true")
		{
			window.location.href = 'main.html';
		}
		else
		{
			$("#content").load("profile.pl");
		}
	}
	if(page_id == "page5")
	{
		$("#override").html("");
		$("#content").load("about.html?nocache="+Math.random());
	}
	if(page_id == "page5_b")
	{
		$("#override").html("");
		$("#content").load("about.html?nocache="+Math.random());
	}
		if(page_id == old_show)
		{
			return false;
		}
		else
		{
			$("#"+old_show).css({"display":"none"}); 
			$("#"+old_hide).fadeIn("fast");
			localStorage.setItem('hidden', page_id);
			localStorage.setItem('showing', page_id+"_b");
			$("#"+page_id+"_b").fadeIn("fast");
			$("#"+page_id).css({"display":"none"}); 
		}
}
function begin_m(page_name)
{
hamburger_close();
	if(page_name == "posts")
	{
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		$("#content").load("posts.pl", function(response,status,xhr)
		{
			makesize();
		});
	}
	if(page_name == "photos")
	{
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		$("#content").load("photos.pl");
	}
	if(page_name == "chat")
	{
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		$("#content").load("chat.pl");
	}
	if(page_name == "post")
	{
		var half_screen_width = $(window).width() / 2;
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		localStorage.removeItem('e_tag');
		$("#content").load("post.pl");
		$("textarea").css({"width": half_screen_width+"px"});
	}
	if(page_name == "about")
	{
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		$("#content").load("about.html");
	}	
	if(page_name == "profile")
	{
		$("#content").html("<div style='padding-left:55%;'><br/><br/><br/><p>Loading...</p></div>");
		if(logged_in == "true")
		{
			$("#content").load("profile.pl");
		}
		else
		{
			logout();
		}
	}
}
function upload()
{
	var title_i = $("#f_title").val();
	var content_i = $("#f_content").val();
	var author_i = $("#f_author").val();
	var u_cookie = localStorage.getItem('u_cookie');
	var p_cookie = localStorage.getItem('p_cookie');
	var tagged_data = localStorage.getItem('e_tag');
	if(!tagged_data)
	{
		localStorage.setItem('e_tag', randomString());
		var tagged_data = localStorage.getItem('e_tag');
	}
	if(/bitch|bitches|fuck|fucker|fucks| ass | ass |bitchassniger|bitchass| niger | nigger |anus|clit|cock|cocks| cum |porno|porn|shit|dick|faggot|fagg|gay| fag |jerk off|jack off|jerk-off|jack-off|jizz| nigga | niga |penis|pussy|pusssy|shit| boob | wank | tit | titi /i.test(title_i))
	{
		$("#rec").html("Please no profanity, there is a 'temporary' filter on.(profanity in title field)");
		return false;
	}
if(/bitch|bitches|fuck|fucker|fucks| ass | ass |bitchassniger|bitchass| niger | nigger |anus|clit|cock|cocks| cum |porno|porn|shit|dick|faggot|fagg|gay| fag |jerk off|jack off|jerk-off|jack-off|jizz| nigga | niga |penis|pussy|pusssy|shit| boob | wank | tit | titi /i.test(content_i))
	{
		$("#rec").html("Please no profanity, there is a 'temporary' filter on.(profanity in content field)");
		return false;	
	}
if(/bitch|bitches|fuck|fucker|fucks| ass | ass |bitchassniger|bitchass| niger | nigger |anus|clit|cock|cocks| cum |porno|porn|shit|dick|faggot|fagg|gay| fag |jerk off|jack off|jerk-off|jack-off|jizz| nigga | niga |penis|pussy|pusssy|shit| boob | wank | tit | titi /i.test(author_i))
	{
		$("#rec").html("Please no profanity, there is a 'temporary' filter on.(profanity in author field)");
		return false;	
	}
	var formData = {title: $("#f_title").val(), content: $("#f_content").val(), u_cookie: u_cookie, p_cookie: p_cookie, method: 'Upload', e_tag: tagged_data};
	
		$.ajax({
		    url : "post.pl",
		    type: "POST",
		    data : formData,
		    success: function(data, textStatus, jqXHR)
		    {
		    	$("#rec").html("Uploaded!");
		    	$("#f_title").val(" ");
		    	$("#f_content").val(" ");
		    	localStorage.removeItem('e_tag');
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	$("#rec").html("A server error appears to have occured while uploading. <br/> Sorry for the inconvenience.");
		    }
		});
}
function logout()
{
	localStorage.removeItem('u_cookie');
	localStorage.removeItem('p_cookie');
	localStorage.removeItem('login_skip');
	localStorage.removeItem('logged');
	window.location.href='main.html';
}
function login_register()
{
	localStorage.removeItem('u_cookie');
	localStorage.removeItem('p_cookie');
	localStorage.removeItem('login_skip');
	localStorage.removeItem('logged');
	window.location.href='main.html';
}

/*
$(window).load(function()
{
	setTimeout('makesize()', 500);
});
*/
$(window).resize(function(){makesize()});
var makesize = function()
{
	var pg_width = $('#content').width();
	var element_width = pg_width - 25;
	var element_height = element_width / 3;

	$(".article_document").css({"border": "1px solid #253939", "width": element_width, "height": element_height, "display": "inline-block"});
	$(".article_document").show();
}
/*
$(document).ready(function()
{
	alert('helloworld');
	$('.article_document').hover(function()
	{
		alert('hov');
	});
});
*/
/*
$(window).resize(function() 
{
	var pg_width = $(window).width();
	if(pg_width <= 1600)
	{
		var element_width = (pg_width - 120) / 4;
		var element_height = element_width / 2;
		
		if(pg_width <= 1200)
		{
			var element_width = (pg_width - 100) / 4;
			var element_height = element_width / 2;
			
			if(pg_width <= 1000)
			{
				var element_width = (pg_width - 80) / 3;
				var element_height = element_width / 2;
				
				if(pg_width <= 800)
				{
					var element_width = (pg_width - 50) / 2;
					var element_height = element_width / 2;
					
					if(pg_width <= 400)
					{
						var element_width = (pg_width - 22) / 1;
						var element_height = element_width / 2;
					}
				}
			}
		}
	}
	
	$(".article_document").css({"border": "1px solid #253939", "width": element_width+"px", "height": element_height+"px", "display": "inline-block"});
});
*/
function article_open(idn)
{
	if($(window).width() >= 900)
	{
		var half_window = (parseInt($(window).width()) / 2) - 18;
		$("#content").html("");
		$("#override").load("view.pl?doc="+idn+"&u_cookie="+u_cookie+"&p_cookie="+p_cookie, function(){
		$('#article_mw').css({'width' : half_window});
		});
	}
	else
	{
		$("#content").load("view.pl?mobile=true&doc="+idn);
	}
}
function art_post(idn)
{
	
	var send_string = $("#discussion_sender").val();
	if(send_string.length < 3)
	{
		alert('Message must be at least 3 letters long');
		return false;
	}
	var formData = {doc: idn, u_cookie: u_cookie, p_cookie: p_cookie, message: $("#discussion_sender").val()};
	$.ajax({
	    url : "feed.pl",
	    type: "POST",
	    data : formData,
	    success: function(data, textStatus, jqXHR)
	    {
	    	$("#discussion_sender").val("");
		reload_frame();
	    },
	    error: function (jqXHR, textStatus, errorThrown)
	    {
	    	$("#discussion_sender").val("");
	    	alert('An unexpected error has occured');
	    	reload_frame();
	    }
	});
}
function reload_frame()
{
	document.getElementById('feed_frame').src = document.getElementById('feed_frame').src;
}
function randomString() {
	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
	var string_length = 50;
	var randomstring = '';
	for (var i=0; i<string_length; i++) {
		var rnum = Math.floor(Math.random() * chars.length);
		randomstring += chars.substring(rnum,rnum+1);
	}
	return randomstring;
}