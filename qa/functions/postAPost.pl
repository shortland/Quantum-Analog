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
    $title = $cgi->param("title");
    $idrt = $cgi->param("idrt");
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
my $t = localtime;
$ctime = $t->datetime;

$title =~ s/</\&lt;/g;
$title =~ s/>/\&gt;/g;
$content =~ s/</\&lt;/g; 
$content =~ s/>/\&gt;/g;

$title =~ s/\n/<br\/>/g;
$content =~ s/\n/<br\/>/g;

$titile =~ s/{/\{/g;
$title =~ s/}/\}/g;
$content =~ s/{/\{/g;
$content =~ s/}/\}/g;

$title =~ s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
$content =~ s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;

$content =~ s/"/&quot;/g;
$content =~ s/'/&apos;/g;
$title =~ s/"/&quot;/g;
$title =~ s/'/&apos;/g;

$title =~ s/\\/&bsol;/g;
$content =~ s/\\/&bsol;/g;

$title =~ s/\//&sol;/g;
$content =~ s/\//&sol;/g;

$title =~ s/\s\s/&nbsp;&nbsp;/g;
$content =~ s/\s\s/&nbsp;&nbsp;/g;

$title =~ s/b43t1f0lp03t1t3m3/b43t1f0lp03t1t3m&sup3;/g;
$content =~ s/b43t1f0lp03t1t3m3/b43t1f0lp03t1t3m&sup3;/g;

my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password", {'RaiseError' => 1});

my $qtsth = $dbh->prepare("SELECT level, lastPost FROM `users` WHERE `email` = ? LIMIT 1");
$qtsth->execute($real_email) or die "Couldn't execute statement: $DBI::errstr; stopped";

while(my($gotUserLevel, $lastPostTime) = $qtsth->fetchrow_array())
{
	if($gotUserLevel =~ /^(1)$/)
	{
		$currentYear = substr($ctime, 0, 4);
	    $currentMonth = substr($ctime, 5, 2);
	    $currentDay = substr($ctime, 8, 2);
	    $currentHour = substr($ctime, 11, 2);
		$currentMinute = substr($ctime, 14, 2);

		$postedYear = substr($lastPostTime, 0, 4);
	    $postedMonth = substr($lastPostTime, 5, 2);
	    $postedDay = substr($lastPostTime, 8, 2);
	    $postedHour = substr($lastPostTime, 11, 2);
		$postedMinute = substr($lastPostTime, 14, 2);

		$skip = "false";
		# shitty way out, allows a spam post bug time between new hour, new day, new month, new year.
		if($currentYear !~ $postedYear)
		{
			$skip = "true";
		}
		if($currentMonth !~ $postedMonth)
		{
			$skip = "true";
		}
		if($currentDay !~ $postedDay)
		{
			$skip = "true";
		}
		if($currentHour !~ $postedHour)
		{
			$skip = "true";
		}

		if($skip !~ "true")
		{
			$newAllowedTime = $postedMinute + 2;
			if($newAllowedTime > 59)
			{
				$newAllowedTime = 01;
			}
			if($currentMinute >= $newAllowedTime)
			{
				my $sth = $dbh->prepare("INSERT INTO `posts` (`email`, `username`, `title`, `content`, `newtime`, `idrt`) VALUES (?, ?, ?, ?, ?, ?)");
				$sth->execute($real_email, $real_username, $title, $content, $ctime, $idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";
				print "success";
			}
			else
			{
				print "Please wait 2 minutes between posts, ".(2-($currentMinute - $postedMinute))." minutes left";
				exit;
			}
		}
		else
		{
			my $sth = $dbh->prepare("INSERT INTO `posts` (`email`, `username`, `title`, `content`, `newtime`, `idrt`) VALUES (?, ?, ?, ?, ?, ?)");
			$sth->execute($real_email, $real_username, $title, $content, $ctime, $idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";
			print "success";
		}
	}
	if($gotUserLevel >= 2)
	{
		my $sth = $dbh->prepare("INSERT INTO `posts` (`email`, `username`, `title`, `content`, `newtime`, `idrt`) VALUES (?, ?, ?, ?, ?, ?)");
		$sth->execute($real_email, $real_username, $title, $content, $ctime, $idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";
		print "success";
	}
}

my $sth2 = $dbh->prepare("UPDATE `users` SET `lastPost` = ? WHERE `email` = ?");
$sth2->execute($ctime, $real_email) or die "Couldn't execute statement: $DBI::errstr; stopped";

$dbh->disconnect();
