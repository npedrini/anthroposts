function handleDateSelect(type,args,obj)
{
	var field = obj.id.substr(0,obj.id.indexOf('_select_t'));
	var dates = args[0];
	var date = dates[0];
	var year = date[0], month = date[1], day = date[2];
	
	var time = document.getElementById(field).value.split(" ")[1];
	if(time==undefined) time = "00:00:00";
	document.getElementById(field).value = year + "-" + month + "-" + day + ' ' + time;
	document.getElementById(obj.id).parentNode.style.display="none";
}

function initDatetimeSelect(divName,initValue)
{
	var cal1 = new YAHOO.widget.Calendar(divName);
	cal1.selectEvent.subscribe(handleDateSelect, cal1, true);
	cal1.render();
	
	if(initValue!="")
	{
		var date_parts = initValue.split(" ")[0].split("-");
		var date = date_parts[1]+"/"+date_parts[2]+"/"+date_parts[0];
		cal1.select(date);
		
		var selectedDates = cal1.getSelectedDates(); 
		if (selectedDates.length > 0) { 
			var firstDate = selectedDates[0]; 
			cal1.cfg.setProperty("pagedate", (firstDate.getMonth()+1) + "/" + firstDate.getFullYear()); 
			cal1.render(); 
		}
	}
	
}