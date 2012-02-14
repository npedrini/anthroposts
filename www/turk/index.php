<?
require_once "../includes/classes/database.class.php";
require_once "../includes/classes/form.class.php";
require_once "../includes/classes/note.class.php";

session_start();
$db = new Database( "db13310_notes" );

?>
<html>
<head>
<title>AnthroPosts - Mechanical Turk</title>
<style>
body {
	font-family:arial,sans-serif;
}

h3 {
	color: #333333;
	display: block;
	padding: 5px;
	margin-bottom: 10px;
}

#list {
	margin-top: 20px;
}

.note {
	border: solid 1px #CCC;
	background-color: #EFEFEF;
	padding: 5px;
	margin-bottom: 10px;
	font-size: small;
}

#note_content {
	font-family: Georgia, serif;
	font-size: medium;
	color: #333;
	padding: 10px;
	margin: 20px;
}

li {
	margin-bottom: 5px;
	clear:both;
}

.unavailable {
	font-weight: bold;
	font-size: small;
	color: #CCCCCC;
}

a:link,a:visited,a:hover {
	text-decoration:none;
	font-weight: bold;
}
a:link,a:visited{
	color: #333333;
}
a:hover {
	color: #00FF00;
}

</style>
</head>

<body>
<h1>AnthroPosts - Mechanical Turk</h1>
<?
$step_id = isset($_REQUEST['step_id'])?$_REQUEST['step_id']:1;

/*
if(isset($_SESSION['sex']))
	$step_id = 1;
*/

/*
$fields = 
		array(
			array(
				array("type"=>"hidden","name"=>"step_id","value"=>$step_id),
				array("type"=>"radio","name"=>"sex","onchange"=>"this.form.submit();","data"=>
						array(
							array("value"=>"m","label"=>"male"),
							array("value"=>"f","label"=>"female")
						)
				)
			)
		);
*/

if(isset($fields[$step_id]))
{
	$form = new Form();
	$form->fields = $fields[$step_id];
	echo $form->buildForm();
}

//	see if user at this IP has an item checked out
$sql = "SELECT * FROM turk_activity WHERE last_checkout_ip='".$_SERVER['REMOTE_ADDR']."'";
$result = $db->query($sql);
if($db->getNumRows($result)>=1)
{
	$row = $db->getRow($result);
	$step_id = 3;
	$_GET['id'] = $row['note_id'];
}

if($step_id==1)
{
	echo "<h2>Please select a note to read from the list below. Once you've found one, click on it to check it out:</br>(NOTE: items in grey have already been completed or are currently checked-out by other workers. Please, do not read these or you will not be paid. Thank you.)</h2>";
	
	/*
	$timeout_hours = 3;
	$timeout_ms = $timeout_hours * 60 * 60 * 1000;
	*/
	
	$sql  = "SELECT * FROM `notes` AS n ";
	$sql .= "LEFT JOIN `turk_activity` AS t ON t.note_id=n.id ";
	$sql .= "WHERE n.content<>'' ";
	$sql .= "AND image_full IS NOT NULL ";
	$sql .= "AND content_addtl<>'?' ORDER BY n.created_date DESC";
	//$sql .= "LIMIT 0,50";
	
	$result = $db->query($sql);
	
	echo "<ol id='list'>";
	while($row = $db->getRow($result))
	{
		$title = str_replace("\n"," \ ",$row['content']);
		echo "<li>";
		
		if($row['checked_out']=="1" || file_exists("../mp3s/".$row['id'].".mp3"))
			echo "<span class='unavailable'>".$title."</span>";
		else
			echo "<a href='index.php?id=".$row['id']."&step_id=2'>".str_replace("\n"," \ ",$row['content'])."</a>";
		
		if( file_exists("../mp3s/".$row['id'].".mp3") )
		{
			echo "<a href='../mp3s/".$row['id'].".mp3'>mp3</a>";
		}
		
		echo "</li>";
	}
	echo "</ol>";
}
else if($step_id==2)
{
	if(isset($_GET['id']))
	{
		$note = new Note($_GET['id']);
		
		echo "The note you have selected reads as follows:";
		echo "<div id='note_content'>".nl2br($note->fields['content'])."</div>";
		echo "If you are sure you want to read this note, click <a href='index.php?id=".$note->id."&step_id=3'>confirm</a> to check it out</h2>";
		
		/*
		echo "<div class='note'>";
		echo "Notes on reading:";
		echo "<ul>";
		echo "<li>Forward slashes (/) represent line breaks; please take a slight pause when you encounter them</li>";
		echo "</ul>";
		echo "</div>";
		*/
	}
	else 
	{
		//ERROR
	}
}
else if($step_id==3)
{
	if(isset($_GET['id']))
	{
		$sql = "SELECT * FROM turk_activity WHERE note_id='".$_GET['id']."'";
		$exists = $db->query($sql);
		if($db->getNumRows($exists))
		{
			$sql  = "UPDATE turk_activity SET checked_out='1',last_checkout_time = '".time()."',last_checkout_ip = '".$_SERVER['REMOTE_ADDR']."' ";
			$sql .= "WHERE note_id = ".$_GET['id'];
		}
		else
		{
			$sql  = "INSERT INTO turk_activity (checked_out,note_id,last_checkout_time,last_checkout_ip) ";
			$sql .= "VALUES (1,'".$_GET['id']."','".time()."','".$_SERVER['REMOTE_ADDR']."')";
		}
		//echo $sql;
		
		if($db->query($sql))
		{
			$note = new Note($_GET['id']);
		
			echo "You have successfully checked out the following note:";
			echo "<div id='note_content'>".nl2br($note->fields['content'])."</div>";
			echo "Please record yourself recording this note as instructed to complete the task.<br/>Thank you for participating in this project!";
			
			/*
			echo "<div class='note'>";
			echo "Notes on reading:";
			echo "<ul>";
			echo "<li>Forward slashes (/) represent line breaks; please take a slight pause when you encounter them</li>";
			echo "</ul>";
			echo "</div>";
			*/
		
		}
		else
		{
			//ERROR
		}
	}	
}

/*
echo "<pre>";
print_r($_SESSION);
print_r($_POST);
echo "</pre>";
*/
?>
</body>
</html>