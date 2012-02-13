<?

require_once "../includes/classes/database.class.php";

$action = isset($_GET['action'])?$_GET['action']:null;

if($action=="dimensions")
{
	$db = new Database("db13310_notes");
	$result = mysql_query("SELECT id,image_full FROM notes"); 

	while($row = $db->getRow($result))
	{
		$im = imagecreatefromstring($row['image_full']);
		$width  = imagesx($im);
		$height = imagesy($im);
		
		$update_sql  = "UPDATE notes SET image_width='".$width."', image_height='".$height."' ";
		$update_sql .= "WHERE id='".$row['id']."'";
		
		if(mysql_query($update_sql))
		{
			echo $width."x".$height."<br/>";
			ob_flush();
			flush();
			usleep(1000);
		}
	}
}

else if($action == "audio")
{
	$db = new Database("db13310_notes");
	$result = mysql_query("SELECT id FROM notes");
	$n = 0;
	
	while($row = $db->getRow($result))
	{
		$has_audio = file_exists("../mp3s/".$row['id'].".mp3")?1:0;
		
		$update_sql  = "UPDATE notes SET has_audio='".$has_audio."' ";
		$update_sql .= "WHERE id='".$row['id']."'";
		
		if(mysql_query($update_sql))
		{
			echo "Note ".$row['id'].", has audio = ".$has_audio."<br/>";
		}
		
		if($has_audio) $n ++;
	}
	
	echo "<b>$n notes have audio</b>";
}

else
{
	echo "<a href='update.php?action=dimensions'>Update dimensions</a><br/>";
	echo "<a href='update.php?action=audio'>Update audio</a>";
}
?>