<?
DEFINE('WEB_ROOT',"/home/13310/domains/anthroposts.com/html/");

ob_start();
ob_flush();
flush();

ini_set('memory_limit','180M');
set_time_limit( 360 );

require_once WEB_ROOT."includes/classes/database.class.php";
require_once WEB_ROOT."includes/classes/note.class.php";

function getSize($orig_w, $orig_h, $target_w, $target_h, $constrain = false )
{
	if( !is_null($target_w) && !is_null($target_h) && $constrain )
	{
		$imgw = $target_w;
		$imgh = $orig_h / $orig_w * $imgw;
		
		if( $imgh > $target_h )
		{
			$imgh = $target_h;
			$imgw = $orig_w / $orig_h * $imgh;
		}
	}
	else if( !is_null($target_w) && !is_null($target_h) )
	{
		$imgh = $target_w;
		$imgw = $target_h;
	}
	else if( !is_null($target_w) )
	{
		$imgw = $target_w;
		$imgh = $orig_h / $orig_w * $imgw;
	}
	else if( !is_null($target_h) )
	{
		$imgh = $target_h;
		$imgw = $orig_w / $orig_h * $imgh;
	}
	
	return array( "w"=> $imgw, "h"=> $imgh );
}

function clearDirectory( $path )
{
	$d = dir($path); 
	
	while($entry = $d->read()) 
	{ 
		if ($entry!= "." && $entry!= "..") 
		{ 
			unlink($path . '/' . $entry); 
	 	} 
	}
	
	$d->close(); 
}

$target_dir = WEB_ROOT . 'images/notes';

//	remove old images
clearDirectory( $target_dir );

//	create new
$db = new Database( "db13310_notes" );
$sql  = "SELECT id,image_full,image_full_back FROM notes";
$query = $db->query($sql);
$items = array();

while($row = $db->getRow($query)){
	$items[] = $row;
}

if( isset( $_GET['id'] ) )
{
	$images = Note::getAll( array( "id" => $_GET['id'] ) );
}

foreach($items as $item)
{
	if( isset( $item['image_full'] ) ) createImage( $item, 'image_full' );
	if( isset( $item['image_full_back'] ) ) createImage( $item, 'image_full_back', '_back' );
}

function createImage( $item, $data_field, $suffix = '' )
{
	$defs = array
	(
		array('ext'=>'tiny','height'=>30,'crop'=>false)
	);

	if( is_null( $item[ $data_field ] ) || empty( $item[ $data_field ] ) ) return;
	
	$orig = imagecreatefromstring( $item[ $data_field ] );
	
	$width_orig = imagesx($orig);
	$height_orig = imagesy($orig);
	
	foreach($defs as $def)
	{
		$w = $def['width'];
		$h = $def['height'];
		$ext = $def['ext'];
		$crop = $def['crop'];
		
		$dims = getSize( $width_orig, $height_orig, $w, $h, true );
		
		$new_width  = $dims['w'];
		$new_height = $dims['h'];
		
		if( $crop || $w == $h )
		{
			$thumb = getThumbnail( $orig, $w, $crop );
		}
		else
		{
			$thumb = imagecreatetruecolor( $new_width, $new_height );
			imagecopyresampled( $thumb, $orig, 0, 0, 0, 0, $new_width, $new_height, $width_orig, $height_orig );
		}
		
		$path = 'images/notes/' . $item['id'] . '_' . $ext . $suffix . '.jpg';
		
		if( imagejpeg($thumb, WEB_ROOT . $path, 100) )
		{
			imagedestroy($thumb);
			
			echo "<img src='../../" . $path . "' /><br/>";
		}
	}
}


function getThumbnail( $orig, $thumb_size, $crop )
{
	$width_orig  = imagesx($orig);
	$height_orig = imagesy($orig);
	
	$dims = getSize( 	
					$width_orig, 
					$height_orig, 
					$height_orig>=$width_orig ? $thumb_size : null, 
					$width_orig>$height_orig ? $thumb_size : null );
		
	$new_width = $dims['w'];
	$new_height = $dims['h'];
	
	if( $crop )
	{
		$x_mid = $new_width/2;
		$y_mid = $new_height/2;
		
		$process = imagecreatetruecolor( round($new_width), round($new_height) );
		imagecopyresampled( $process, $orig, 0, 0, 0, 0, $new_width, $new_height, $width_orig, $height_orig );
	
		$thumb = imagecreatetruecolor( round($thumb_size), round($thumb_size) );
		imagecopyresampled( $thumb, $process, 0, 0, ($new_width - $thumb_size) / 2, ($new_height - $thumb_size) / 2, $thumb_size, $thumb_size, $thumb_size, $thumb_size );
	}
	else
	{
		$scale = $new_width > $new_height ? $new_height / $new_width : $new_width / $new_height;
		
		//	create canvas
		$process = imagecreatetruecolor( round($new_width), round($new_height) );
		//	copy original to canvas
		imagecopyresampled( $process, $orig, 0, 0, 0, 0, $new_width, $new_height, $width_orig, $height_orig );
		
		$thumb = imagecreatetruecolor( round($thumb_size), round($thumb_size) );
		imagefill( $thumb, 0, 0, imagecolorallocate($thumb, 255, 255, 255) );
		
		imagecopyresampled( 
			$thumb, 
			$process, 
			$new_height > $new_width ? ($new_width - ($new_width * $scale) ) / 2 : 0,
			$new_height <= $new_width ? ($new_height - ($new_height * $scale) ) / 2 : 0, 
			0, 0, 
			$new_width * $scale, $new_height * $scale, $new_width, $new_height );
	}
	
	return $thumb;
}
?>