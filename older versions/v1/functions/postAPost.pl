#!/usr/bin/perlml

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;

BEGIN 
{
    $cgi = new CGI;
    $title = $cgi->param("title");
    $content = $cgi->param("content");
}
require "cookie_login.pl";
if(!defined $title)
{
    print "T empty";
    exit;
}
if(!defined $content)
{
    print "C empty";
    exit;
}
my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password", {'RaiseError' => 1});

my $sth = $dbh->prepare("INSERT INTO `posts` (`email`, `username`, `title`, `content`) VALUES (?, ?, ?, ?);");
$sth->execute($real_email, $real_username, $title, $content) or die "Couldn't execute statement: $DBI::errstr; stopped";
$dbh->disconnect();

print "success";