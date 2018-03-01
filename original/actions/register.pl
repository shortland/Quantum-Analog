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
	$email = $cgi->param("email");
	$captcha1 = $cgi->param("captcha1");
	$captcha2 = $cgi->param("captcha2");
	$captcha3 = $cgi->param("captcha3");
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}

if(!defined $method || $method !~ m/(register)/i)
{
	die "Error<br/><br/>\n";
}
if(!defined $username || $username !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "Error<br/><br/>\n";
}
if(!defined $password || $password !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "Error<br/><br/>\n";
}
if(!defined $email || $email !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0|\@|\.)/i || $email !~ m/\@/i)
{
	die "Please use a valid Email<br/><br/>\n";
}

if($method =~ m/register/i)
{	
	my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";
	
	my $sqlh0 = $dbh->prepare("SELECT `name` FROM `captcha_keys` WHERE `key` = ?");
	$sqlh0->execute($captcha1);
	while (my $row = $sqlh0->fetchrow_hashref())
	{
		$name_1 = $row->{name};
	}
	if($name_1 !~ m/(orange|fish)/i)
	{
		die "Invalid captcha request\n";
	}
	else
	{
		if($name_1 !~ "orange")
		{
			die "Captcha is incorrect\n";
		}
		else
		{
			my $sqlh0b = $dbh->prepare("DELETE FROM `captcha_keys` WHERE `key` = ?");
			$sqlh0b->execute($captcha1);
		}
	}
	
	my $sqlh1 = $dbh->prepare("SELECT `name` FROM `captcha_keys` WHERE `key` = ?");
	$sqlh1->execute($captcha2);
	while (my $row = $sqlh1->fetchrow_hashref())
	{
		$name_2 = $row->{name};
	}
	if($name_2 !~ m/(orange|fish)/i)
	{
		die "Invalid captcha request\n";
	}
	else
	{
		if($name_2 !~ "orange")
		{
			die "Captcha is incorrect\n";
		}
		else
		{
			my $sqlh1b = $dbh->prepare("DELETE FROM `captcha_keys` WHERE `key` = ?");
			$sqlh1b->execute($captcha2);
		}
	}

	my $sqlh2 = $dbh->prepare("SELECT `name` FROM `captcha_keys` WHERE `key` = ?");
	$sqlh2->execute($captcha3);
	while (my $row = $sqlh2->fetchrow_hashref())
	{
		$name_3 = $row->{name};
	}
	if($name_3 !~ m/(orange|fish)/i)
	{
		die "Invalid captcha request\n";
	}
	else
	{
		if($name_3 !~ "orange")
		{
			die "Captcha is incorrect\n";
		}
		else
		{
			my $sqlh2b = $dbh->prepare("DELETE FROM `captcha_keys` WHERE `key` = ?");
			$sqlh2b->execute($captcha3);
		}
	}
	
	my $sqlh = $dbh->prepare("SELECT password FROM users WHERE username = ?");
	$sqlh->execute($username);
	while (my $row = $sqlh->fetchrow_hashref())
	{
		$password_db = $row->{password};
	}
	if($password_db =~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
	{
		die "Username exits<br/><br/>\n";
	}
	else
	{
	# THIS IS NOT SAFE ENCRYPTION AT ALL
	$password_h = encode_base64($password);
	my $sqlh = $dbh->prepare("INSERT INTO users (username, email, password, registered_ip, registered_useragent) VALUES (?, ?, ?, ?, ?);");
	$sqlh->execute($username, $email, $password_h, $ENV{REMOTE_ADDR}, $ENV{HTTP_USER_AGENT});
	$dbh->disconnect();
	die "Registered!<br/><br/>\n";
	}
}
else
{
	die "Error<br/><br/>\n";
}