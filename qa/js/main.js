$(document).ready(function()
{
	// check for login & apply html if not.
	if(!localStorage.getItem("loggedIn") || (localStorage.getItem("loggedIn") == "false"))
	{
		$("#profileTab").html("Create Account");
		$("#logoutTab").html("Login");
		$("#rvfont").html("");

		var canVote = false;
	}
	
	localStorage.clear();
	
	$.ajax(
	{
	    type: 'POST', 
	    url: 'functions/testing.pl', 
	    success: function(data) 
	    {
	    	if(data == "ok")
	    	{
	    		localStorage.setItem("loggedIn", "true");
	    	}
	    	else
	    	{
	    		localStorage.setItem("loggedIn", "false");
	    	}
	    }
	});

	// positioning stuff
	$(window).on("resize", function ()
	{	
		//$(".postedQuestion").css({"height" : "-=45px"}, 0);

		$(".topHeaderRight").css({"left" : ($(window).width()-($("#profileTab").width() + $("#logoutTab").width() + 30))});

		$(".modal-inset").css({"left" : (($(window).width() - 300) / 2)});
		
		$(".modal-inset").css({"left" : (($(window).width() - 300) / 2)});

		$("#partitionedPagePosts").css({"width" : ($(window).width() - 280)});

		$("#partitionedSidePosts").css({"left" : ($(window).width() - 250)});
	}).resize();

	// select questions tab
	$("#questionsTab").addClass("selectedMidTab");

	// logout
	$("#logoutTab").click(function()
	{
		if($(this).html() == "Logout")
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
		}
		else
		{
			window.location.href = 'index.html';
		}
	});

	// pages
	$("#ourTab").click(function()
	{
		window.location.href = 'main.html';
	});

	$("#profileTab").click(function()
	{
		if($(this).html() == "Profile")
		{
			window.location.href = 'profile.html';
		}
		else
		{
			window.location.href = 'index.html?func=register';
		}
	});

	$(".midHeaderTabs").click(function()
	{
		$(".midHeaderTabs").removeClass("selectedMidTab");
		$(this).addClass("selectedMidTab");
	});

	// main content feed
	$.ajax(
	{ 
	    type: 'POST', 
	    url: 'functions/getPosts.pl', 
	    //data: {}, 
	    success: function(data) 
	    {
	    	//$("#postFeed").html(data);
	    	jsonParser(data);
	    }
	});

	var jsonParser = function(datax)
	{
		var dataSn = JSON.stringify(datax);
		var count = (dataSn.match(/b43t1f0lp03t1t3m3/g) || []).length;
		//var count = count + 1;
		datax = JSON.parse(datax);
		for (i = 0; i < count; i++)
		{
			var timeago = datax.projects[i].b43t1f0lp03t1t3m3['timeAgo'];

			if(i == (count-1))
			{
				$(".postedQuestion").css({"height" : "-=45px"}, 0);

				if(canVote == false)
				{
					$(".upVote").click(function()
					{
						popitup("Login to vote");
					});
					$(".downVote").click(function()
					{
						popitup("Login to vote");
					});
				}
				else
				{
					$(".upVote").click(function()
					{
						var stripString = this.id;
						var idn = stripString.replace('uv', '');
						if(localStorage.getItem("dv" + idn) == "voted")
						{
							var initialVote = parseInt($("#voteCount" + idn).html()) + 1;
						}
						else
						{
							var initialVote = parseInt($("#voteCount" + idn).html());
						}
						var ifExistsVote = localStorage.getItem("uv" + idn);
						if(ifExistsVote == "voted")
						{
							$("#uv" + idn).css({"border-bottom-color" : "rgba(200, 200, 200, 1.0)"});
							localStorage.setItem("uv" + idn, "unvoted");
							$("#voteCount" + idn).html((initialVote - 1));
							$.ajax(
							{ 
							    type: 'POST', 
							    url: 'functions/vote.pl', 
							    data: {"idn" : idn, "voteType" : "unvote"}, 
							    success: function(data) 
							    {
							    	//$("#postFeed").html(data);
							    	//jsonParser(data);
							    }
							});
							return;
						}
						$.ajax(
						{ 
						    type: 'POST', 
						    url: 'functions/vote.pl', 
						    data: {"idn" : idn, "voteType" : "upvote"}, 
						    success: function(data) 
						    {
						    	//$("#postFeed").html(data);
						    	//jsonParser(data);
						    }
						});
						$(this).css({"border-bottom-color" : "rgba(0, 0, 0, 1.0)"});
						$("#voteCount" + idn).html((initialVote + 1));
						$("#dv" + idn).css({"border-top-color" : "rgba(200, 200, 200, 1.0)"});
						localStorage.setItem("uv" + idn, "voted");
						localStorage.setItem("dv" + idn, "unvoted");
					});
					$(".downVote").click(function()
					{
						var stripString = this.id;
						var idn = stripString.replace('dv', '');
						if(localStorage.getItem("uv" + idn) == "voted")
						{
							var initialVote = parseInt($("#voteCount" + idn).html()) - 1;
						}
						else
						{
							var initialVote = parseInt($("#voteCount" + idn).html());
						}
						var ifExistsVote = localStorage.getItem("dv" + idn);
						if(ifExistsVote == "voted")
						{
							$("#dv" + idn).css({"border-top-color" : "rgba(200, 200, 200, 1.0)"});
							localStorage.setItem("dv" + idn, "unvoted");
							$("#voteCount" + idn).html((initialVote + 1));
							$.ajax(
							{ 
							    type: 'POST', 
							    url: 'functions/vote.pl', 
							    data: {"idn" : idn, "voteType" : "unvote"}, 
							    success: function(data) 
							    {
							    	//$("#postFeed").html(data);
							    	//jsonParser(data);
							    }
							});
							return;
						}
						$.ajax(
						{ 
						    type: 'POST', 
						    url: 'functions/vote.pl', 
						    data: {"idn" : idn, "voteType" : "downVote"}, 
						    success: function(data) 
						    {
						    	//$("#postFeed").html(data);
						    	//jsonParser(data);
						    }
						});
						$(this).css({"border-top-color" : "rgba(255, 72, 71, 1.0)"});
						$("#voteCount" + idn).html((initialVote - 1));
						$("#uv" + idn).css({"border-bottom-color" : "rgba(200, 200, 200, 1.0)"});
						localStorage.setItem("dv" + idn, "voted");
						localStorage.setItem("uv" + idn, "unvoted");
					});

					/*
						open link to view the post
					*/
					$(".postedTitle").click(function()
					{
						alert("Full page coming soon!~ \n\n" + $("#"+this.id+"content").html());
						//window.location.href = "questions.html?q=" + this.id + "&pos=" + $(this).position().top;
						//window.scrollTo(0, $(this).position().top);
					});
				}
				
				/*
					One day.
				*/
				var lastOne = "display : none";
			}

			$("a").click(function(event)
			{
				event.preventDefault();
			});

			$("#partitionedPagePosts").append(
				"<div class='postedQuestion' style='" + lastOne + "'>" +
					"<div class='upVote uv" + datax.projects[i].b43t1f0lp03t1t3m3['personalVote'] + "' id='uv" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "'></div>" + 
					"<div class='downVote dv" + datax.projects[i].b43t1f0lp03t1t3m3['personalVote'] + "' id='dv" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "'></div>"+
					"<div class='voteCount' id='voteCount" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "'>" + datax.projects[i].b43t1f0lp03t1t3m3['votes'] + "</div>" +
					"<div class='postedTitle' id='" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "'><a href='questions.html?q=" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "' style='text-decoration:none;spointer-events: none;'>" + datax.projects[i].b43t1f0lp03t1t3m3['title'] + "</a></div>" +
					"<div style='display:none' id='" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "content'>" + datax.projects[i].b43t1f0lp03t1t3m3['content'] + "</div>" +
					"<div style='display:none;' id=''>" + datax.projects[i].b43t1f0lp03t1t3m3['idn'] + "</div>" +
					"<div class='submissionPost'>Submitted " + timeago + " by <span class='userLink'>" + datax.projects[i].b43t1f0lp03t1t3m3['username'] + "</span></div>" +
					"<div class='submissiontags'>" + datax.projects[i].b43t1f0lp03t1t3m3['tags'] + "</div>" +
					"<div class='personalVote' style='display:none;'>" + datax.projects[i].b43t1f0lp03t1t3m3['personalVote'] + "</div>" +
				"</div>");

			if(datax.projects[i].b43t1f0lp03t1t3m3['personalVote'] == "upvote")
			{
				localStorage.setItem("uv" + datax.projects[i].b43t1f0lp03t1t3m3['idn'], "voted");
				$("#uv" + datax.projects[i].b43t1f0lp03t1t3m3['idn']).css({"border-bottom-color" : "rgba(0, 0, 0, 1.0)"});
			}
			if(datax.projects[i].b43t1f0lp03t1t3m3['personalVote'] == "downVote")
			{
				localStorage.setItem("dv" + datax.projects[i].b43t1f0lp03t1t3m3['idn'], "voted");
				$("#dv" + datax.projects[i].b43t1f0lp03t1t3m3['idn']).css({"border-top-color" : "rgba(255, 72, 71, 1.0)"});
			}
		}
	}

	$("#postButton").click(function()
	{
		var s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var idrt = Array.apply(null, Array(25)).map(function() { return s.charAt(Math.floor(Math.random() * s.length)); }).join('');
		if(localStorage.getItem("loggedIn") !== "true") 
		{
			popitup("Please login to post!");
			return;
		}
		if(($("#postTitle").val()).length < 6)
		{
			popitup("<div style='position:relative;top:8px;margin-bottom:-2px;color:rgba(255,72,71,1);'>Please use a title with more than 5 characters.</div>");
			return;
		}
		if(($("#postContent").val()).length < 5)
		{
			popitup("<div style='position:relative;top:8px;margin-bottom:-2px;color:rgba(255,72,71,1);'>The content field should have at least 5 characters.</div>");
			return;
		}
		$.ajax(
		{ 
		    type: 'POST', 
		    url: 'functions/postAPost.pl', 
		    data: {'title' : $("#postTitle").val(), 'content' : $("#postContent").val(), 'tags' : $("#postTags").val(), 'idrt' : idrt}, 
		    success: function(data) 
		    {
		    	if(data == "success")
		    	{
	    			$.ajax(
					{ 
					    type: 'POST', 
					    url: 'functions/vote.pl', 
					    data: {"idrt" : idrt, "voteType" : "upvote"}, 
					    success: function(data) 
					    {
					    	window.location.href = window.location.href;
					    }
					});
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
		    		popitup("<br/><font color='red'>" + data + "</font>");
		    	}
		    }
		});
	});

	$("#askQuestionButton").click(function()
	{
		$("title").html("Post | Quantum Analog");

		$(".modal-inset").css({"left" : "25%", "width" : "50%"});
		$(window).resize(function()
		{
			$(".modal-inset").css({"left" : "25%"});
		});

		$(".postFields").animate({"width" : "100%"}, 0);
		popitup();
		$("#postItForm").show();

		//$(".postFieldsd").css({"width" : (($(".postFields").width() - 32) / 2)});

		//$(".postFieldse").css({"width" : (($(".postFields").width() + 12) / 2)});

		$(".close").click(function()
		{
			$("#postItForm").hide();
			$("title").html("Home | Quantum Analog");
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
		$(document).keyup(function(e)
		{
			if(e.keyCode == 27)
			{
				if($("#modal-overlay").is(':visible'))
				{
					$modal.removeClass('state-appear').addClass('state-leave');
					$("#modal-overlay").hide();
				}
			}

			if(e.keyCode == 13)
			{
				if($("#modal-overlay").is(':visible'))
				{
					if(!$("textarea").is(":focus"))
					{
						$("#postButton").click();
					}
				}
			}
		});
    }
});