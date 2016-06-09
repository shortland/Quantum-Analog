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

#my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password",
#{'RaiseError' => 1});

#my $sth = $dbh->prepare("TRUNCATE posts");
#$sth->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";
#$dbh->disconnect();