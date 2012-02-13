<style>
img { 
	margin: 10px;
	border: solid 1px #000000;
}

</style>
<?

require_once "../includes/classes/category.class.php";
require_once "../includes/classes/type.class.php";
require_once "../includes/classes/note.class.php";

$cats = Category::getSelect();
$types = Type::getSelect();

$id  = $_GET['id'];
$cid = $_GET['cid'];
$tid = $_GET['tid'];
$h = $_GET['h'];

if(is_null($h) || empty($h)) $h = 50;

if(!is_null($id) && !empty($id)){

echo "<img src='image.php?id=".$id."' />";
	
}else{

echo "<form>";
echo "<select name='cid' onchange='this.form.submit();'>";
echo "<option value=''>-----</option>";

foreach($cats as $cat){
	echo "<option value='".$cat['value']."' ".($cid == $cat['value'] ? 'selected' : '').">".$cat['label']."</option>";
}
echo "</select>";

echo "&nbsp;&nbsp;<select name='tid' onchange='this.form.submit();'>";
echo "<option value=''>-----</option>";

foreach($types as $type){
	echo "<option value='".$type['value']."' ".($tid == $type['value'] ? 'selected' : '').">".$type['label']."</option>";
}
echo "</select>";

echo "</form>";

echo "
	<div>
		<a href='browse.php?cid=".$cid."&tid=".$tid."&h=25'>small</a> | 
		<a href='browse.php?cid=".$cid."&tid=".$tid."&h=50'>med</a> |
		<a href='browse.php?cid=".$cid."&tid=".$tid."&h=75'>large</a>
	</div>";

$where = array();
if(!is_null($cid) && !empty($cid)){
	$category = new Category($cid);
	$where["category_id"] = $cid;
}

if(!is_null($tid) && !empty($tid)){
	$where["type_id"] = $tid;
}

$all_notes = Note::getAll( $where );


foreach($all_notes as $note){
	echo "
		<div style='float:left;'>
			<a href='index.php?id=".$note['id']."'>
				<img border='0' src='../image.php?id=".$note['id']."&h=".$h."' />
			</a>
			<br/><span style='font-size:9px'>".nl2br($note['content'])."</span>
		</div>";
}

}
?>