#!/usr/bin/perl

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
   	open(STDERR, ">&STDOUT");
}

$accept_range = "a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0";

my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";
my $sqlh = $dbh->prepare("SELECT * FROM articles ORDER BY date DESC LIMIT 1000");
$sqlh->execute();
print "<span id='css_versatile'></span>";
print "<div id='document'>\n";
print "<div style='height:10px;'></div>";
print "<div id='suggestion'></div>\n";
print "</div>\n";
while (my $row = $sqlh->fetchrow_hashref())
{
	if($row->{e_tag} =~ m/($accept_range)/i)
	{
		my $sqlh0 = $dbh->prepare("SELECT `source` FROM `e_tag` WHERE `e_tag` = ?");
		$sqlh0->execute($row->{e_tag});
		while (my $row = $sqlh0->fetchrow_hashref())
		{
			$source = $row->{source};
			$source_b = $source;
			goto skipper;
		}
			goto randomimage;
	}
	else
	{
		randomimage:
		$rand = int(rand(3)) + 1;
		$source_b = "uploads/code".$rand.".png";
	}
	skipper:
	$author = $row->{author};
        if($author !~ m/($accept_range)/i)
        {
        	$author = "Anonymous Author";
        }
	print <<ofhtml;
	
		<span class='article_document' onClick='article_open("$row->{idn}")'>
			<img src='$source_b' class='article_image'>
			<span class='article_title'>$row->{title}</span>
		</span>
ofhtml

$e_tag = '';
$row->{e_tag} = '';
}
$dbh->disconnect();