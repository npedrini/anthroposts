<?
require_once "../includes/classes/database.class.php";
require_once "../includes/classes/form.class.php";
require_once "../includes/classes/note.class.php";

$db = new Database( "db13310_notes" );

?>
<html>
<head>
<title>AnthroPosts</title>
<style>
body {
	font-family:arial,sans-serif;
	font-size: x-small;
}

h3 {
	color: #333333;
	display: block;
	padding: 5px;
	margin-bottom: 10px;
}

li {
	margin-bottom: 5px;
	clear:both;
}

a:link,a:visited,a:hover {
	text-decoration:none;
	font-size: small;
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

$sql  = "SELECT * FROM `notes` AS n ";

$result = $db->query($sql);

echo "<ol id='list'>";
while($row = $db->getRow($result))
{
	$title = str_replace("\n"," \ ",$row['content']);
	
	$mp3 = "../mp3s/".$row['id'].".mp3";
	if(file_exists($mp3))
	{
		echo "<li>";
		echo "<a href='../admin/index.php?id=".$row['id']."' target='_blank'>".$title."</a>";
		echo "<div>";
		echo '<object width="160" height="20" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">';
		echo '<param name="src" value="'.$mp3.'">';
		echo '<param name="autoplay" value="false">';
		echo '<param name="controller" value="true">';
		echo '<embed src="'.$mp3.'" width="160" height="20" autoplay="false" controller="true" pluginspage="http://www.apple.com/quicktime/download/"></embed>';
		echo '</object>';
		echo "</div>";
		echo "</li>";
	}
}
echo "</ol>";

?>
</body>
</html>