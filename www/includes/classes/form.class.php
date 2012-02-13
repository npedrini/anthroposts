<?php

class Form 
{
	
	function Form(){
		$this->form_name=null;
		$this->fields=null;
		$this->method='post';
		$this->action=$_SERVER['PHP_SELF'];
		$this->form_wrapper=null;
		$this->enc_type=null;
		$this->onsubmit_function=null;
	}
	
	function buildForm($form_pre_html=null,$form_post_html=null){
		
		$form_html="";
		if(!is_null($form_pre_html))$form_html.=$form_pre_html;
		
		$form_html="<form action='".$this->action."' method='".$this->method."'";
		!is_null($this->form_name) ? $form_html.=" name='".$this->form_name."'" : null;
		!is_null($this->enc_type) ? $form_html.=" enctype='".$this->enc_type."'" : null;
		!is_null($this->onsubmit_function) ? $form_html.=" onsubmit='".$this->onsubmit_function."();return false;'" : null;
		$form_html.=">";
		!is_null($this->form_wrapper) ? $form_html.="<".$this->form_wrapper.">" : null;
		
		for($i=0;$i<count($this->fields);$i++){
			
			$field_info=$this->fields[$i];
			$field_name=isset($field_info['name'])?$field_info['name']:null;
			$field_label=isset($field_info['label'])?$field_info['label']:null;
			$field_type=isset($field_info['type'])?$field_info['type']:"text";
			$field_value=isset($field_info['value'])?$field_info['value']:null;
			$field_max=isset($field_info['max'])?$field_info['max']:null;
			$field_required=isset($field_info['required']) && $field_info['required']==true;
			$field_onclick=isset($field_info['onclick'])?$field_info['onclick']:null;
			$field_value_delimiter=isset($field_info['value_delimiter'])?$field_info['value_delimiter']:" ";
			
			$pre_html=isset($field_info['pre_html'])?$field_info['pre_html']:null;
			$post_html=isset($field_info['post_html'])?$field_info['post_html']:null;
			
			if($field_required && $field_type!="hidden") $field_label .= " *";
			if(is_null($field_type)) $field_type = "text";
			
			$width=isset($field_info['width']) ? $field_info['width'] : 20;
			$height=isset($field_info['height']) ? $field_info['height'] : 10;
			
			$form_html.=$this->form_wrapper=="table" ? "<tr><td><label>$field_label</label></td><td>" : "<label>$field_label</label><br/>";
			$form_html.=" $pre_html";
			if($field_type=="text"){
				$form_html.="<input type='text' name='$field_name' value='$field_value' size='$width' height='$height'";
				$form_html.=!is_null($field_max)?" maxlength='$field_max'":"";
				$form_html.=">";
			}else if($field_type=="password"){
				$form_html.="<input type='password' name='$field_name' value='$field_value' size='$width'>";
			}else if($field_type=="textarea"){
				$form_html.="<textarea name='$field_name'  cols='$width' rows='$height'>$field_value</textarea>";
			}else if($field_type=="checkbox"){
				$form_html.="<input type='checkbox' name='$field_name' value='1' ".($field_value==1 ? 'checked' : null)." />";
			}else if($field_type=="select"){
				$form_html.=Form::buildSelect($field_info);
			}else if($field_type=="radio"){
				if(isset($field_info['data']))
				{
					$buttons = array();
					$field_data=$field_info['data'];
					if(count($field_data)>0){
						for($j=0;$j<count($field_data);$j++)
						{
							$radio = "<input type='radio' id='".$field_name.$j."' name='".$field_name."'";
							$radio .= " value='".$field_data[$j]["value"]."'".($field_value==$field_data[$j]["value"] ? " checked" : null);
							$radio .= isset($field_info['onchange']) ? " onchange='".$field_info['onchange']."'":null;
							$radio .= "><label for='".$field_name.$j."'>".$field_data[$j]["label"]."</label>";
							
							$buttons[] = $radio;
						}
						$form_html .= implode($buttons,$field_value_delimiter);
					}
				}
				/*
				else if(isset($field_info['data_start']) && isset($field_info['data_end']))
				{
					for($v=$field_info['data_start'];$v<=$field_info['data_end'];$v++)
					{
						$form_html.="<option value='".$v."' ".($field_value==$v ? "selected" : null).">".$v."</option>";
					}
				}
				*/
			}else if($field_type=="datetime"){
				$cal_id = $field_name."_select";
				$form_html .= "<input id='$field_name' type='text' name='$field_name' value='$field_value' onfocus='document.getElementById(\"".$cal_id."\").style.display=\"block\"' >";
				$form_html .= "<div id='".$cal_id."' style='float:none;display:none'></div>";
				$form_html .= "<script type='text/javascript'>initDatetimeSelect('".$cal_id."','".$field_value."');</script>";
			}else if($field_type=="blob" || $field_type=="mediumblob"){
				$form_html .= "<input type='file' name='$field_name'>";
				$form_html .= $field_html;
			}else if($field_type=="hidden"){
				$form_html.="<input type='hidden' name='$field_name' value='$field_value'>";
			}else if($field_type=="submit"){
				$form_html.="<input type='submit' name='$field_name' value='$field_value' style='width:".$width."px'";
				$form_html.=!is_null($field_onclick)?" onclick='".$field_onclick."'":'';
				$form_html.=">";
			}else if($field_type=="button"){
				$form_html.="<input type='button' name='$field_name' value='$field_value' style='width:".$width."px'";
				$form_html.=!is_null($field_onclick)?" onclick='".$field_onclick."'":'';
				$form_html.=">";
			}else if($field_type=="vspace"){
				$form_html .= "<hr with='100%' />";
			}
			
			$form_html.=" $post_html";
			$form_html.=$this->form_wrapper=="table" ? "</td></tr>" : "<br/>";
		}
		!is_null($this->form_wrapper) ? $form_html.="</".$this->form_wrapper.">" : null;
		
		if(!is_null($form_post_html))$form_html.=$form_post_html;
		$form_html.="</form>";
		return $form_html;
	}
	
	function buildSelect($field_info)
	{
		$form_html ="<select name='".$field_info['name']."'";
		if(isset($field_info['onchange']))
			$form_html.=" onchange='".$field_info['onchange']."'";
		
		if(isset($field_info['width']))
			$form_html.=" width='".$field_info['width']."' style='width:".$field_info['width']."'";
			
		$form_html.=">";
		
		if(isset($field_info['data']))
		{
			$field_data=$field_info['data'];
			if(count($field_data)>0){
				for($j=0;$j<count($field_data);$j++){
					$form_html.="<option value='".$field_data[$j]["value"]."' ".($field_info['value']==$field_data[$j]["value"] ? "selected" : null).">".$field_data[$j]["label"]."</option>";
				}
			}
		}
		else if(isset($field_info['data_start']) && isset($field_info['data_end']))
		{
			for($v=$field_info['data_start'];$v<=$field_info['data_end'];$v++)
			{
				$form_html.="<option value='".$v."' ".($field_value==$v ? "selected" : null).">".$v."</option>";
			}
		}
		$form_html.="</select>";
		return $form_html;
	}
	
	function validate($fields,$values)
	{
		$invalid_fields = array();
		
		foreach($values as $key=>$value)
		{
			$field_def = $this->getFieldDefByFieldName($key);
			
			if($field_def['required']==true && (empty($value) || is_null($value)))
				$invalid_fields[] = $field_def;
		}
		return $invalid_fields;
	}
	
	function getFieldDefByFieldName($field_name)
	{
		foreach($this->fields as $field_def)
		{
			if($field_def['name']==$field_name){
				return $field_def;
			}
		}
	}
	
	function getFields()
	{
		return $fields;	
	}
	function setFields($fields)
	{
		$this->fields=$fields;	
	}
	function setAction($x)
	{
		$this->action=$x;	
	}
	function setMethod($x)
	{
		$this->method=$x;	
	}
	function setFormWrapper($x)
	{
		$this->form_wrapper=$x;	
	}
	function setEncType($x)
	{
		$this->enc_type=$x;
	}
}
?>