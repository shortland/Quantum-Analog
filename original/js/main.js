		function login_toggle()
		{	
			localStorage.setItem('fallback', '-');
			$("#login_button").fadeOut("slow");
			$("#inv_login").fadeIn("slow");
			$("#reg_login").fadeOut("slow");
		}
		function register_toggle()
		{
			localStorage.setItem('fallback', '-');
			$("#register_button").fadeOut("slow");
			$("#reg_login").fadeIn("slow");
			$("#inv_login").fadeOut("slow");
			$("#mash").fadeOut("slow");
		}
		function skip()
		{
			localStorage.setItem('fallback', '-');
			localStorage.setItem('login_skip', 'true');
			alert('Press "ok" to continue to the website. \n\n Consider joining the community today.');
			window.location.href = 'http://quantumanalog.com/index.html';
		}
		function ajax_register()
		{
			var pass1 = $("#register_p").val();
			var pass2 = $("#register_p2").val();
			if(pass1 != pass2)
			{
				$("#response").html("Passwords do not match");
				return false;
			}
		
		var captcha_r1 = localStorage.getItem('captcha_sub1');
		var captcha_r2 = localStorage.getItem('captcha_sub2');
		var captcha_r3 = localStorage.getItem('captcha_sub3');
		
			var  formData = "username=" + $('#register_u').val() + "&password=" + $('#register_p').val() + "&email=" + $('#register_e').val() + "&method=" + $('#register_m').val() + "&captcha1="+captcha_r1+"&captcha2="+captcha_r2+"&captcha3="+captcha_r3;
			$.ajax({
			    url : "actions/register.pl",
			    type: "POST",
			    data : formData,
			    success: function(data, textStatus, jqXHR)
			    {
			    	$("#response").html(data);
				$("#register_p").val("");
				$("#register_p2").val("");
				$("#register_e").val("");
				fetch_img();
				if(data == "Registered!<br/><br/>\n")
				{
					$("#inv_login").fadeIn("slow");
					$("#reg_login").fadeOut("slow");
					$("#an_or").fadeOut("slow");
					$("#login_u").val($("#register_u").val());
				}
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	$("#response").html("An error has occured");
			    }
			});
		}		
		function ajax_login()
		{
			var  formData = "username=" + $("#login_u").val() + "&password=" + $("#login_p").val() + "&method=" + $("#login_m").val();
			$.getScript('actions/login.pl?'+formData);
		}