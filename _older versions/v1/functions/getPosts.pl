#!/usr/bin/perlml

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;

BEGIN 
{
	$cgi = new CGI;
}
require "cookie_login.pl";

my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password",
{'RaiseError' => 1});

my $sth = $dbh->prepare("SELECT title, content, username FROM posts ORDER BY idn DESC");
$sth->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while(my($title, $content, $usernamez) = $sth->fetchrow_array())
{
	print "<div id='post'>";
	print "<span class='postGotTitle'>$title</span> <br/>";
	print "<span class='postGotContent'>&nbsp;&nbsp;Content: $content <br/></span><span class='name'>&nbsp;&nbsp;By $usernamez</span>";
	print "<br/>";
	print "</div>";
}
$dbh->disconnect();