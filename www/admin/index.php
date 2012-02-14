<?
ini_set("memory_limit","16M");
require_once "../includes/classes/database.class.php";
require_once "../includes/classes/form.class.php";
require_once "../includes/classes/note.class.php";
require_once "../includes/classes/category.class.php";
require_once "../includes/classes/type.class.php";
require_once "../includes/classes/location.class.php";
?>
<html>
<head>
	<title></title>
<style>
body {
	font-family: Arial;
}
table, td {
	vertical-align:top;
}
form {
	font-size:x-small;
}
label {
	font-size: xx-small;
	font-weight: bold;
	margin-right: 5px;
	margin-bottom: 15px;
	color: #666666;
}
#error {
	border: solid 1px #FF0000;
	padding: 5px;
	margin-bottom: 10px;
	font-size: xx-small;
	color: #FF0000;
}
#success {
	border: solid 1px #666666;
	padding: 5px;
	margin-bottom: 10px;
	font-size: xx-small;
	color: #666666;
	float: left;
}
#form {
	clear:both;
}
.preview {
	padding-left: 20px;
}
</style>

<!--CSS file (default YUI Sam Skin) --> 
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.9.0/build/calendar/assets/skins/sam/calendar.css"> 
<!-- Dependencies --> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.9.0/build/yahoo-dom-event/yahoo-dom-event.js"></script> 
<!-- Source file --> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.9.0/build/calendar/calendar-min.js"></script>
<script type="text/javascript" src="../includes/js/calendar-mini-functions.js"></script>

</script> 

</head>

<body class="yui-skin-sam">
<?

$note_types = Type::getSelect();
$note_categories = Category::getSelect();

$note_sort_values = array
(
	array('label'=>'content','value'=>'content'),
	array('label'=>'created_date','value'=>'created_date')
);

$note_order_values = array
( 
	array('label'=>'ASC','value'=>'asc'), 
	array('label'=>'DESC','value'=>'desc')
);

$languages = array
( 
	array("value"=>"en","label"=>"English"), 
	array("value"=>"es","label"=>"Spanish") 
);
		
if($_GET['id'])
{
	$note = new Note($_GET['id']);
	$init_data = $note->fields;
	$init_data['id'] = $note->id;
	
}else{
	
	function stripslashes_recursive($var) {
		return (is_array($var) ? array_map('stripslashes_recursive', $var) : stripslashes($var));
	}

	if (get_magic_quotes_gpc())
		$_POST = stripslashes_recursive($_POST);
	
	if($_POST['submit'])
	{
		$init_data = $_POST;
	}
	else
	{
		$init_data['type_id'] = $note_types[4]['value'];
	}
}

/*
echo "<pre>";
print_r($init_data);
echo "</pre>";
*/

$note_sort = isset($_REQUEST['note_sort']) ? $_REQUEST['note_sort'] : $note_sort_values[0]['value'];
$note_order = isset($_REQUEST['note_order']) ? $_REQUEST['note_order'] : $note_order_values[0]['value'];

$locs = Location::getSelect();
$locs[] = array("value"=>"0","label"=>"unknown");

$fields = array(
	array('name'=>'id','type'=>'hidden','value'=>$init_data['id']),
	array('name'=>'note_sort','type'=>'hidden','value'=>$note_sort),
	array('name'=>'note_order','type'=>'hidden','value'=>$note_order),
	array('name'=>'type_id','type'=>'select','label'=>'Type','data'=>$note_types,'value'=>$init_data['type_id'],'required'=>true),
	array('name'=>'category_id','type'=>'select','label'=>'Category','data'=>$note_categories,'value'=>$init_data['category_id'],'required'=>true),
	array('name'=>'content','type'=>'textarea','label'=>'Content','value'=>$init_data['content']),
	array('name'=>'content_addtl','type'=>'textarea','label'=>'Content (additional)','value'=>$init_data['content_addtl']),
	array('name'=>'language','type'=>'radio','label'=>'Language','value'=>$init_data['language'],'data'=>$languages),
	array('name'=>'found_date','type'=>'datetime','label'=>'Found Date','value'=>$init_data['found_date']),
	array('name'=>'found_street_no','type'=>'text','label'=>'Found Street No.','value'=>$init_data['found_street_no']),
	array('name'=>'found_street','type'=>'text','label'=>'Found Street','value'=>$init_data['found_street']),
	array('name'=>'found_street_2','type'=>'text','label'=>'Found Street','value'=>$init_data['found_street_2']),
	array('name'=>'location_id','type'=>'select','label'=>'Location','data'=>$locs,'value'=>$init_data['location_id']),
	array('name'=>'is_favorite','type'=>'checkbox','label'=>'Favorite?','value'=>$init_data['is_favorite']),
	array('name'=>'complexity','type'=>'text','label'=>'Complexity','value'=>$init_data['complexity']),
	array('name'=>'reader_sex','type'=>'radio','label'=>'Sex of reader','value'=>$init_data['reader_sex'],
			'data'=>array(
						array("value"=>"","label"=>"Unknown"),
						array("value"=>"m","label"=>"Male"),
						array("value"=>"f","label"=>"Female")
						)
					),
	array('name'=>'rotation_offset','type'=>'text','label'=>'Rotation (offset)','value'=>$init_data['rotation_offset']),
	array('name'=>'image_full','type'=>'mediumblob','label'=>'Image'),
	array('name'=>'image_full_back','type'=>'mediumblob','label'=>'Image (back)'),
	array('name'=>'mp3','type'=>'mediumblob','label'=>'MP3'),
	array('name'=>'submit','type'=>'submit','value'=>'Submit','width'=>60)
);

//array('name'=>'color_hex','type'=>'text','label'=>'Color (hex)','value'=>$init_data['color_hex']),

$form = new Form();
$form->fields = $fields;

if( $_POST['submit'] )
{
	$incomplete_fields = $form->validate($fields,$_POST);
	
	if(!is_null($incomplete_fields) && count($incomplete_fields))
	{
		echo "<div id='error'>";
		echo "The following fields are incomplete:<br/>";
		echo "<ul>";
		foreach($incomplete_fields as $incomplete_field){
			echo "<li>".$incomplete_field['name']."</li>";
		}
		echo "</ul>";
		echo "</div>";
		
	}else{
		
		$note = new Note(!empty($_REQUEST['id'])?$_REQUEST['id']:null);
		foreach($_POST as $key=>$val)
		{
			$field = $form->getFieldDefByFieldName($key);
			
			if(array_key_exists($key,$note->fields) && ($field['type']!="blob" || $field['type']!="mediumblob"))
			{
				$note->fields[$key] = $val;
			}
		}
		
		if (isset($_FILES['image_full']))
        {
        	//	TODO:  set image_height & image_width
            $data = file_get_contents($_FILES['image_full']['tmp_name']);
            
            if(!empty($data))
            {
           	 	$image = imagecreatefromstring( $data );
				$note->fields['image_width']  = imagesx($image);
				$note->fields['image_height'] = imagesy($image);
            	$note->fields['image_full'] = mysql_real_escape_string($data);
            	
            	
				
            	$note->updateImageFull=true;
            }
        }
        
        if (isset($_FILES['image_full_back']))
        {
        	//	TODO:  set image_height & image_width
            $data = file_get_contents($_FILES['image_full_back']['tmp_name']);
            
            if(!empty($data))
            {
            	$note->fields['image_full_back'] = mysql_real_escape_string($data);
            	$note->updateImageFullBack=true;
            }
        }
        
       
        
        if (isset($_FILES['mp3']) && !empty($_FILES['mp3']))
        {
        	$data = file_get_contents($_FILES['mp3']['tmp_name']);
            if(!empty($data))
            {
            	if(move_uploaded_file($_FILES['mp3']['tmp_name'], "../mp3s/".$note->id.".mp3")){
            		$note->fields['has_audio'] = true;
            		echo "Audio file moved";
            	}else{
            		echo "There was a problem moving the file";
            	}	
            }
        }
        
        $note->save();
       	$fields[0]['value'] = $note->id;
        
        /*
        echo "<pre>";
        print_r($form->fields);
        echo "</pre>";
        */
        
		/*
		$init_data = $note->fields;
		$init_data['id'] = $note->id;
		echo "<div id='success'>";
		echo "Item added...";
		echo "</div>";
		*/
	}
}

$all_notes = Note::getSelect( $note_sort, $note_order );

echo "<div>";

$select_form = new Form();
$select_form->setMethod("get");
$select_form->fields = array(
						array('name'=>'id','type'=>'select','onchange'=>'this.form.submit();','width'=>'400px','data'=>$all_notes,'value'=>$note->id),
						array('name'=>'note_sort','type'=>'select','onchange'=>'this.form.submit();','width'=>'400px','data'=>$note_sort_values,'value'=>$note_sort),
						array('name'=>'note_order','type'=>'select','onchange'=>'this.form.submit();','width'=>'400px','data'=>$note_order_values,'value'=>$note_order)
						);
echo $select_form->buildForm(null,!is_null($note->id)?"<span style='margin-right: 10px'><a href='?'>Cancel</a></span>":null);
echo "</div>";

echo "<div id='form'>";
$form->fields = $fields;
$form->setEncType("multipart/form-data");
$form->setFormWrapper("table");
echo $form->buildForm();

$mp3 = "../mp3s/".$note->id.".mp3";
if(file_exists($mp3))
{
	echo "<div class='preview'>";
	echo '<object width="160" height="20" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">';
	echo '<param name="src" value="'.$mp3.'">';
	echo '<param name="autoplay" value="false">';
	echo '<param name="controller" value="true">';
	echo '<embed src="'.$mp3.'" width="160" height="20" autoplay="false" controller="true" pluginspage="http://www.apple.com/quicktime/download/"></embed>';
	echo '</object>';
	echo "</div>";
}

echo "<div class='preview'>";
if(!empty($note->fields['image_full']))
	echo "<img src='../image.php?id=".$note->id."' /><br/><br/>";
	
if(!empty($note->fields['image_full_back']))
	echo "<img src='../image.php?id=".$note->id."&field=image_full_back' />";
echo "</div>";

echo "</div>";

/*
echo "<pre>";
echo print_r($_POST);
echo "</pre>";
*/
?>
</body>

</html>