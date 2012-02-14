<?

require_once('/home/13310/domains/looklisten.net/html/soap/nusoap/lib/nusoap.php');
require_once '/home/13310/domains/anthroposts.com/html/includes/classes/database.class.php';

ini_set('memory_limit', '64M');

DEFINE("DEBUG",false);
DEFINE("MAX_RESULTS",50);
DEFINE("SITE_ROOT","/home/13310/domains/anthroposts.com");

$NAMESPACE = 'http://looklisten.net/notes/service.php?wsdl';

$server = new soap_server;
$server->configureWSDL('Notes', $NAMESPACE);
$server->wsdl->schemaTargetNamespace = $NAMESPACE;

$server->wsdl->addComplexType(
    'Note',
    'complexType',
    'struct',
    'all',
    '',
    array(
        'id' => array('name'=>'id','type'=>'xsd:int'),
        'category_id' => array('name'=>'category_id','type'=>'xsd:int'),
        'type_id' => array('name'=>'type_id','type'=>'xsd:int'),
        'location_id' => array('name'=>'location_id','type'=>'xsd:int'),
        'content' => array('name'=>'content','type'=>'xsd:string'),
        'content_addtl' => array('name'=>'content_addtl','type'=>'xsd:string'),
        'language' => array('name'=>'language','type'=>'xsd:string'),
        'found_date'=> array('name'=>'found_date','type'=>'xsd:string'),
		'found_street'=> array('name'=>'found_street','type'=>'xsd:string'),
		'found_street_2'=> array('name'=>'found_street_2','type'=>'xsd:string'),
		'found_street_no'=> array('name'=>'found_street_no','type'=>'xsd:string'),
		'image_width'=> array('name'=>'image_width','type'=>'xsd:int'),
		'image_height'=> array('name'=>'image_height','type'=>'xsd:int'),
		'is_favorite'=> array('name'=>'is_favorite','type'=>'xsd:int'),
		'rotation_offset'=> array('name'=>'rotation_offset','type'=>'xsd:int'),
		'created_date'=> array('name'=>'created_date','type'=>'xsd:string'),
		'modified_date'=> array('name'=>'modified_date','type'=>'xsd:string'),
		'color_hex'=> array('name'=>'color_hex','type'=>'xsd:int'),
		'has_audio'=> array('name'=>'has_audio','type'=>'xsd:int'),
		'complexity'=> array('name'=>'complexity','type'=>'xsd:int')
    )
);

$server->wsdl->addComplexType(
    'Category',
    'complexType',
    'struct',
    'all',
    '',
   	array(
        'id' => array('name'=>'id','type'=>'xsd:int'),
        'title' => array('name'=>'title','type'=>'xsd:string'),
        'parent_id' => array('name'=>'parent_id','type'=>'xsd:int'),
        'delimit' => array('name'=>'delimit','type'=>'xsd:int'),
        'num_children' => array('name'=>'children','type'=>'xsd:int')
    )
);

$server->wsdl->addComplexType(
    'Type',
    'complexType',
    'struct',
    'all',
    '',
    array(
        'id' => array('name'=>'id','type'=>'xsd:int'),
        'title' => array('name'=>'title','type'=>'xsd:string'),
        'width_inches' => array('name'=>'width_inches','type'=>'xsd:string'),
        'height_inches' => array('name'=>'height_inches','type'=>'xsd:string'),
        'parent_id' => array('name'=>'parent_id','type'=>'xsd:int'),
        'num_children' => array('name'=>'children','type'=>'xsd:int')
    )
);

$server->wsdl->addComplexType(
    'Location',
    'complexType',
    'struct',
    'all',
    '',
    array(
        'id' => array('name'=>'id','type'=>'xsd:int'),
        'city' => array('name'=>'title','type'=>'xsd:string'),
        'state' => array('name'=>'width_inches','type'=>'xsd:string'),
        'country' => array('name'=>'height_inches','type'=>'xsd:string')
    )
);

$server->wsdl->addComplexType(
    'NoteArray',
    'complexType',
    'array',
    '',
    'SOAP-ENC:Array',
    array(),
    array(
        array('ref'=>'SOAP-ENC:arrayType','wsdl:arrayType'=>'tns:Note[]')
    ),
    'tns:Note'
);

$server->wsdl->addComplexType(
    'CategoryArray',
    'complexType',
    'array',
    '',
    'SOAP-ENC:Array',
    array(),
    array(
        array('ref'=>'SOAP-ENC:arrayType','wsdl:arrayType'=>'tns:Category[]')
    ),
    'tns:Category'
);

$server->wsdl->addComplexType(
    'TypeArray',
    'complexType',
    'array',
    '',
    'SOAP-ENC:Array',
    array(),
    array(
        array('ref'=>'SOAP-ENC:arrayType','wsdl:arrayType'=>'tns:Type[]')
    ),
    'tns:Type'
);

$server->wsdl->addComplexType(
    'LocationArray',
    'complexType',
    'array',
    '',
    'SOAP-ENC:Array',
    array(),
    array(
        array('ref'=>'SOAP-ENC:arrayType','wsdl:arrayType'=>'tns:Location[]')
    ),
    'tns:Location'
);

$server->register(
    'getNotes',
    array('category_id'=>'xsd:int','type_id'=>'xsd:int','limit'=>'xsd:int'),
    array('return'=>'tns:NoteArray'),
    $NAMESPACE);

$server->register(
    'getCategories',
    array(),
    array('return'=>'tns:CategoryArray'),
    $NAMESPACE);

$server->register(
    'getTypes',
    array(),
    array('return'=>'tns:TypeArray'),
    $NAMESPACE);

$server->register(
    'getLocations',
    array(),
    array('return'=>'tns:LocationArray'),
    $NAMESPACE);

function getNotes($chapter_id,$type_id,$limit=0)
{
    $db = new Database( "db13310_notes" );
    
    $sql  = "SELECT id,category_id,location_id,content,content_addtl,language,";
    $sql .= "found_date,found_street,found_street_2,found_street_no,";
    $sql .= "image_width,image_height,is_favorite,rotation_offset,";
    $sql .= "created_date,modified_date,complexity,has_audio FROM notes ";
    
	if($limit>0) $sql .= "LIMIT 0,".$limit;
	
	$where = array();
	if(!is_null($chapter_id) && !empty($chapter_id)){
		$where["category_id"] = $chapter_id;
	}
	if(!is_null($type_id) && !empty($type_id)){
		$where["type_id"] = $type_id;
	}
	
	if(!is_null($where)){
		$where_clause = array();
		
		foreach($where as $field=>$val){
			$where_clause[]="(".$field."='".$val."') ";	
		}
		if(count($where_clause)>0){
			$sql .= "WHERE ".implode($where_clause," AND ");	
		}
	}
	
	if(!is_null($order)){
		$sql .= "ORDER BY ".$order." ";
		$sql .= !is_null($order_by) ? $order_by : "ASC";
	}
	
	$query = $db->query($sql);
	
	$items = array();
	
	while($row = $db->getRow($query))
	{
		$item = array
		(
			'id' => $row['id'],
			'category_id' => $row['category_id'],
			'type_id' => $row['type_id'],
			'location_id' => $row['location_id'],
			'content' => $row['content'],
			'content_addtl' => $row['content_addtl'],
			'language' => $row['language'],
			'found_date'=>  $row['found_date'],
			'found_street'=> $row['found_street'],
			'found_street_2'=> $row['found_street_2'],
			'found_street_no'=> $row['found_street_no'],
			'color_hex'=> $row['color_hex'],
			'image_width'=> $row['image_width'],
			'image_height'=> $row['image_height'],
			'is_favorite'=> $row['is_favorite'],
			'rotation_offset'=> $row['rotation_offset'],
			'created_date'=> $row['created_date'],
			'modified_date'=> $row['modified_date'],
			'color_hex'=> 0,
			'complexity'=> $row['complexity'],
			'has_audio'=> $row['has_audio']
		);
                 
        $items[] = $item;
	}
    
	return $items;
}
function getCategories()
{    
    $db = new Database( "db13310_notes" );
    $sql  = "SELECT id,title,parent_id FROM category ";
	
	$where = array();
	
	if(!is_null($where)){
		$where_clause = array();
		
		foreach($where as $field=>$val){
			$where_clause[]="(".$field."='".$val."') ";	
		}
		if(count($where_clause)>0){
			$sql .= "WHERE ".implode($where_clause," AND ");	
		}
	}
	
	if(is_null($order))
		$order = "title";
		
	if(!is_null($order)){
		$sql .= "ORDER BY ".$order." ";
		$sql .= !is_null($order_by) ? $order_by : "ASC";
	}
	
	$query = $db->query($sql);
	
	while($row = $db->getRow($query)){
		$sql  = "SELECT COUNT(id) AS `num` FROM notes WHERE category_id = '".$row['id']."'";
		$query2 = $db->query($sql);
		$row2 = $db->getRow($query2);
		$num_children = $row2['num'];
   	 	$item = array(
                 'id' => $row['id'],
                 'title' => $row['title'],
                 'parent_id' => $row['parent_id'],
                 'delimit' => $row['delimit'],
                 'num_children' => $num_children);
          
        $items[] = $item;
	}
    
    for($i=0;$i<count($items);$i++){
    	if($items[$i].parent_id>0){
    		for($j=0;$j<count($items);$j++){
    			if($items[$j]['id'] == $items[$i]['parent_id']){
    				$items[$i]['num_children'] += $items[$j]['num_children'];
    			}
    		}
    	}
    }
    
	return $items;
}
function getTypes()
{    
    $db = new Database( "db13310_notes" );
    $sql  = "SELECT id,title,width_inches,height_inches,parent_id FROM type ";
	
	$where = array();
	
	if(!is_null($where)){
		$where_clause = array();
		
		foreach($where as $field=>$val){
			$where_clause[]="(".$field."='".$val."') ";	
		}
		if(count($where_clause)>0){
			$sql .= "WHERE ".implode($where_clause," AND ");	
		}
	}
	
	if(is_null($order))
		$order = "title";
		
	if(!is_null($order)){
		$sql .= "ORDER BY ".$order." ";
		$sql .= !is_null($order_by) ? $order_by : "ASC";
	}
	
	$query = $db->query($sql);
	
	while($row = $db->getRow($query)){
   	 	$item = array(
                 'id' => $row['id'],
                 'title' => $row['title'],
                 'width_inches' => $row['width_inches'],
                 'title' => $row['title'],
                 'height_inches' => $row['height_inches']
                 );
        $items[] = $item;
	}
	return $items;
}

function getLocations()
{    
    $db = new Database( "db13310_notes" );
    $sql  = "SELECT * FROM location ";
	
	$where = array();
	
	if(!is_null($where)){
		$where_clause = array();
		
		foreach($where as $field=>$val){
			$where_clause[]="(".$field."='".$val."') ";	
		}
		if(count($where_clause)>0){
			$sql .= "WHERE ".implode($where_clause," AND ");	
		}
	}
	
	if(is_null($order))
		$order = "city";
	
	if(!is_null($order)){
		$sql .= "ORDER BY ".$order." ";
		$sql .= !is_null($order_by) ? $order_by : "ASC";
	}
	
	$query = $db->query($sql);
	
	while($row = $db->getRow($query)){
   	 	$item = array(
                 'id' => $row['id'],
                 'city' => $row['city'],
                 'state' => $row['state'],
                 'country' => $row['country']
                 );
        $items[] = $item;
	}
	return $items;
}

$HTTP_RAW_POST_DATA = isset($GLOBALS['HTTP_RAW_POST_DATA'])
                        ? $GLOBALS['HTTP_RAW_POST_DATA'] : '';
$server->service($HTTP_RAW_POST_DATA);
?>