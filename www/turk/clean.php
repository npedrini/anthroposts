<style>body { font-family:sans-serif;font-size:small; }</style>
<?
error_reporting(E_ALL);
ini_set("display_errors", 1);

require_once "../includes/classes/database.class.php";
require_once "../includes/classes/form.class.php";
require_once "../includes/classes/note.class.php";

$db = new Database( "db13310_notes" );


//$timeout_ms = time() - (5 * 60 * 60 * 1000);
$timeout_ms = strtotime("-5 years");

//	delete rows that are over 5 hours old
$sql  = "DELETE FROM turk_activity ";
$sql .= "WHERE last_checkout_time < ".$timeout_ms." ";
$db->query($sql);

//	show remaining rows
$sql  = "SELECT note_id,last_checkout_time FROM turk_activity ";
$sql .= "WHERE last_checkout_time > ".$timeout_ms." ";
$sql .= "ORDER BY last_checkout_time DESC";
$result = $db->query($sql);

echo "<ol id='list'>";
while($row = $db->getRow($result))
{
	echo "<li>";
	echo date("h:i:s a, m/d/y T",$row['last_checkout_time'])." (".$row['last_checkout_time'].")";
	echo "</li>";
}
echo "</ol>";
?>