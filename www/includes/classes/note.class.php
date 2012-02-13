<?php

require_once "/home/13310/domains/anthroposts.com/html/includes/classes/database.class.php";

class Note
{
	/*
	public static $DB_NAME = "db13310_notes";
	public static $TABLE_NAME = "notes";
	*/
	
	function Note($id=null)
	{
		$this->db = new Database( "db13310_notes" );
		
		$this->id = $id;
		$this->fields = array(
			'category_id'=>null,
			'type_id'=>null,
			'location_id'=>null,
			'content'=>null,
			'content_addtl'=>null,
			'language'=>null,
			'found_date'=>null,
			'found_street'=>null,
			'found_street_2'=>null,
			'found_street_no'=>null,
			'image_width'=>null,
			'image_height'=>null,
			'image_full'=>null,
			'image_full_back'=>null,
			'is_favorite'=>null,
			'rotation_offset'=>null,
			'created_date'=>null,
			'complexity'=>null,
			'modified_date'=>null,
			'has_audio'=>null);
		
		$this->updateImageFull=false;
		$this->updateImageFullBack=false;
		if(!is_null($id))
		{
			$this->load();
		}

	}	
	
	function load()
	{
		$sql="SELECT * FROM notes WHERE id='".$this->id."'";
		$result=$this->db->query($sql);
		$row=$this->db->getRow($result);
		
		foreach($this->fields as $field=>$val){
			$this->fields[$field] = $this->db->unescape($row[$field]);
		}
		
	}
	
	function save()
	{			
		if(!is_null($this->id))
		{
			$sql="UPDATE notes SET ";
			$updates = array();
			$this->fields['modified_date'] = date('Y-m-d H:i:s',time());
			
			foreach($this->fields as $field=>$val){
				if($field!="image_full" && $field!="image_full_back")
					$updates[] = $field."='".$this->db->escape($val)."'";
			}
			
			if($this->updateImageFull)
			{
				$updates[] = "image_full='".($this->fields['image_full'])."'";
				$this->updateImageFull=false;
			}
			if($this->updateImageFullBack)
			{
				$updates[] = "image_full_back='".($this->fields['image_full_back'])."'";
				$this->updateImageFullBack=false;
			}
			
			$sql .= implode($updates,",")." ";
			$sql .= "WHERE id='".$this->db->escape($this->id)."'";
			
			return $this->db->query($sql);
		}
		else
		{
			$sql="INSERT INTO notes ";
			$fields=array();
			$values=array();
			
			$this->fields['created_date'] = date('Y-m-d H:i:s',time());
			
			foreach($this->fields as $field=>$val){
				if($field!="image_full" && $field!="image_full_back")
				{
					$fields[] = $field;
					$values[] = "'".$this->db->escape($val)."'";
				}
			}
			
			if($this->updateImageFull)
			{
				$fields[] = "image_full";
				$values[] = "'".$this->fields['image_full']."'";
			}
			
			if($this->updateImageFullBack)
			{
				$fields[] = "image_full_back";
				$values[] = "'".$this->fields['image_full_back']."'";
			}
			
			$sql .= "(".implode($fields,",").") ";
			$sql .= "VALUES (".implode($values,",").")";
			
			$success=$this->db->query($sql);
			
			$this->id = mysql_insert_id();
			
			return $success;
		}
	}
	
	function delete()
	{
		if(!is_null($this->id)){
			//	delete record
			$sql="delete from notes where id='".$this->id."'";
			if($this->db->query($sql)){
				return true;
			}
		}
		return false;
	}
	
	function validate(){
	
	}
		
	function getAll($where=null,$order=null,$order_by=null){
		
		if(!is_null($this->db)){
			$db=$this->db;
		}else{
			$db = new Database( "db13310_notes" );
		}
		$sql  = "SELECT id,found_date,content FROM notes ";
		
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
		$results = array();
		
		while($row = $db->getRow($query)){
			$results[] = $row;
		}
		
		return $results;
	}
	
	function getSelect( $sort = "content", $order = "ASC" ){
		$results  = Note::getAll(null,$sort,$order);
		$temp=array(array("label" => "Edit item"));
		foreach($results as $row){
			$temp[]=array("value" => $row['id'], "label" => str_replace("\n"," /",stripslashes($row['content'])) );
		}
		return $temp;
	}
	
}
?>