$(document).ready(function()
{
	/* 
		initialize fastclick (removes 300ms delay)
		https://github.com/ftlabs/fastclick
	*/
	if(window.location.href == "http://ilankleiman.com/qa/index.html?func=register")
	{
		$("#loginSubmit").html("Create Account");
		$("#addonRegister").html
			("<input style='width: 300px !important; border-bottom: 1px solid silver;' type='text' id='usernameField' placeholder='Username' autocomplete='off' autocorrect='off' autocapitalize='off' spellcheck='false'/>" +
			"<br/>");
		$("#registerLink").hide();
		$("#loginLink").show();
		$("title").html("Register | Quantum Analog");	
	}

	$(function() 
	{
	    FastClick.attach(document.body);
	});

	if(localStorage.getItem("loggedIn") == "true")
	{
		window.location.href = "main.html";
		//return;
	}
	else
	{
		localStorage.clear();
	}

	// prevent overscrolling on index.html
	/*
	$("body").addClass("noScroll");
	$("body").bind("touchmove", function(e){e.preventDefault()});
	*/

	$("#loginForm, .modal-inset").css({"left" : (($(window).width() - 300) / 2)});
	$(window).resize(function()
	{
		$("#loginForm, .modal-inset").css({"left" : (($(window).width() - 300) / 2)});
		$("#usernameField").css({"width" : $("#loginSubmit").width()});
	});

	$("#skipLink").click(function()
	{
		localStorage.clear();
		localStorage.setItem("loggedIn", "false");
		window.location.href = "main.html";
	});

	$("#registerLink").click(function()
	{
		$("#loginSubmit").html("Create Account");
		$("#addonRegister").html
			("<input style='width: 300px !important; border-bottom: 1px solid silver;' type='text' id='usernameField' placeholder='Username' autocomplete='off' autocorrect='off' autocapitalize='off' spellcheck='false'/>" +
			"<br/>");
		$("#registerLink").hide();
		$("#loginLink").show();
		$("title").html("Register | Quantum Analog");
	});

	$("#loginLink").click(function()
	{
		$("title").html("Login | Quantum Analog");
		$("#loginSubmit").html("Log in");
		$("#addonRegister").html("");
		$("#registerLink").show();
		$("#loginLink").hide();
	});

	$("#loginSubmit").click(function()
	{
		if($("#loginSubmit").html() == "Log in")
		{
			if(($("#emailField").val()).indexOf("@") > -1)
			{
				//
				//popitup("ok");
			}
			else
			{
				popitup("Please use your <strong>email</strong> to login, not your username");
				return;
			}
			$.ajax(
			{ 
			    type: 'POST', 
			    url: 'functions/login.pl', 
			    data: {'username' : $("#emailField").val(), 'password' : btoa($("#passwordField").val())}, 
			    success: function(data) 
			    {
			    	if(data.indexOf("success:") > -1)
			    	{
			    		localStorage.setItem("loggedIn", "true");
			    		window.location.href = "main.html";
			    	}
			    	else
			    	{
			    		popitup(data);
			    		//popitup(data+"Email or password is incorrect");
			    	}
			    }
			});
		}
		else
		{
			if(($("#emailField").val()).length < 4)
			{
				popitup("Please use a valid email address");
				return;
			}
			if(($("#usernameField").val()).length < 3)
			{
				popitup("Please choose a username with more than 3 characters");
				return;
			}
			if(($("#passwordField").val()).length < 3)
			{
				popitup("Please choose a password with more than 3 characters");
				return;
			}
			$.ajax(
			{ 
			    type: 'POST', 
			    url: 'functions/register.pl', 
			    data: {'username' : $("#usernameField").val(), 'password' : btoa($("#passwordField").val()), 'email' : $("#emailField").val()}, 
			    success: function(data) 
			    {
			    	if(data == "Username is taken\n")
			    	{
			    		popitup("That username has been taken");
			    		return;
			    	}
			    	if(data == "success")
			    	{
			    		// technically we have our cookies set already, but let's make them physically login
			    		localStorage.setItem("loggedIn", "true");
			    		popitup("Registration successful. Please log in");
						$("title").html("Login | Quantum Analog");
						$("#loginSubmit").html("Log in");
						$("#addonRegister").html("");
						$("#registerLink").show();
						$("#loginLink").hide();
			    	}
			    	else
			    	{
			    		popitup("Email is already registered");
			    	}
			    }
			});
		}
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