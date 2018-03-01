#!/usr/bin/perl

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$doc = $cgi->param('doc');
	$mobile = $cgi->param('mobile');
	$u_cookie = $cgi->param('u_cookie');
	$p_cookie = $cgi->param('p_cookie');
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}
if (!defined $doc)
{
	die "You haven't defined an article to view.\n";
}

my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";

my $sqlh = $dbh->prepare("SELECT * FROM articles WHERE idn = ?");
$sqlh->execute($doc);
while (my $row = $sqlh->fetchrow_hashref())
{
$e_tag = $row->{e_tag};
my $sqlh0 = $dbh->prepare("SELECT `source` FROM `e_tag` WHERE `e_tag` = ?");
$sqlh0->execute($e_tag);
while (my $row = $sqlh0->fetchrow_hashref())
{
	$source = $row->{source};
	$source_b = $source;
}
if(!defined $source_b)
{
	$source = "uploads/code4.png";	
}
$snipped_ct = $row->{content};
if($mobile !~ "true")
{
print qq{
<img id='art_image' src='$source' alt='image here'>
	<!-- or code snippet in textarea :D -->

<div id='art_title'>
	<div style='background-color: #253939;'>
		<div class='padded' style='border-bottom: 1px solid orange;font-size:26px;'>$row->{title}</div>
		<div style='height: 2px;'></div>		
		<div class='padded' style='border-bottom: 1px solid orange;'>By: <strong>$row->{real_name}</strong> on <strong>$row->{date}</strong></div>
	</div>
	<div style='height: 6px;'></div>
	<div class='padded' id='article_mw' style='color:#253939;margin-right:4px;margin-left:4px;text-overflow: ellipsis;'>&nbsp;&nbsp; $row->{content}</div>
</div>

	<div id="art_comments" style='-webkit-box-shadow: 0px 2px 0px 0px rgba(0, 0, 0, 0.3); box-shadow: 0px 2px 0px 0px rgba(0, 0, 0, 0.3);'>
	<!-- community/discussion -->
		<iframe id='feed_frame' src='feed.pl?doc=$row->{idn}&u_cookie=$u_cookie&p_cookie=$p_cookie' frameBorder='0px'>Please update to a more modern browser,</iframe>
		<textarea id='discussion_sender' placeholder=' Enter comment or question here'></textarea>
		<button type='button' id='discussion_sender_button' onClick="art_post('$row->{idn}')"> Send </button>
		<!-- localstorage for idn of doc viewing -->
	</div>
};
}
if($mobile =~ "true")
{
	print " <div style='background-color: #253939;'>
		<div class='padded' style='border-bottom: 1px solid orange;font-size:26px;color:white;'>$row->{title}</div>
		</div>";
	print "<img id='art_image' src='$source' alt='image here'>";
	print "<div style='color:#253939;margin-right:4px;margin-left:4px;text-overflow: ellipsis;'>$snipped_ct </div>";
	print "<br/><br/>";
	print "<iframe id='feed_frame' src='feed.pl?doc=$row->{idn}&u_cookie=$u_cookie&p_cookie=$p_cookie' frameBorder='0px'>Please update to a more modern browser,</iframe>";
	print "<div style='z-index:1;height:40px;width:100%;'></div>";
	print " <textarea id='discussion_sender' placeholder=' Enter comment or question here'></textarea>
		<button type='button' id='discussion_sender_button' onClick=\"art_post('$row->{idn}')\"> Send </button>";

}
}