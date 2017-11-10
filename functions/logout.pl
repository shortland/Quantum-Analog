#!/usr/bin/perlml

use CGI;

my $cgi = CGI->new;

my $u_cookie = $cgi->cookie (
                -name    => 'u_cookie',
                -value   => '',
                -path    => '/',
                -expires => '-1d'
);
my $p_cookie = $cgi->cookie (
                -name    => 'p_cookie',
                -value   => '',
                -path    => '/',
                -expires => '-1d'
);

print $cgi->header(-cookie =>[$u_cookie, $p_cookie]);