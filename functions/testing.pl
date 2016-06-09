#!/usr/bin/perlml

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use CGI::Cookie;

BEGIN 
{
    $cgi = new CGI;
}
require "cookie_login.pl";

print "ok";