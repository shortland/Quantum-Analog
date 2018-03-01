#!/usr/bin/perl

use CGI;
use DBI;

BEGIN {
	$cgi = new CGI;
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}


print "<div id='document'>\n";
print "<h2>Coming Soon!</h2>\n";
print "</div>\n";

