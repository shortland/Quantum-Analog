#!/usr/bin/perlml

use cPanelUserConfig;
#
use CGI::Carp qw( fatalsToBrowser );
use CGI;
use DBI;
use CGI::Cookie;

BEGIN
{
    $DB_SQL_username = "username";
    $DB_SQL_password = "password";

    $q = new CGI;
    $method = $q->param('method');

    %cookies = CGI::Cookie->fetch;

    if(!defined $cookies{'u_cookie'})
    {
       # print $q->header(
       # -type => 'text/html'
       # );
        #print $q->header(-Location=>'login.pl?ref=cookielogin');
    }
    if(!defined $cookies{'p_cookie'})
    {
        #print $q->header(-Location=>'login.pl?ref=cookielogin');
    }
    else
    {
        $got_u_cookie = $cookies{'u_cookie'}->value;
        $got_p_cookie = $cookies{'p_cookie'}->value;

        my $dbh_random123164 = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password",
        {'RaiseError' => 1});

        my $sth_random123164 = $dbh_random123164->prepare("SELECT u_cookie, p_cookie, username, email FROM users WHERE u_cookie = ? AND p_cookie = ?");
        $sth_random123164->execute($got_u_cookie, $got_p_cookie) or die "Couldn't execute statement: $DBI::errstr; stopped";
        
        while(my($u_cookie, $p_cookie, $username, $email, $user_valid) = $sth_random123164->fetchrow_array())
        {
            $real_username = $username;
            $real_email = $email;
            $real_access = $user_valid;
            $valida = "ok";
        }
        $dbh_random123164->disconnect();

        if($valida !~ "ok")
        {
            print $q->header(-Location=>'login.pl?ref=cookielogin');
        }
        if(!defined $valida)
        {
            print $q->header(-Location=>'login.pl?ref=cookielogin');
        }

        if(!defined $real_email)
        {
            $real_email = "notLoggedIn";
        }
    }
}
	#print $q->header(
	#  -type => 'text/html'#### $ real email, nonstrict is here, meaning no redirect to login.pl (if not logged) else give info such as realemail for use in getPosts.pl to find myVOtes
	#);
    #print $real_email."<HERE";
	open(STDERR, ">&STDOUT");
1;