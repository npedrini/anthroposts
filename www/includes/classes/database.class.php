<?php
include "/nfs/c01/h13/mnt/13310/etc/db_connect.php";

class Database
{
	function Database( $db )
	{
		$this->hostname=DB_HOSTNAME;
		$this->username=DB_USERNAME;
		$this->password=DB_PASSWORD;
		$this->database=$db;
		
		mysql_connect($this->hostname,$this->username,$this->password);
		mysql_select_db($this->database);	
	}	
	
	function query($sql)
	{
		$result = mysql_query($sql);
		if(!$result){
			echo $sql;
		}
		return $result;
	}
	
	function getNumRows($result)
	{
		return $result ? mysql_num_rows($result) : 0;
	}
	
	function getRow($query)
	{
		return mysql_fetch_assoc($query);	
	}
	
	function setNumRows($x)
	{
		$this->num_rows=$x;
	}
	
	function escape($string)
	{
		return mysql_real_escape_string($string);
	}
	
	function unescape($string)
	{
		return stripslashes($string);
	}
}
?>