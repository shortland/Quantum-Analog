#!/usr/bin/perl

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$title = $cgi->param('title');
	$content = $cgi->param('content');
	$author = $cgi->param('author');
	$method = $cgi->param('method');
	$u_cookie = $cgi->param('u_cookie');
	$p_cookie = $cgi->param('p_cookie');
	$e_tag = $cgi->param('e_tag');
	$code = $cgi->param('code');
	print $cgi->header(-status=> '200 OK', -type => 'text/html', -content_location => 'mydata.ttl', -access_control_allow_origin => '*');
   	open(STDERR, ">&STDOUT");
}
$content =~ s/</\&lt\;/g;
$content =~ s/>/\&gt\;/g;
$title =~ s/</\&lt\;/g;
$title =~ s/>/\&gt\;/;
$author =~ s/>/\&lt\;/g;
$author =~ s/</\&gt\;/g;

$code =~ s/>/\&lt\;/g;
$code =~ s/</\&gt\;/g;
$code =~ s/â€¦ /\. \. \./g;
$code =~ s/…/\. \. \./g;
$code =~ s/\n/<br\/>/g;
$code =~ s/\s\s/\&nbsp\;/g;
$code =~ s/\t/\&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\;/g;

$content =~ s/â€¦ /\. \. \./g;
$content =~ s/…/\. \. \./g;
$content =~ s/\n/<br\/>/g;
$content =~ s/\s\s/\&nbsp\;/g;
$content =~ s/\t/\&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\;/g;

#if($ENV{REMOTE_ADDR} =~ m/(104.173.160.99|107.184.68.48)/)
#{
#	die "Derp derp, derpity derp...\n";
#}

if($method =~ "Upload")
{
if(($content || $title) !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "No content";
}



$password = "password";
my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost",
"cody", $password) or die "Could not connect";
my $sqlh1 = $dbh->prepare("SELECT username FROM users WHERE u_cookie = ? AND p_cookie = ?");
$sqlh1->execute($u_cookie, $p_cookie);
while (my $row = $sqlh1->fetchrow_hashref())
{
	$real_username = $row->{username};
}
if($real_username !~ m/(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0)/i)
{
	die "Invalid Login\n";
}

my $sqlh = $dbh->prepare("INSERT INTO articles (title, content, ip, useragent, real_name, e_tag) VALUES (?, ?, ?, ?, ?, ?);");
$sqlh->execute($title, $content, $ENV{REMOTE_ADDR}, $ENV{HTTP_USER_AGENT}, $real_username, $e_tag);
die "Article Uploaded ".$real_username."\n";
}
print " <div id='document'>";
print " <h2>Upload Article</h2><br/>";
print " <span id='rec'>\n";
print " <form name='uploader' action='' method='post'>\n";
print "  Title: <br/><input type='text' id='f_title' name='title'><br/><br/>\n";
print "  Content: <br/><textarea id='f_content'></textarea><br/><br/>\n";
print "  Image:<br/>Acceptable image types: .png, .jpg, .gif.<br/><iframe name='myIframe' frameBorder='0px' style='height:50px;width:100%;border:0px;border-bottom:1px solid black;' id='file_upload_frame' src='uploader.pl'>Please update to a more modern browser</iframe><br/><br/>\n";
print " <p>Upload image file before uploading the article!</p><br/>\n";
print "  <button type='button' onClick='upload()'>Upload Article</button><br/>\n";
print "  </span>\n";
print " </form>";
print " </div>";