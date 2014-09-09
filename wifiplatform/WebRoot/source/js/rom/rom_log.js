//搜索
function search(){
var planname = $("#searchbyname").val();
var start_time = $("#start_time").val();
var end_time = $("#end_time").val();
	$.ajax({
		type : "POST",
		dataType : "json",	
		url : "upGrade!queryByName",
		data : "planname=" + planname+"&start_time="+start_time+"&end_time="+end_time,
		success : function(json) {
			pageNum = 0;
			scrollTop = 0;
			$("#up_div").scrollTop(0);
			var htmlStr = "";
			htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
			htmlStr += " <tr style='background:#d4e1ee;'>";
			htmlStr += " <td width='15%'><div align='center'>计划名称</div></td>";
			htmlStr += " <td width='20%'><div align='center'>实际执行时间</div></td>";
			//htmlStr += " <td width='15%'><div align='center'>旧版本名称</div></td>";
			//htmlStr += " <td width='15%'><div align='center'>新版本名称</div></td>";
			htmlStr += " <td width='15%'><div align='center'>成功数</div></td>";
			htmlStr += " <td width='15%'><div align='center'>失败数</div></td>";
			htmlStr += "</tr>";
			for ( var i = 0; i < json.length; i++) {
				htmlStr += "<tr>";
				htmlStr += "<td width='11%'><div align='center' title='"+json[i].planname+"'>"
						+ (json[i].planname == null ? "" :(json[i].planname.length > 10 ?
								(json[i].planname.substring(0,10)+"..."):json[i].planname))
						+ "</div></td>";
				htmlStr += "<td width='20%'><div align='center'>"
						+ json[i].realtime
						+ "</div></td>";
				htmlStr += "<td width='5%'><div align='center'><span id='span_01_"+json[i].planid+"'>"
						+ (json[i].success_time == null?"":json[i].success_time)
						+ "</span></div></td>";
				htmlStr += "<td width='5%'><div align='center'><span id='span_02_"+json[i].planid+"'>"
						+ json[i].fail_time
						+ "</span>" +
						"<a href='javascript:open_upgrade_log_window("+json[i].planid+");'>【查看详细】</a></div></td>";
				htmlStr += "</tr>";
			}
			htmlStr += "</table>";
			$("#data_table").html(htmlStr);
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '${ctx}/denglu.jsp';
		}
	});
};
//选中所有
function checkAll(){
	var table = document.getElementById("upgrade_ap_log_table");
	var rows = table.rows;
	var all = rows[0].cells[0].getElementsByTagName("input")[0];
	for ( var i = 1; i < rows.length; i++) {
		var row = rows[i];
		//复选框
		var checkbox = row.cells[0].getElementsByTagName("input")[0];
		if(all.checked && !checkbox.disabled){
			checkbox.checked = 'checked';
		}else{
			checkbox.checked = '';
		}
		
	}
}
//弹出详细的AP执行失败原因
function open_upgrade_log_window(id){
	openLoadDataGif();
	//查询失败原因
	$.post("upGrade!queryUpgradeApLog.do","id="+id,function(data){
		closeLoadDataGif();
		var json = eval(data);
		$("#plan_id").val(id);
		$("#upgrade_ap_log_table").empty();
		$("#upgrade_ap_log_table").append("<tr style='background:#d4e1ee;'>" +
				"<td width='5%'><div align='center'><input type='checkbox' onclick='checkAll()'/></div></td>"+
				"<td width='15%'><div align='center'>AP名称</div></td>"+
				"<td width='20%'><div align='center'>MAC</div></td>"+
				"<td width='20%'><div align='center'>商家</div></td>"+
				"<td width='20%'><div align='center'>区域</div></td>"+
				"<td width='10%'><div align='center'>执行结果</div></td>"+
				"<td width='10%'><div align='center'>执行状态</div></td>"+
				"</tr>");
		for ( var i = 0; i < json.length; i++) {
			//成功执行的计划不能够再次执行
			var d = json[i].issuccess == 1 ? "disabled='disabled'" : '';
			$("#upgrade_ap_log_table").append("<tr>" +
					"<td><div align='center'><input type='checkbox' "+d+"/></div></td>"+
					"<td><div align='center'>" +json[i].apname+"</div></td>"+
					"<td><div align='center'>" +json[i].mac+"</div></td>"+
					"<td><div align='center' title='"+json[i].contacts+"'>" +(json[i].contacts.length > 7 ? json[i].contacts.substring(0,7)+"...":json[i].contacts)+"</div></td>"+
					"<td><div align='center'>" +json[i].pname+json[i].cname+json[i].dname+"</div></td>"+
					"<td><div align='center' title='"+json[i].execute_result+"'>" +(json[i].execute_result.length > 10 ? json[i].execute_result.substring(0,10)+"...":json[i].execute_result)+"</div></td>"+
					"<td><div align='center' id='"+json[i].mac+"'>" +(json[i].issuccess == 0?"失败":"成功")+"</div></td>"+
					"</tr>");
		}
		$("#upgrade_log_window").window("open");
	},"json");
}
//重新执行
function rexecutePlan(){
	var table = document.getElementById("upgrade_ap_log_table");
	var rows = table.rows;
	var id = $("#plan_id").val();
	var macs = "";
	for ( var i = 0; i < rows.length; i++) {
		var row = rows[i];
		//复选框
		var checkbox = row.cells[0].getElementsByTagName("input")[0];
		var status = row.cells[6].getElementsByTagName("div")[0].innerHTML;
		if(checkbox.checked){
			var mac = row.cells[2].getElementsByTagName("div")[0].innerHTML;
			if(macs == ""){
				macs = mac;
			}else{
				macs = macs+":"+mac;
			}
		}
	}
	$("#upgrade_log_window").window("close");
	openLoadDataGif();
	//后台重新执行
	$.post("upGrade!rexecuteUpgradePlan.do","macs="+macs+"&id="+id,function(data){
		var json = data;
		var success = json.success;
		var id = json.id;
		var su = $("#span_01_"+id).text();
		var fa = $("#span_02_"+id).text();
		var successMac = json.successMac;
		for ( var i = 0; i < successMac.length; i++) {
			$("#"+successMac[i]).html("成功");
		}
		if(su != ""){
			$("#span_01_"+id).text(parseInt(su)+success);
		}
		if(fa != ""){
			$("#span_02_"+id).text(parseInt(fa)-success);
		}
		closeLoadDataGif();
	},"JSON");
}
window.onload = function (){
	document.getElementById("background").style.width=document.body.offsetWidth+"px";
	document.getElementById("background").style.height=(document.body.offsetHeight+document.body.scrollHeight)+"px";
	document.getElementById("background").childNodes[1].style.top = "200px";
	document.getElementById("background").childNodes[1].style.left = (document.body.offsetWidth -90)/2+"px";
	document.getElementById("background").childNodes[1].style.visibility="hidden";
	document.getElementById("background").style.visibility="hidden";
};
function openLoadDataGif(){
	document.getElementById("background").childNodes[1].style.visibility="visible";
	document.getElementById("background").style.visibility="visible";
}

function closeLoadDataGif(){
	document.getElementById("background").childNodes[1].style.visibility="hidden";
	document.getElementById("background").style.visibility="hidden";
}
/**ESC退出*/
function esc(va){
	if(va == 27){
		$("#upgrade_log_window").window("close");
	}else if(va == 13){
		search();
	}
};