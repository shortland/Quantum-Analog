$(document).ready(function()
{
	// just checking for value in general, could be skipping login // redundant
	if(!localStorage.getItem("loggedIn")) 
	{
		window.location.href = "index.html";
	}
	else
	{
		// technically, could do an ajax here and check for proper login.
		// but - it'll check for valid cookies on every ajax'd page. so no point. a little redundant.
	}

	// on page load -> get feed
	$.ajax(
	{ 
	    type: 'POST', 
	    url: 'functions/getPosts.pl', 
	    //data: {}, 
	    success: function(data) 
	    {
	    	$("#postFeed").html(data);
	    }
	});

	// position stuff
	$(".modal-inset").css({"left" : (($(window).width() - 300) / 2)});
	$(window).resize(function()
	{
		$(".modal-inset").css({"left" : (($(window).width() - 300) / 2)});
	});

	// logout
	$("#logoutButton").click(function()
	{
		$.ajax(
		{ 
		    type: 'POST', 
		    url: 'functions/logout.pl', 
		    success: function(data) 
		    {
		    	localStorage.clear();
				window.location.href = 'index.html';
		    }
		});
	});

	// postThePost
	$("#postAPostButton").click(function()
	{
		if(localStorage.getItem("loggedIn") !== "true") 
		{
			popitup("Please log in to post!");
			return;
		}
		if(($("#postTitleField").val()).length < 6)
		{
			popitup("Please use a title with more than 5 characters.");
			return;
		}
		if(($("#postContentField").val()).length < 5)
		{
			popitup("The content field should have at least 5 characters.");
			return;
		}
		$.ajax(
		{ 
		    type: 'POST', 
		    url: 'functions/postAPost.pl', 
		    data: {'title' : $("#postTitleField").val(), 'content' : $("#postContentField").val()}, 
		    success: function(data) 
		    {
		    	if(data == "success")
		    	{
		    		// some type of refresh function here I guess
		    		window.location.href = window.location.href;
		    	}
		    	else
		    	{
		    		// technically, user would never see these errors, as the ajax posts them, but blank.
		    		if(data == "T empty")
		    		{
		    			popitup("Can't post with an empty title");
		    			return;
		    		}
		    		if(data == "C empty")
		    		{
		    			popitup("Can't post with empty content");
		    			return;
		    		}
		    		popitup("An unknown error occured: <br/>\n" + data);
		    	}
		    }
		});
	});

	/* modal (popup) code */
    $modal = $('.modal-frame');
    /* Need this to clear out the keyframe classes so they dont clash with each other between ener/leave. Cheers. */
    $modal.bind('webkitAnimationEnd oanimationend msAnimationEnd animationend', function(e)
    {
		if($modal.hasClass('state-leave'))
		{
			$modal.removeClass('state-leave');
		}
    });

    $('.close').on('click', function()
    {
		$modal.removeClass('state-appear').addClass('state-leave');
		$("#modal-overlay").hide();
    });
	
	function popitup(text)
    {
		$("#popupTextHere").html(text);
		$modal.removeClass('state-leave').addClass('state-appear');
		$("#modal-overlay").show();
    }
});