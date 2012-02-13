<?
//$show_nav=false;
include "includes/header.php"; 
?>
<?
$sql = "SELECT DISTINCT(location_id) FROM notes";
$result = $db->query($sql);
$cities = $db->getNumRows($result);

$sql = "SELECT DISTINCT(country) FROM location";
$result = $db->query($sql);
$countries = $db->getNumRows($result);

$sql = "SELECT id FROM notes";
$result = $db->query($sql);
$notes = $db->getNumRows($result);

?>

<div id='section_descrip'>
	<div>An interactive installation featuring found sticky notes collected from the street and read by anonymous online workers.</div>
	
	<div class='small' style="margin-top:20px;"><sup>*</sup> <?=$notes?> notes from <?=$cities?> cities and <? printf(ngettext("%d country","%d countries",$countries),$countries)?></div>
	
	<div style="text-align:right;margin-top:10px;"><img src="images/list_arrow.gif"><a href='view/Notes.php?locale=es_ES'>Disponible en español</a></div>
</div>

<? 
//include "includes/footer.php"; 
?>