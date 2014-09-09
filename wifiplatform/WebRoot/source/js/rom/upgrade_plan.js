/**弹出新增计划窗口*/
function openCreateWindow(){
	clearContent();
	$("#upgrade_plan_window").panel({title:"新增计划"});
	$("#upgrade_plan_window").window("open");
}
/**清空内容*/
function clearContent(){
	$("#plan_name").removeAttr("disabled");
	$("#err_msg").text("");
	$("#hidden_row_id").val();
	//清空左表格
	var tab = $("#ap_table_1");
	tab.empty();
	tab.append("<tr  style='background:#d4e2ef'>" +
			   "<td><input type='checkbox' id='check_input_all' onclick='checkAll(0)'/></td>" +
			   "<td>MAC</td>" +
			   "<td>区域</td>" +
            	"</tr>");
	$("#hidden_row_id").val("");
	//清空右表格
	tab = $("#ap_table_2");
	tab.empty();
	tab.append("<tr  style='background:#d4e2ef'>" +
			   "<td><input type='checkbox'/></td>" +
			   "<td>MAC</td>" +
			   "<td>区域</td>" +
            	"</tr>");
	//清空输入框
	$("#plan_name").val("");
	$("#plan_time").val("");
}
/**保存升级计划*/
function saveGradePlan(){
	//升级计划名称
	var plan_name = $("#plan_name").val();
	if(plan_name.replace(/\s+/g,'') == ''){
		$("#err_msg").text("计划名称不能为空");
		return;
	}
	var reg = new RegExp("^[a-zA-Z0-9_\u4E00-\u9FA5]{1,50}$");
	if(!reg.exec(plan_name)){
		$("#err_msg").text("计划名称格式错误【由1-50位字母、汉子、数字、下划线组成】");
		return;
	}
	//计划执行时间
	var plan_time = $("#plan_time").val();
	if(plan_time.replace(/\s+/g,'') == ''){
		$("#err_msg").text("计划执行时间不能为空");
		return;
	}
	//升级的AP(右边表的数据)
	var row = document.getElementById("ap_table_2").rows.length;
	var aps = "";
	var macs = "";
	var addrs = "";
	for(var i = 1;i<row;i++){
		var tr = document.getElementById("ap_table_2").rows[i];
		var id = tr.title;
		//当没有选中时，不让保存
		if(!tr.cells[0].getElementsByTagName("input")[0].checked){
			continue;
		}
		var mac = tr.cells[1].innerHTML;
		var addr = tr.cells[2].innerHTML;
		var pcode = tr.cells[0].getElementsByTagName("input")[2].value;
		if(aps == ""){
			aps = id+":"+mac+":"+pcode;
		}else{
			aps = aps+","+id+":"+mac+":"+pcode;
		}
		if(macs == ""){
			macs = mac;
		}else{
			macs = macs+":"+mac;
		}
		if(addrs == ""){
			addrs = addr;
		}else{
			addrs = addrs+":"+addr;
		}
	}
	if(macs == ""){
		$("#err_msg").text("AP选择不能为空");
		return;
	}
	var i_d = $("#hidden_row_id").val();
	if(i_d != ''){
		//保存编辑
		saveEdit(plan_time,aps,i_d,macs,plan_name,addrs);
		return;
	}
	$.post("upgrade!saveUpGradePlan.do",
			"plan_name="+plan_name+"&" +
			"plan_time="+plan_time+"&" +
			"ap=" +aps,
			function(res){
				var d = res.id;
				var l = document.getElementById("upgrade_table").rows.length;
				//表格追加一行
				if(d != '-1'){
					$("#upgrade_plan_window").window("close");
					var plname = plan_name.length > 10 ? plan_name.substring(0,10):plan_name;
					$("#upgrade_table").append("<tr ondblclick='editUpGradePlans("+d+",1,event)' id='editUpGradePlans_"+d+"'>"+
			                "<td align='center'><input type='checkbox' />" +
			                "<input type='hidden' value='"+d+"'/>" +
			                "<input type='hidden' value='1'/>" +
			                "<input type='hidden' value='0'/></td>" +
			                "<td align='center' title='"+plan_name+"'>"+plname+"</td>"+
			                "<td align='center'><a href='javascript:lookApMessage("+d+");'>查看</a></td>"+
			                "<td align='center'>"+plan_time+"</td>"+
			                "<td align='center'></td>"+
			                "<td align='center'><a href='#' onclick='verify("+d+",event,1)'>审核</a>(未审核)</td>"+
			                "<td align='center'>"+account_name+"</td>"+
			              "</tr>");
				}else{
					//保存失败
					alert("保存失败");
				}
			},"json");
}
/**保存编辑*/
function saveEdit(plan_time,aps,id,macs,plan_name,addrs){
	$.post("upgrade!saveEditUpGradePlan.do",
			"plan_time="+plan_time+"&" +
			"ap=" +aps+"&" +
			"id="+id,
			function(res){
				var d = res.id;
				var tr = document.getElementById("editUpGradePlans_"+id);
				tr.cells[1].innerHTML=""+plan_name+"";
				tr.cells[2].innerHTML="<a href='<a href='javascript:lookApMessage("+id+");'>'>查看</a>";
				tr.cells[3].innerHTML=plan_time;
				$("#upgrade_plan_window").window("close");
			},"json");
}
var bool = false;
/**编辑*/
function editUpGradePlans(id,isSelf,evt){
	//如果不是自己的计划不可以编辑
	if(isSelf != 1){
		return;
	}
	if(bool){
		return;
	}
	if(evt.target.parentNode.cells[0].getElementsByTagName("input")[3].value == '1'){
		//已审核的不能编辑
		return;
	}
	bool = true;
	/**查询到计划的AP信息*/
	$.post("upgrade!queryUpgradePlanApMessage.do",
			"id="+id,
			function(res){
			var json = $.parseJSON(res.toString());
			clearContent();
			json = eval(json);
			$("#hidden_row_id").val(id);
			$("#plan_name").attr("disabled","disabled");
			$("#upgrade_plan_window").panel({title:"编辑计划"});
			$("#upgrade_plan_window").window("open");
			var tr = document.getElementById("editUpGradePlans_"+id);
			var name = tr.cells[1].innerHTML;
			var time = tr.cells[3].innerHTML;
			$("#plan_name").val(name);
			$("#plan_time").val(time);
			var tab = $("#ap_table_2");
			for ( var i = 0; i < json.length; i++) {
				tab.append("<tr id='upgrade_window_tb_2_"+i+"' title='"+json[i].id+"'>" +
						   "<td><div align='center'><input type='checkbox' checked='true' id='check_input_2_"+i+"'/>" +
						   "<input type='hidden' id='upgrade_window_hidden_row_"+json[i].id+"' value='"+i+"'/>" +
						   "<input type='hidden' id='"+json[i].province+"_"+json[i].id+"' value='"+json[i].province+"'/></td>" +
						   "<td align='center'>"+json[i].mac+"</td>" +
						   "<td align='center'>"+json[i].cname+json[i].dname+"</td>" +
			      	"</tr>");
			}
			bool = false;
	});
}
/**选择所有列出的AP*/
function checkAll(num){
	if(document.getElementById("check_input_all").checked){
		for(var i = 0;i<num;i++){
			document.getElementById("check_input_"+i).checked = true;
			//将所有行的数据添加到右边
		}
		addAllToRight(num);
	}else{
		for(var i = 0;i<num;i++){
			document.getElementById("check_input_"+i).checked = false;
			//将所有行的数据添从右边去掉
		}
		removeRows(num);
	}
}
/**左边单行选择*/
function checkRow(row,evt){
	if(document.getElementById("check_input_"+row).checked){
		//检查是否全选
		if(isAllChecked()){
			document.getElementById("check_input_all").checked = true;
		}
		//右边单加一行
		addOneRowToRight(row);
	}else{
		//检查是否全未选
		document.getElementById("check_input_all").checked = false;
		//右边单删除一行
		removeOneRowFromRight(row,evt);
	}
}
/**检查左边表格内容行是否全选*/
function isAllChecked(){
	var row = document.getElementById("ap_table_1").rows.length;
	var bool = true;
	for(var i = 0;i < row;i++ ){
		if(document.getElementById("check_input_"+i)){
			if(!document.getElementById("check_input_"+i).checked){
				bool = false;
			}	
		}
	}
	return bool;
}
/**右边单删除一行*/
function removeOneRowFromRight(r,evt){
	var pcode = evt.target.parentNode.childNodes[2].value;
	var id = evt.target.parentNode.childNodes[1].value;
	$("#"+pcode+"_"+id).parent("div").parent("td").parent("tr").remove();
}
/**右边单加一行*/
function addOneRowToRight(r){
	var tab = $("#ap_table_2");
	var tr = document.getElementById("upgrade_window_tb_1_"+r);
	var id = $("#upgrade_window_hidden_1_"+r).val();
	var pcode = tr.cells[0].getElementsByTagName("input")[2].value;
	var mac = tr.cells[1].innerHTML;
	var district = tr.cells[2].innerHTML;
	var row = document.getElementById("ap_table_2").rows.length;
	tab.append("<tr id='upgrade_window_tb_2_"+row+"' title='"+id+"'>" +
			   "<td><div align='center'>" +
			   "<input type='checkbox' checked='true' id='check_input_2_"+row+"'/>" +
			   "<input type='hidden' id='upgrade_window_hidden_row_"+id+"' value='"+row+"'/>" +
			   "<input type='hidden' id='"+pcode+"_"+id+"' value='"+pcode+"'/></td>" +
			   "<td align='center'>"+mac+"</td>" +
			   "<td align='center'>"+district+"</td>" +
      	"</tr>");
}
/**删除所有左边未选中的*/
function removeRows(num){
	//根据左边内容，删除右边
	var tab = $("#ap_table_2");
	for(var i = 0;i<num;i++){
		var id = $("#upgrade_window_hidden_1_"+i).val();
		var pcode = $("#province_code"+i).val();
		$("#"+pcode+"_"+id).parent("div").parent("td").parent("tr").remove();
	}
}
/**将左边所有的数据全部加到右边*/
function addAllToRight(num){
	var tab = $("#ap_table_2");
	var row = document.getElementById("ap_table_2").rows.length;
	for(var i = 0;i<num;i++){
		var tr = document.getElementById("upgrade_window_tb_1_"+i);
		var id = $("#upgrade_window_hidden_1_"+i).val();
		var pcode = $("#province_code"+i).val();
		var pcode = tr.cells[0].getElementsByTagName("input")[2].value;
		var mac = tr.cells[1].innerHTML;
		var district = tr.cells[2].innerHTML;
		//如果右边也有，则不添加
		if(document.getElementById(pcode+"_"+id)){
			continue;
		}
		tab.append("<tr id='upgrade_window_tb_2_"+row+"' title='"+id+"'>" +
				   "<td><div align='center'><input type='checkbox' checked='true' id='check_input_2_"+row+"'/>" +
				   "<input type='hidden' id='upgrade_window_hidden_row_"+id+"' value='"+row+"'/>" +
				   "<input type='hidden' id='"+pcode+"_"+id+"' value='"+pcode+"'/></td>" +
				   "<td align='center'>"+mac+"</td>" +
				   "<td align='center'>"+district+"</td>" +
	         	"</tr>");
		row++;
	}
}
window.onload = function (){
	document.getElementById("background").style.width=document.body.offsetWidth+"px";
	document.getElementById("background").style.height=(document.body.offsetHeight+document.body.scrollHeight)+"px";
	document.getElementById("background_image").style.visibility="hidden";
	document.getElementById("background_image").style.left=(document.body.offsetWidth -90)/2+"px";
	document.getElementById("background").style.visibility="hidden";
};
function openLoadDataGif(){
	document.getElementById("background_image").style.visibility="visible";
	document.getElementById("background").style.visibility="visible";
}

function closeLoadDataGif(){
	document.getElementById("background_image").style.visibility="hidden";
	document.getElementById("background").style.visibility="hidden";
}

/**搜索*/
function search(){
	//查询名称
	var search_text = $("#search_text").val();
	var start_time = $("#start_time").val();
	var end_time = $("#end_time").val();
	var start_time = $("#start_time").val();
	pageNum = 0;
	scrollTop = 0;
	$("#up_div").scrollTop(0);
	openLoadDataGif();
	$.post("upgrade!searchUpgradePlan.do",
		  "search_text="+search_text+
		  "&pageNum="+pageNum+
		  "&start_time="+start_time+
		  "&end_time="+end_time,
		  function (res){
		
		var json = eval(res);
		$("#upgrade_table").empty();
		$("#upgrade_table").append("<tr style='background:#d4e1ee'>" +
										"<td width='7%'><div align='center'><input type='checkbox' /></div></td>" +
										"<td width='11%'><div align='center'>计划名称</div></td>" +
										"<td width='8%'><div align='center'>AP信息</div></td>" +
										"<td width='15%'><div align='center'>计划执行时间</div></td>" +
										"<td width='15%'><div align='center'>实际执行时间</div></td>" +
										"<td width='12%'><div align='center'>审核状态</div></td>" +
										"<td width='12%'><div align='center'>创建人</div></td>" +
								   "</tr>");
		for ( var i = 0; i < json.length; i++) {
			var addrs = "";
			var macs = "";
			for ( var j = 0; j < json[i].planApRels.length; j++) {
				if(macs == ""){
					macs = json[i].planApRels[j].mac;
				}else{
					macs = macs+":"+json[i].planApRels[j].mac;
				}
				if(addrs == ""){
					addrs = json[i].planApRels[j].pname+json[i].planApRels[j].cname+json[i].planApRels[j].dname;
				}else{
					addrs = addrs+":"+json[i].planApRels[j].pname+json[i].planApRels[j].cname+json[i].planApRels[j].dname;
				}
			}
			var hml = "<input type='checkbox' />";
			var spa = "<a href='#'>审核</a>(未审核)";
			if(json[i].isSelfCreate == '1'&&json[i].check_state != '1'){
				spa = "<a href='#' onclick='verify("+json[i].id+",event,1)'>审核</a>(未审核)";
			}else if(json[i].isSelfCreate != '1'&&json[i].check_state != '1'){
				hml = "<input type='checkbox'  disabled='disabled'/>";
				spa = "<span style='color: gray;'>未审核</span>";
			}else if(json[i].isSelfCreate == '1'&&json[i].check_state == '1'){
				//已执行的计划无法取消审核
				if(json[i].isexecute=='1'){
					spa = "<span style='color: gray;'>已审核</span>";
				}else{
					var d = json[i].id;
					spa = "<span style='color: gray;'>已审核</span>(<a href='#' onclick='verify("+d+",event,0)'>取消审核</a>)";
				}
			}else if(json[i].isSelfCreate != '1'&& json[i].check_state == '1'){
				hml = "<input type='checkbox'  disabled='disabled'/>";
				spa = "<span style='color: gray;'>已审核</span>";
			}
			//已执行的计划不能删除
			if(json[i].isexecute == '1'){
				hml = "<input type='checkbox'  disabled='disabled'/>";
			}
			var plname = json[i].plan_name == null ? "" :(json[i].plan_name.length > 10 ?
						(json[i].plan_name.substring(0,10)+"..."):json[i].plan_name);
			$("#upgrade_table").append("<tr ondblclick='editUpGradePlans("+json[i].id+","+json[i].isSelfCreate+",event)' id='editUpGradePlans_"+json[i].id+"'>" +
										"<td align='center'>"+hml+
										"<input type='hidden' value='"+json[i].id+"'/>" +
										"<input type='hidden' value='"+json[i].isSelfCreate+"'/>" +
										"<input type='hidden' value='"+json[i].check_state+"'/></td>" +
										"<td align='center' title='"+json[i].plan_name+"'>"+plname+"</td>" +
										// onmouseover='popueMac(this,event,\""+macs+"\")' onmouseout='hiddenPopueMac(this,event)'
										"<td align='center'><a href='javascript:lookApMessage("+json[i].id+");'>查看</a></td>" +
										"<td align='center'>"+json[i].execute_time+"</td>" +
										"<td align='center'>"+json[i].real_time+"</td>" +
										"<td align='center'>"+spa+"</td>" +
										"<td align='center'>"+json[i].create_user+"</td>" +
										"</tr>");
		}
		closeLoadDataGif();
	},"json");
}
/**搜索左边表格内容*/
function searchLeftTable(){
	var text = document.getElementById("searchLeftTable_text").value;
	var row = document.getElementById("ap_table_1").rows.length;
	//保存搜索到的
	var arr = new Array();
	//保存未搜索岛的
	var hiddenArr = new Array();
	for(var i = 1;i<row;i++){
		var tr = document.getElementById("ap_table_1").rows[i];
		var content = tr.cells[1].innerHTML;
		if(content.indexOf(text) == -1){
			var tr = document.getElementById("ap_table_1").rows[i];
			hiddenArr[hiddenArr.length] = tr;
		}else{
			var tr = document.getElementById("ap_table_1").rows[i];
			arr[arr.length] = tr;
		}
	}
	//删除搜索不到的
	for( var i = 1; i < row; i++) {
		var tr = document.getElementById("ap_table_1").rows[i];
		var tbody=tr.parentNode;
		tbody.removeChild(tr);
		i--;
		row = document.getElementById("ap_table_1").rows.length;
	}
	//将搜索到的放到前面
	for(var i=0;i<arr.length;i++){
		var tr = document.getElementById("ap_table_1").insertRow(1);
		for(var j = arr[i].cells.length-1;j>=0;j--){
			var td = tr.insertCell();
			td.innerHTML = arr[i].cells[j].innerHTML;
		}
	}//搜索不到的放到后面
	for(var i=0;i<hiddenArr.length;i++){
		var tr = document.getElementById("ap_table_1").insertRow(-1);
		tr.style.visibility="hidden";
		for(var j = hiddenArr[i].cells.length-1;j>=0;j--){
			var td = tr.insertCell();
			td.innerHTML = hiddenArr[i].cells[j].innerHTML;
		}
	}
}
/**删除选中计划*/
function deleteUpgradePlan(){
	var table = document.getElementById("upgrade_table");
	var trs = table.getElementsByTagName("tr");
	var ids = "";
	var arr = new Array();
	for ( var i = 1; i < trs.length; i++) {
		var tr = trs[i];
		var tds = tr.getElementsByTagName("td");
		if(tds[0].getElementsByTagName("input")[0].checked){
			//如果选中，取ID
			var id = tds[0].getElementsByTagName("input")[1].value;
			arr[arr.length] = tr;
			//审核过的、非本人创建的计划不可以删除
			if(ids != ""){
				ids=ids+":"+id;
			}else{
				ids=id;
			}
		}
	}
	$.post("upgrade!deleteUpgradePlan.do",
		   "id="+ids,
		   function(res){
		if(res=='OK'){
			for ( var i = 0; i < arr.length; i++) {
				var tr = arr[i];
				var tds = tr.getElementsByTagName("td");
				var id = tr.id;
				$("#"+id).remove();
			}
		}
	},"json");
}
/**审核计划*/
function verify(id,evt,val){
	$.post("upgrade!upgradePlanVerify.do","id="+id+"&check_state="+val,function(res){
		if(res=='OK'){
			if(val == "1"){
				evt.target.parentNode.parentNode.cells[0].getElementsByTagName("input")[3].value="1";
				evt.target.parentNode.innerHTML = "<span style='color: gray;'>已审核</span>(<a href='#' onclick='verify("+id+",event,0)'>取消审核</a>)";
			}else{
				evt.target.parentNode.parentNode.cells[0].getElementsByTagName("input")[3].value="0";
				evt.target.parentNode.innerHTML = "<a href='#' onclick='verify("+id+",event,1)'>审核</a>(未审核)";
			}
		}else{
			alert("审核失败");
		}
	},"json");
}
/**ESC退出*/
function esc(va){
	if(va == 27){
		$('#upgrade_plan_window').window('close');
		$('#lookApMessage_window').window('close');
	}else if(va == 13){
		search();
	}
};