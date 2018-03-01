#!/usr/bin/perl

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$u_cookie = $cgi->param('u_cookie');
	$p_cookie = $cgi->param('p_cookie');
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}
if(!defined $u_cookie)
{
	$u_cookie = "GUEST";
}
if(!defined $p_cookie)
{
	$p_cookie = "GUEST";
}
my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost",
"cody", "password") or die "Could not connect";
my $sqlh = $dbh->prepare("INSERT INTO visitors (ip, useragent, time, u_cookie, p_cookie) VALUES (?, ?, ?, ?, ?);");
$sqlh->execute($ENV{REMOTE_ADDR}, $ENV{HTTP_USER_AGENT}, ''.localtime().'', $u_cookie, $p_cookie);

#if($ENV{REMOTE_ADDR} =~ /(104.173.160.99|107.184.68.48)/)
#{
#	print "<audio src='audio/derp.mp3' autoplay loop></loop>";
#}