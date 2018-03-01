#!/usr/bin/perl

use CGI;
use DBI;
#use CGI::Carp qw ( fatalsToBrowser );

BEGIN
{
	$cgi = new CGI;
	$e_tag = $cgi->param('e_tag');
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
	#$CGI::POST_MAX = 1024 * 100; #100k
	$CGI::POST_MAX = 1024 * 5000; #5mb
}
if($cgi->param('filename') =~ m/\s/g)
{
	#print "<link rel='stylesheet' type='text/css' href='css/style.css'/>";
	print "Please remove any spaces and periods(.) from the image name. Leave only period before the file extension (ie; .png)";
	print "<form action=''><input type='submit' value='Refresh'></form>";
	exit;
}
if (!$cgi->param()) {
print <<"EOHTML";
<!DOCTYPE html>
<html>
<head>
	<title>IMG uploader</title>
	<script src='js/jquery.js'></script>
	<script src='js/functions.js'></script>
</head>
<body>
EOHTML
print $cgi->start_multipart_form(
              -name    => 'main_form');
print $cgi->filefield(
          -name      => 'filename',
    	  -size      => 40,
    	  -maxlength => 80);
print $cgi->textfield(
	-name => 'e_tag',
	-id => 'e_tag',
	-value => 'pre-function',
	-style => 'display:none'
			);
print $cgi->submit(-value => 'Upload image');
print $cgi->end_form;

print <<"EOJS";
<script>
	function randomString() {
	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
	var string_length = 50;
	var randomstring = '';
	for (var i=0; i<string_length; i++) {
		var rnum = Math.floor(Math.random() * chars.length);
		randomstring += chars.substring(rnum,rnum+1);
	}
	return randomstring;
	}
	var tagged_data = localStorage.getItem('e_tag');
	var randomString = randomString();
	if(!tagged_data)
	{
		localStorage.setItem('e_tag', randomString);
		var tagged_data = localStorage.getItem('e_tag');
		\$("#e_tag").val(tagged_data);
	}
	else
	{
		\$("#e_tag").val(tagged_data);
	}
</script>
EOJS
}
if (!$cgi->param('filename') && $cgi->cgi_error()) {
	print $q->cgi_error();
	print "File size is too large";
	exit;
}

if (!$cgi->param()) {
	exit;
}
my ($bytesread, $buffer);
my $num_bytes = 1024;
my $totalbytes;
my $filename = $cgi->upload('filename');
my $untainted_filename;

if (!$filename) {
    print $cgi->p('Invalid file name, please use a real name.');
exit;
}
($fileType) = $filename =~ /\.([^\.]+)$/;
if($fileType !~ m/(jpg|png|gif)/i)
{
	print "Images can only have: .jpg, .png, or .gif file extensions.";
	exit;
}

if ($filename =~ /^([-\@:\/\\\w.]+)$/) {
    $untainted_filename = $1;
} else {
die <<"EOT";
Error; unsupported characters are in the file name; it may only contain alphabetic characters and numbers, and '.'
EOT
}

if ($untainted_filename =~ m/\.\./) {
    die <<"EOT";
File name cannot have '..', remove one of the periods.
EOT
}

	my @chars = ("A".."Z", "a".."z");
	my $random_string;
	$random_string .= $chars[rand @chars] for 1..30;

my $file = "uploads/$random_string$untainted_filename";

open (OUTFILE, ">", "$file") or die "Couldn't open $file for writing: $!";

while ($bytesread = read($filename, $buffer, $num_bytes)) {
    $totalbytes += $bytesread;
    print OUTFILE $buffer;
}
die "Read failure" unless defined($bytesread);
unless (defined($totalbytes)) {
    print "<p>Error; unable to read file ${untainted_filename}, ";
} else {

my $dbh = DBI->connect("DBI:mysql:database=goldernberl;host=localhost", "cody", "password") or die "Could not connect";
my $sqlh = $dbh->prepare("INSERT INTO `e_tag` (`e_tag`, `source`) VALUES (?, ?);");
$sqlh->execute($e_tag, $file);

print "<p>Image has been uploaded! ($totalbytes bytes!)";
print <<"EOHTML";
</body>
</html>
EOHTML
}
close OUTFILE or die "Couldn't close $file: $!";