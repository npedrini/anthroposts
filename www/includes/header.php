<?
require_once 'includes/classes/database.class.php';
$db = new Database( "db13310_notes" );

$url = parse_url($_SERVER['REQUEST_URI']);
$cur_page = substr($url["path"],1,strlen($url['path']));
?>
<html>
<head>
<title>AnthroPosts</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="description" content="An interactive installation featuring found sticky notes collected from the street and read by anonymous online workers." />
<meta name="keywords" content="digital art, found art, post-it art, interactive art, mechanical turk art, crowd-sourcing, crowd-sourced art, visualization, flash visualization, interactive visualization, noah pedrini, noah paul pedrini" />
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
	var pageTracker = _gat._getTracker("UA-441093-3");
	pageTracker._trackPageview();
} catch(err) {}
</script>
<link rel="stylesheet" type="text/css" href="styles.css" />
</head>

<body>
<div id="centered_outer">
	<div id="centered_middle">
		<div id="centered_inner">
			<div id="logo">
				<? echo $cur_page!="index.php" && !empty($cur_page)?
					"<a href='index.php'><img src='images/logo_splash.png' border='0'/></a>":
					"<img src='images/logo_splash.png' border='0'/>";?>
			</div>
			<?
			if(!isset($show_nav) || $show_nav==true) 
			{
				$link_defs = array("View"=>"view/","About"=>"about.php","Timeline"=>"timeline.php","Press"=>"press.php","Comments"=>"comments.php");
				$links = array();
				
				foreach($link_defs as $label=>$href)
					$links[] = $href!=$cur_page?"<a href='$href'>$label</a>":$label;
					
				echo "<div id='nav'>".join($links," / ")."</div>";
			}
			?>