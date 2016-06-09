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
    $idn = $cgi->param("idn");
    $voteType = $cgi->param("voteType");
    $idrt = $cgi->param("idrt");
}
require "cookie_login.pl";
# if(!defined $idn)
# {
#     print "idn empty";
#     exit;
# }
if(!defined $voteType)
{
    print "voteType empty";
    exit;
}

my $dbh = DBI->connect("DBI:mysql:database=quantumanalog;host=localhost", "$DB_SQL_username", "$DB_SQL_password", {'RaiseError' => 1});

if(defined $idrt)
{
	# upvote the new post
	my $sthd = $dbh->prepare("UPDATE `posts` SET `votes` = votes + 1 WHERE `idrt` = ?");
	$sthd->execute($idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";

	# get the idn of the new post -> in myvotes we use idn
	my $qtsthq = $dbh->prepare("SELECT idn FROM `posts` WHERE `idrt` = ? LIMIT 1");
	$qtsthq->execute($idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";
	while(my($myVoteIdn) = $qtsthq->fetchrow_array())
	{
		my $sthed = $dbh->prepare("INSERT INTO `myVotes` (`self`, `postIdn`, `voteType`) VALUES (?, ?, ?);");
		$sthed->execute($real_email, $myVoteIdn, "upvote") or die "Couldn't execute statement: $DBI::errstr; stopped";
	}
	my $sthdy = $dbh->prepare("UPDATE `posts` SET `idrt` = 'nil' WHERE `idrt` = ?");
	$sthdy->execute($idrt) or die "Couldn't execute statement: $DBI::errstr; stopped";
	print "successy";
	exit;
}

my $qtsth = $dbh->prepare("SELECT voteType FROM `myVotes` WHERE `postIdn` = ? AND self = ? LIMIT 1");
$qtsth->execute($idn, $real_email) or die "Couldn't execute statement: $DBI::errstr; stopped";

while(my($gottenVoteType) = $qtsth->fetchrow_array())
{
	if($gottenVoteType =~ "upvote")
	{
		# -1 on this id in posts table
		my $sth = $dbh->prepare("UPDATE `posts` SET `votes` = votes - 1 WHERE `idn` = ?");
		$sth->execute($idn) or die "Couldn't execute statement: $DBI::errstr; stopped";
	}
	if($gottenVoteType =~ "downVote")
	{
		# +1 on this id in posts table
		my $sth = $dbh->prepare("UPDATE `posts` SET `votes` = votes + 1 WHERE `idn` = ?");
		$sth->execute($idn) or die "Couldn't execute statement: $DBI::errstr; stopped";
	}
}

my $qsth = $dbh->prepare("DELETE FROM `myVotes` WHERE `postIdn` = ? AND self = ? LIMIT 1");
$qsth->execute($idn, $real_email) or die "Couldn't execute statement: $DBI::errstr; stopped";

if($voteType =~ "unvote")
{
	print "success";
	exit;
}

if($voteType =~ "upvote")
{
	my $sth = $dbh->prepare("UPDATE `posts` SET `votes` = votes + 1 WHERE `idn` = ?");
	$sth->execute($idn) or die "Couldn't execute statement: $DBI::errstr; stopped";
}
else
{
	my $sth = $dbh->prepare("UPDATE `posts` SET `votes` = votes - 1 WHERE `idn` = ?");
	$sth->execute($idn) or die "Couldn't execute statement: $DBI::errstr; stopped";
}


my $sthe = $dbh->prepare("INSERT INTO `myVotes` (`self`, `postIdn`, `voteType`) VALUES (?, ?, ?);");
$sthe->execute($real_email, $idn, $voteType) or die "Couldn't execute statement: $DBI::errstr; stopped";

print "success";

$dbh->disconnect();

# my $qsth = $dbh->prepare("DELETE FROM `myVotes` WHERE `postIdn` = ?");
# $qsth->execute($idn) or die "Couldn't execute statement: $DBI::errstr; stopped";

# while(my($gottenVoteType) = $qsth->fetchrow_array())
# {
# 	if($gottenVoteType =~ "upvote")
# 	{
# 		if($voteType =~ $gottenVoteType)
# 		{
# 			$alreadyVoted = "true";
# 		}
# 	}
# 	if($gottenVoteType =~ "downvote")
# 	{
# 		if($voteType =~ $gottenVoteType)
# 		{
# 			$alreadyVoted = "true";
# 		}
# 	}
# }