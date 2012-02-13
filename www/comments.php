<?
require_once "includes/header.php";
require_once "includes/classes/form.class.php";
?>
<div id='section_descrip'>
What people are saying about the <b>AnthroPosts</b> project. For press, click <a href='/press.php'>here</a>.
</div>

<?

function stripslashes_recursive($var) {
	return (is_array($var) ? array_map('stripslashes_recursive', $var) : stripslashes($var));
}

$valid_request = false;
if(isset($_SERVER["HTTP_REFERER"]) && !empty($_SERVER["HTTP_REFERER"]))
{
	$referer = parse_url($_SERVER["HTTP_REFERER"]);
	$valid_request = $referer['host'] == "anthroposts.com" || $referer['host'] == "anthroposts.com";
}

if (get_magic_quotes_gpc())
	$_POST = stripslashes_recursive($_POST);

if(isset($_POST['submit']) && $valid_request)
{
	$name = $db->escape($_POST['name']);
	$email = $db->escape($_POST['email']);
	$comment = $db->escape($_POST['comment']);
	
	if(is_null($name) || empty($name)) $status = "Please enter your name";
	else if(is_null($comment) || empty($comment)) $status = "Please enter your comment";
	
	$spam_message = "Sorry, your comment was ignored. I appreciate your persistence, but please consider doing something more constructive with your time.";
	
	$banned_words = array('http','href','ralivia','phentermine','tramadol','meridia','adipex','xenical','ionamin','tenuate','viagra','levitra','penis','diet','buy online','hold-em','poker','dress','drug','porn','menopause');
	foreach($banned_words as $banned_word)
	{
		if(strpos(strtolower($comment),strtolower($banned_word))>-1)
		{
			$status = $spam_message;
			//mail("go@looklisten.net","AnthroPosts - Comment Spam Blocked","Spam detected:\n\n".$db->unescape($comment)."\n\n- The Magic Robot");
		}
	}
	
	$ip = $_SERVER['REMOTE_ADDR'];
	$banned_ips = array('91.201.66.76','89.212.33.235','66.119.41.133','77.243.99.112','93.157.169.18','91.224.160.4','91.224.160.4');
	
	foreach($banned_ips as $banned_ip)
	{
		if(strpos(strtolower($ip),strtolower($banned_ip))>-1)
		{
			$status = $spam_message;
		}
	}
	
	
	if(!isset($status))
	{
		$sql = "SELECT id FROM `comments` WHERE name='".$name."' AND comment='".$comment."'";
		$result = $db->query($sql);
		if($db->getNumRows($result)>=1)
		{
			$status = "This comment has already been added";
		}
		else
		{
			$sql = "INSERT INTO `comments` SET name='".$name."',email='".$email."',comment='".$comment."',date_created='".time()."',ip='".$ip."'";
			
			if($db->query($sql))
			{
				$status = "Your comment has been added. Thanks!";
				$_POST = array();
				//	send mail to admin
				$body = "The following comment has just been added to AnthroPosts by ".$db->unescape($name).":\n\n".$db->unescape($comment)."\n\n- The Magic Robot";
				mail("go@looklisten.net","AnthroPosts - New Comment",$body);
			}
			else
			{
				$status = "There was a problem adding your comment. Please try again later.";
			}
		}
	}
}

$fields = 
array(
	array(	'name'=>'name','label'=>'Name','width'=>45,'height'=>'22px',
			'value'=>isset($_POST['name']) ? $_POST['name'] : null,
			'required'=>true),
	array(	'name'=>'email','label'=>'Email','width'=>45,'height'=>'22px',
			'value'=>isset($_POST['email']) ? $_POST['email'] : null,
			'required'=>false),
	array(	'name'=>'comment','label'=>'Comment','type'=>'textarea','width'=>40,'height'=>5,
			'value'=>isset($_POST['comment']) ? $_POST['comment'] : null,
			'required'=>true,'min'=>4,'max'=>100),
	array(	'type'=>'submit','name'=>'submit','value'=>'Submit','width'=>60)
);

//	EXISTING COMMENTS
$sql = "SELECT * FROM `comments` ORDER BY date_created DESC";
$results = $db->query($sql);
while($row = $db->getRow($results))
{
	echo "<div class='note'>";
	echo "<div class='note_header'><b>".$db->unescape($row['name'])."</b> said:</div>";
	echo "<div class='note_content'>";
	echo "<span class='quote'>&ldquo;</span> ";
	echo nl2br($db->unescape($row['comment']));
	echo " <span class='quote'>&rdquo;</span>";
	echo "</div>";
	echo "<div class='note_footer'>- ".date("l, M d 'y",$row['date_created'])."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>";
	echo "</div>";
}

//	ADD COMMENT FORM
echo "<div id='note'>";

$form = new Form();
//$form->form_wrapper = "table";
$form->fields = $fields;

echo "<div class='note_header'>What do you think?</div>";

echo "<div class='note_content'>";
if(isset($status)) echo "<div><span id='form_status'>".$status."</span></div>";
echo $form->buildForm();
echo "</div>";

echo "<div class='note_footer'></div>";
echo "</div>";
?>
<? include "includes/footer.php" ?>