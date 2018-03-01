<?php
$example = $_POST['code'];
if(empty($example))
{
	echo "<form method='post'><textarea name='code'></textarea><input type='submit'></form>";
}
$c = curl_init('http://markup.su/api/highlighter');
curl_setopt_array($c, array(
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => 'language=HTML&theme=Sunburst&source=' . urlencode($example)
));
$response = curl_exec($c);
$info = curl_getinfo($c);
curl_close($c);

if ($info['http_code'] == 200 && $info['content_type'] == 'text/html') {
    echo $response;
} else {
    echo 'Error';
}
?>