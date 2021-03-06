<?php

require_once "/home/13310/domains/anthroposts.com/html/includes/classes/database.class.php";

class Location
{
	function Location($id=null)
	{
	    $this->db=new Database( "db13310_notes" );
		$this->id=$id;
		$this->fields = array(
			"city"=>null,
			"state"=>null,
			"country"=>null
		);
		
		if(!is_null($id))
		{
			$this->id=$id;
			$this->load();
		}

	}	
		
	function load()
	{
		$sql="SELECT * FROM location WHERE id='".$this->id."'";
			
		$result=$this->db->query($sql);
		$row=$this->db->getRow($result);
		
		$result=$this->db->query($sql);
		$row=$this->db->getRow($result);
		
		foreach($row as $field=>$val){
			$this->fields[$field] = $val;
		}
		
	}
		
	function save()
	{
		if(!is_null($this->id))
			{
				$sql="UPDATE location SET ";
				$updates = array();
				
				foreach($this->fields as $field=>$val){
					$updates[] = $field."='".$this->db->escape($val)."'";
				}
				
				$sql .= implode($updates,",")." ";
				$sql .= "WHERE id='".$this->db->escape($this->id)."'";
				
				return $this->db->query($sql);
			}
			else
			{
				$sql="INSERT INTO location ";
				$fields=array();
				$values=array();
				
				foreach($this->fields as $field=>$val){
					$fields[]=$field;
					$values[]="'".$this->db->escape($val)."'";
				}
				$sql .= "(".implode($fields,",").") ";
				$sql .= "VALUES (".implode($values,",").")";
				
				$success=$this->db->query($sql);
				$this->id=mysql_insert_id();
				return $success;
			}
	}
		
	function delete()
	{
		
		if(!is_null($this->id))
		{
			//	delete record
			$sql="delete from location where id='".$this->db->escape($this->id)."'";
			return $this->db->query($sql);
		}
		else
		{
			return false;
		}
	}
	
	function getAllWhere($where=null,$order=null,$order_by=null){
        
        if(!is_null($this->db)){
            $db=$this->db;
        }else{
            $db=new Database( "db13310_notes" );
        }
        $sql="SELECT * FROM location ";
        
        if(!is_null($where)){
        	$where_clauses = array();
        	foreach($where as $field=>$val){
        		if(is_null($val))
        	 		$where_clauses[] = $field." IS NULL";
        	 	else
        	 		$where_clauses[] = $field."='".$val."'";
        	}
        	
        	if(count($where_clauses)>0){
        		$sql .= "WHERE ".implode($where_clauses,",")." ";
        	}
        }
        
        if(!is_null($order)){
			$sql .= "ORDER BY ".$order." ";
			$sql .= !is_null($order_by) ? $order_by : "ASC";
		}
		
		//echo $sql;
		
		$result=$db->query($sql);
		$categories=array();
		
		while($row=$db->getRow($result)){
			$categories[]=array("id"=>$row['id'],"title"=>$row['title']);
		}
		return $categories;
    }
    
    function getAll($order=null,$order_by=null){
        
        if(!is_null($this->db)){
            $db=$this->db;
        }else{
            $db=new Database( "db13310_notes" );
        }
        $sql="SELECT * FROM location ";
        if(!is_null($order)){
			$sql .= "ORDER BY ".$order." ";
			$sql .= !is_null($order_by) ? $order_by : "ASC";
		}
		$result=$db->query($sql);
		$categories=array();
		
		while($row=$db->getRow($result)){
			$categories[]=array("id"=>$row['id'],"title"=>$row['city']." (".(!is_null($row['state']) ? $row['state'] : $row['country']).")");
		}
		return $categories;
    }
    
    function getSelect(){
		$results  = Location::getAll("city");
        foreach($results as $row){
	        $temp[]=array("value" => $row['id'], "label" => stripslashes($row['title']));
        }
        return $temp;
	}
    
}
?>
