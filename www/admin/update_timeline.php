<?

require_once '../includes/classes/database.class.php';
$db = new Database( "db13310_notes" );

$sql =  "SELECT * FROM notes AS n, location AS l ";
$sql .= "WHERE n.location_id = l.id ";
$sql .= "ORDER BY n.found_date DESC";

$results = $db->query($sql);

$html = '';

while($row = $db->getRow($results))
{
	$ts = strtotime($row['found_date']);
	
	$date_parts = split(" ",$row['found_date']);
	if($date_parts[0]!="0000-00-00")
	{
		if(is_null($year) || $year!=date("Y",$ts))
		{
			if(!is_null($year)) {
				// close 'note_content'
				$html .= "</div>";
				$html .= "<div class='note_footer'></div>";
				//	close 'note'
				$html .= "</div>";
			}
			
			$year = date("Y",$ts);
			$state = null;
			$country = null;
			
			$html .= "<div class='note'>";
			$html .= "<div class='note_header'>Notes found in <b>$year</b>:</div>";
			$html .= "<div class='note_content'>";
		}
		
		if(is_null($city) || $city!=$row['city'] || $state!=$row['state'] || $country!=$row['country'])
		{
			$city = $row['city'];
			$state = $row['state'];
			$country = $row['country'];
			
			$html .= "<span class='state'>";
			$html .= $row['city'];
			$html .= !is_null($state)?", ".$state:null;
			$html .= is_null($state) && !is_null($country)?", ".$country:null;
			$html .= "</span>";
		}
		
		$loc =  !is_null($row['found_street_no']) && !empty($row['found_street_no'])?$row['found_street_no']:"";
		$loc .= !is_null($row['found_street']) && !empty($row['found_street'])?" ".$row['found_street']:null;
		$loc .= !empty($loc) ? ", ":null;
		$loc .= !is_null($row['city']) && !empty($row['city'])?$row['city']:null;
		
		$map_url = $loc;
		$map_url .= !is_null($row['state']) && !empty($row['state'])?" ".$row['state']:null;
		
		$loc .= !is_null($row['found_street_2']) && !empty($row['found_street_2'])?" (".$row['found_street_2'].")":null;
		
		$date_parts = split("-",$date_parts[0]);
		$month_known = $date_parts[1]!="00";
		
		$html .= "<li>";
		$html .= "<b>".($month_known?date("M, d",$ts):"month unknown")."</b> - ";
		$html .= $month_known?"<a href='http://maps.google.com/maps?q=".urlencode($map_url)."' target='_blank'>".$loc."</a>" : $loc;
		$html .= "</li>";
	}
}

$fh = fopen('/nfs/c01/h13/mnt/13310/domains/anthroposts.com/html/includes/timeline.html', 'w'); 
fwrite($fh, $html); 

?>