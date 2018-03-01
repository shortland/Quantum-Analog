#!/usr/bin/perl

use CGI;
use DBI;

BEGIN {
	$cgi = new CGI;
	$answer = $cgi->param('answer');
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}

$answer_l = length($answer);
if($answer_l =~ "3")
{
$password = "password";
my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost",
"cody", $password) or die "Could not connect";
my $sqlh = $dbh->prepare("INSERT INTO captcha (answer) VALUES (?);");
$sqlh->execute($answer);
print "captcha answer saved $answer \n";
}

print " <h2>Save Captcha</h2><br />";
print " <form name='uploader' action='' method='post'>\n";
print "  Answer: <input type='text' name='answer'><br/><br/>\n";
print "  <input type='submit' value='Save Answer'>\n";
print " </form>";

