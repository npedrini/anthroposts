<?

require_once "/home/13310/domains/anthroposts.com/html/includes/classes/database.class.php";

$id = $_GET['id'];
$type = isset($_GET['type'])?$_GET['type']:"jpg";
$field = isset($_GET['field'])?$_GET['field']:'image_full';

$db = new Database("db13310_notes");
$result = mysql_query("SELECT $field FROM notes WHERE id='$id' LIMIT 1"); 

$row = mysql_fetch_array($result);

$im = imagecreatefromstring($row[$field]);
$width  = imagesx($im);
$height = imagesy($im);

// set thumbnail-height to 180 pixels
if(!is_null($_GET['w']) && !is_null($_GET['h'])){

	$imgh = $_GET['w'];
	$imgw = $_GET['h'];
	
}
else if(!is_null($_GET['h']))
{
	$imgh = $_GET['h'];
	$imgw = $width / $height * $imgh;
	
	if($_GET['constrain']=="1" && $width>$height)
	{
		$imgw = $_GET['h'];
		$imgh = $height / $width * $imgw;
	}
	
}
else if(!is_null($_GET['w']))
{
	$imgw = $_GET['w'];
	$imgh = $height / $width * $imgw;
	
	if($_GET['constrain']=="1" && $height>$width)
	{
		$imgh = $_GET['w'];
		$imgw = $width / $height * $imgh;
	}
	
}

else
{

	$imgw = $width;
	$imgh = $height;
	
}

if($type=="png")
	$content_type = "image/png";
else
	$content_type = "image/jpeg";

// create new image using thumbnail-size
$thumb = imagecreatetruecolor($imgw,$imgh);                  
// copy original image to thumbnail
imagecopyresampled($thumb,$im,0,0,0,0,$imgw,$imgh,ImageSX($im),ImageSY($im));

Header("Content-type: ".$content_type); 

if($type=="png")
	imagepng($thumb);
else
	imagejpeg($thumb);

?>