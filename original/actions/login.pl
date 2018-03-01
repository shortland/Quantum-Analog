#!/usr/bin/perl

use CGI;
use MIME::Base64;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$method = $cgi->param("method");
	$username = $cgi->param("username");
	$password = $cgi->param("password");
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}

if(!defined $method || $method !~ m/(login)/i)
{
	die "\$('#response').html('Error<br/><br/>');\n";
}
if(!defined $username || $username !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "\$('#response').html('Username field is empty<br/><br/>');\n";
}
if(!defined $password || $password !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "\$('#response').html('Password field is empty<br/><br/>');\n";
}
if($method =~ m/login/i)
{	
	$password_o = encode_base64($password);
	my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";
	my $sqlh = $dbh->prepare("SELECT password, u_cookie, p_cookie FROM users WHERE username = ? AND password = ?");
	$sqlh->execute($username, $password_o);
	while (my $row = $sqlh->fetchrow_hashref()){
		$password_db = $row->{password};
		$password_h = $password_db;
		$rand1db = $row->{u_cookie};
		$rand2db = $row->{p_cookie};
	}
	if($password_db =~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
	{
		if($password_o =~ $password_h)
		{	
			if($rand1db =~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
			{
				$rand1 = $rand1db;
				$rand2 = $rand2db;
			}
			else
			{
				@chars = ("A".."Z", "a".."z", "1".."9");
				$rand1 .= $chars[rand @chars] for 1..24;
				$rand2 .= $chars[rand @chars] for 1..24;
			}
			my $sqlh2 = $dbh->prepare("UPDATE users SET u_cookie = ?, p_cookie = ? WHERE username = ? AND password = ?");
			$sqlh2->execute($rand1, $rand2, $username, $password_o);
			print "		
					localStorage.setItem('u_cookie', '$rand1');
					localStorage.setItem('p_cookie', '$rand2');
					localStorage.setItem('login_skip', 'true');
					localStorage.setItem('logged', 'true');
					var url = \"http://quantumanalog.com/index.html\";   
					\$(location).attr('href',url);
			";
			#die "Success\n"; 
		}
		else
		{
			die "\$('#response').html('Invalid login, password or username is incorrect<br/><br/>');\n";
		}
	}
	else
	{
		die "\$('#response').html('Invalid login, password or username is incorrect<br/><br/>');\n";
	}

}
else
{
	die "Error<br/><br/>\n";
}
	#$dbh->disconnect();