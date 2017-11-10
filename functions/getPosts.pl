#!/usr/bin/perlml

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;
use Time::Piece;

BEGIN 
{
	$cgi = new CGI;
}

# removed requirements of cookie_login.pl to prevent redirect to login page if not logged in, allows non-logged-in users to view content
#require "cookie_login.pl";
require "nonstrict_login.pl";
	print $cgi->header(
	  -type => 'text/html'
	);
	open(STDERR, ">&STDOUT");

    $DB_SQL_username = "username";
    $DB_SQL_password = "password";


my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password",
{'RaiseError' => 1});

my $sth = $dbh->prepare("SELECT title, content, username, votes, idn, tags, timestamp FROM posts ORDER BY idn DESC");
$sth->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

my $posters;
$posters = $posters.'{{"projects":[';

my $i = 1;
my $next_row = $sth->fetch();
while (my $row = $next_row) 
{
my ($title, $content, $usernamez, $votes, $idn, $tags, $timestamp) = @$row;
    $pvote = "undefined";
    my $qsth = $dbh->prepare("SELECT voteType FROM myVotes WHERE `postIdn` = ? AND `self` = ? LIMIT 1");
    $qsth->execute($idn, $real_email) or die "Couldn't execute statement: $DBI::errstr; stopped";
    while(my($gottenVoteType) = $qsth->fetchrow_array())
    {
        $pvote = $gottenVoteType;
    }   
    $personalVote = $pvote;

    my $t = localtime;
    $currentTime = $t->datetime;
    $currentYear = substr($currentTime, 0, 4);
    $currentMonth = substr($currentTime, 5, 2);
    $currentDay = substr($currentTime, 8, 2);
    $currentHour = substr($currentTime, 11, 2);
    $currentMinute = substr($currentTime, 14, 2);

    $postedTime = $timestamp;
    $postedYear = substr($postedTime, 0, 4);
    $postedMonth = substr($postedTime, 5, 2);
    $postedDay = substr($postedTime, 8, 2);
    $postedHour = substr($postedTime, 11, 2);
    $postedMinute = substr($postedTime, 14, 2);

    if(($currentYear - $postedYear) =~ /^(0)$/)
    {
        # can use unfiltered months
        if(($currentMonth - $postedMonth) =~ /^(0)$/)
        {
            # can use unfiltered days
            if(($currentDay - $postedDay) =~ /^(0)$/)
            {
                # can use unfiltered hours
                if(($currentHour - $postedHour) =~ /^(0)$/)
                {
                    # can use unfiltered minutes
                    if(($currentMinute - $postedMinute) =~ /^(0)$/)
                    {
                        $timeAgo = "a moment ago";
                    }
                    else
                    {
                        if(($currentMinute - $postedMinute) =~ /^(1)$/)
                        {
                            # technicall get seconds(), but just a moment ago
                            $timeAgo = "a few moments ago";
                        }
                        else
                        {
                            $timeAgo = ($currentMinute - $postedMinute) . " minutes ago";
                        }
                        # no resolution
                    }
                }
                else
                {
                    if(($currentHour - $postedHour) =~ /^(1)$/)
                    {
                        # apply formula
                        $timeAgo = (60 - $postedMinute) + $currentMinute;
                        if($timeAgo > 60)
                        {
                            $timeAgo = "over an hour ago";
                        }
                        else
                        {
                            $timeAgo = $timeAgo . " minutes ago";
                        }
                        # no resolution can't use seconds?
                    }
                    else
                    {
                        $timeAgo = ($currentHour - $postedHour) . " hours ago";
                    }
                }
            }
            else
            {
                if(($currentDay - $postedDay) =~ /^(1)$/)
                {
                    # apply formula
                    $timeAgo = (24 - $postedHour) + $currentHour;
                    if($timeAgo > 24)
                    {
                        $timeAgo = "over a day ago";
                    }
                    else
                    {
                        $timeAgo = $timeAgo . " hours ago";
                    }
                    # resolution fix
                    if($timeAgo =~ "1 hours ago")
                    {
                        # apply formula
                        $timeAgo = (60 - $postedMinute) + $currentMinute;
                        if($timeAgo > 60)
                        {
# not supposed to be like this
# supposed to be "$timeAgo = "an hour ago";"
                            $timeAgo = (24 - $postedHour) + $currentHour;
                            $timeAgo = $timeAgo . " hours ago";
                        }
                        else
                        {
                            $timeAgo = $timeAgo . " minutes ago";
                        }
                    }
                    # end resolution fix
                }
                else
                {
                    $timeAgo = ($currentDay - $postedDay) . " days ago";
                }
            }
        }
        else
        {
            if(($currentMonth - $postedMonth) =~ /^(1)$/)
            {
                # apply formula
                $timeAgo = (30 - $postedDay) + $currentDay;
                if($timeAgo > 30)
                {
                    $timeAgo = "over a month ago";
                }
                else
                {
                    $timeAgo = $timeAgo . " days ago";
                }
                # resolution fix
                if($timeAgo =~ "1 days ago")
                {
                    # apply formula
                    $timeAgo = (24 - $postedHour) + $currentHour;
                    if($timeAgo > 24)
                    {
                        $timeAgo = "over a day ago";
                    }
                    else
                    {
                        $timeAgo = $timeAgo . " hours ago";
                    }
                }
                # end resolution fix
            }
            else
            {
                $timeAgo = ($currentMonth - $postedMonth) . " months ago";
            }
        }
    }
    else
    {
        if(($currentYear - $postedYear) =~ /^(1)$/)
        {
            # apply formula
            $timeAgo = (12 - $postedMonth) + $currentMonth;
            if($timeAgo > 12)
            {
                $timeAgo = "over a year ago";
            }
            else
            {
                $timeAgo = $timeAgo . " months ago";
            }
            # resolution fix
            if($timeAgo =~ "1 months ago")
            {
                # apply formula
                $timeAgo = (30 - $postedDay) + $currentDay;
                if($timeAgo > 30)
                {
                    $timeAgo = "over a month ago";
                }
                else
                {
                    $timeAgo = $timeAgo . " days ago";
                }
            }
            # end resolution fix
        }
        else
        {
            $timeAgo = ($currentYear - $postedYear) . " years ago";
        }
    }

	$posters = $posters.'{"b43t1f0lp03t1t3m3": {"title" : "'.$title.'", "content" : "'.$content.'", "username" : "'.$usernamez.'", "votes" : "'.$votes.'", "idn" : "'.$idn.'", "tags" : "'.$tags.'", "timeAgo": "'.$timeAgo.'", "personalVote" : "'.$personalVote.'"}}';

    $next_row = $sth->fetch();
    if ($next_row)
	{
		$posters = $posters.", ";
	}
}
$dbh->disconnect();

$posters = $posters."]}}";
$posters =~ s/^.(.*).$/$1/;
print $posters;