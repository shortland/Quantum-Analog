#!/usr/bin/perl

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$doc = $cgi->param("doc");
	$u_cookie = $cgi->param("u_cookie");
	$p_cookie = $cgi->param("p_cookie");
	$message = $cgi->param("message");
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}

$message =~ s/</\&lt\;/g;
$message =~ s/>/\&gt\;/g;

print qq{
<!DOCTYPE HTML>
<html>
<head>
	<link rel='stylesheet' type='text/css' href='css/style.css'/>
	<script src='js/jquery.js'></script>
	<title>Feed for $doc</title>
</head>
<body onLoad='bottom()'>
<script>
function bottom()
{
	\$('html, body').animate({ 
	   scrollTop: \$(document).height()-\$(window).height()}, 
	   1000, 
	   "linear"
	);
}
</script>
};
my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";

	my $sqlh0 = $dbh->prepare("SELECT `username` FROM `users` WHERE `u_cookie` = ? AND `p_cookie` = ?");
	$sqlh0->execute($u_cookie, $p_cookie);
	while (my $row = $sqlh0->fetchrow_hashref())
	{
		$real_user = $row->{username}
	}

if(defined $message)
{
    $message_length = length($message);
	if($message_length < "3")
	{
        die "Message isn't long enough\n";
	}
	if($message_length > "10000")
	{
        die "Message is too long\n";
	}
   	else 
    	{
	my $sqlh0 = $dbh->prepare("SELECT `username` FROM `users` WHERE `u_cookie` = ? AND `p_cookie` = ?");
	$sqlh0->execute($u_cookie, $p_cookie);
	while (my $row = $sqlh0->fetchrow_hashref())
	{
		$real_user = $row->{username}
	}
	if($real_user !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
	{
		die "Invalid session, please re-login\n";
	}
	my $sqlh1 = $dbh->prepare("INSERT INTO `discussion` (`doc`, `real_user`, `comment`) VALUES (?, ?, ?);");
	$sqlh1->execute($doc, $real_user, $message);
	    die "\n";
	}
}

print "<div style='text-align:center;border-bottom:1px solid orange;background-color:#253939;color:#FFFFFF;font-size:22px;width:100%;' onClick='bottom()'>Discussion</div>";
print "<div style='position:fixed;top:0px;left:0px;text-align:center;border-bottom:1px solid orange;background-color:#253939;color:#FFFFFF;font-size:22px;width:100%;' onClick='bottom()'>Discussion</div>";
my $sqlh = $dbh->prepare("SELECT * FROM `discussion` WHERE `doc` = ? ORDER BY `idn` ASC");
$sqlh->execute($doc);
while (my $row = $sqlh->fetchrow_hashref())
{
my $messages = $row->{comment};
$messages =~ s/\n/\<br\/\>/g;
	
	
	print "<div style='border-top:1px solid orange;border-bottom: 1px solid orange;color: #253939;'><strong>&nbsp;".$row->{real_user}."</strong> on <strong>".$row->{time}."</strong></div>\n";
	print "<div style='color: #253939;margin-left:5px;'><span style='color:orange !important'>:&nbsp;&nbsp;</span>".$messages."</div>";
	$null_check = $row->{real_user};
}
#print "<div style='height:40px;background-color:#253939;width:100%;'></div>";
if($null_check !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	print "<br/><br/><div style='color:#253939;border-bottom:1px solid orange;font-size:24px;text-align:center;'>No messages; be the first!</div>\n";
}


	if($real_user !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
	{
		print "<p style='color:red'>Login to post!</p>\n";
	}	
$dbh->disconnect();

print qq{</body></html>};