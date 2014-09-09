$(function() {
	$('#district')
			.combotree(
					{
						url : 'euTreeData!getTreeData.do?parent_id='+parentId,
						valueField : 'id',
						method : 'get',
						onlyLeafCheck : true,
						textField : 'text',
						onBeforeSelect : function(node){  
                            var t = $(this).tree;  
                            var isLeaf = t('isLeaf', node.target);  
                            if (!isLeaf) {//选择的不是叶子节点  
                                return false;  
                            }  
                        }
//						required : true,
//						editable : false,
//						onBeforeExpand : function(node) {
//							$('#cc').combotree("tree").tree("options").url = 'euTreeData!getTreeData.do?parent_id=0';
//						},
//						onClick : function(node) {
////							$('#district').combotree("tree").tree("options").url = "euTreeData!getTreeData.do?parent_id="
////									+ node.id;
//						},//全部折叠
//						onLoadSuccess : function(node, data) {
//							$('#district').combotree('tree')
//									.tree("collapseAll");
//						}
					});
});
var rowNum = -1;
/**弹出更新编辑框*/
function showUpdateDialog(num,userid){
	rowNum = num;
	$('#add_form')[0].reset();
	$("#err_msg").text("");
	$("#operator_type").text("编辑用户");
	$("#floatDiv").panel({title:"编辑用户"});
	$('#floatDiv').window('open');
	var hidden_district = $("#hidden_district"+num).val();
	var name = $("#td_1_"+num).html();
	var real_name = $("#td_2_"+num).html();
	var contact = $("#td_3_"+num).html();
	$("#username").val(name);
	$("#real_name").val(real_name);
	$("#contact").val(contact);
	$("#accountId").val(userid);
	if(hidden_district.replace(/\s+/g,'') != ''){
		var ds = hidden_district.split(",");
		$('#district').combotree('setValues', ds);
	}
};

/**弹出创建用户窗口*/
function popCreateAccount() {
	//表单重置
	$('#add_form')[0].reset();
	$("#err_msg").text("");
	$("#accountId").val("");
	$("#operator_type").text("新增用户");
	$("#floatDiv").panel({title:"新增用户"});
	$('#floatDiv').window('open');
};
/**新增用户*/
function save() {
	var username = $("#username").val();
	var password_one = $("#password_one").val();
	var password_two = $("#password_two").val();
	var real_name = $("#real_name").val();
	var contact = $("#contact").val();
	var accountId = $("#accountId").val();
	var t = $('#district').combotree('tree'); // 得到树对象 
	var district = t.tree('getChecked');
	//检查字段合法性
	if(!checkFields(username,password_one,password_two,real_name,contact)){
		return ;
	}
	var dval = "";
	var hidden_district = "";
	for ( var i = 0; i < district.length; i++) {
		if(i > 0){
			hidden_district = hidden_district+","+district[i].id;
		}else{
			hidden_district = district[i].id;
		}
		dval = district[i].id+":"+
			   district[i].attributes.pid+":"+
			   district[i].attributes.level+":"+
			   district[i].text+","+dval;
	}
	var arguments = "username="+username+"&" +
			"password_one=" +password_one+"&" +
			"real_name=" +real_name+"&" +
			"contact=" +contact+"&" +
			"district="+dval;
	//检查是更新还是保存
	if(accountId.replace(/\s+/g,'') != ''){
		arguments=arguments+"&accountId="+accountId;
		//更新
		updateAccount(arguments,username,real_name,district,contact,hidden_district);
		return;
	}
	$.post("account!saveAccount.do",arguments,function(res){
		if(res.success == 'success'){
			//document.getElementById("floatDiv").style.visibility = "hidden";
			$('#floatDiv').window('close');
			var num = document.getElementById("content_table").rows.length;
			$("#hidden_district"+num).val();
			//插入一行记录
			$("#content_table").append("<tr id=accountTr"+num+" ondblclick='showUpdateDialog("+num+","+res.id+")'>" +
					   "<input type='hidden' id='hidden_district"+num+"' value='"+hidden_district+"'/>" +
					   "<td><div align='center' id='td_1_"+num+"'>"+username+"</div></td>" +
					   "<td><div align='center' id='td_2_"+num+"'>"+real_name+"</div></td>" +
					   "<td><div align='center' id='td_3_"+num+"'>"+contact+"</div></td>" +
					   "<td><div align='center'><a href='#'>查看</a></div></td>" +
					   "<td><div align='center'>有效</div></td>" +
					   "<td><div align='center'><a href='javascript:invalidAccount("+res.id+",0,"+num+");'>停用</a></div></td>" +
		            "</tr>");
			
		}else{
			//保存失败，提示错误
			alert("新增失败："+res.success);
		}
	},"json");
};
/**更新用户 arguments:参数*/
function updateAccount(arguments,username,real_name,district,contact,hidden_district){
	$.post("account!updateAccount.do",arguments,function(res){
		if(res.success == 'success'){
			$('#floatDiv').window('close');
			var num = document.getElementById("content_table").rows.length;
			//更新一行
			document.getElementById("accountTr"+rowNum).cells[1].innerHTML="<div align='center' id='td_1_"+rowNum+"'>"+username+"</div>";
			document.getElementById("accountTr"+rowNum).cells[2].innerHTML="<div align='center' id='td_2_"+rowNum+"'>"+real_name+"</div>";
			document.getElementById("accountTr"+rowNum).cells[3].innerHTML="<div align='center' id='td_3_"+rowNum+"'>"+contact+"</div>";
			$("#hidden_district"+rowNum).val(hidden_district);
		}else{
			//更新失败
			alert("更新失败："+res.success);
		}
	},"json");
}
/**检查字段的合法性*/
function checkFields(username,password_one,password_two,real_name,contact){
	//用户名
	if(username.replace(/\s+/g,'') == ''){
		$("#err_msg").text("用户名不能为空");
		return false;
	}
	var reg = new RegExp("^[a-zA-Z0-9_]{1,10}$");
	if(!reg.exec(username)){
		$("#err_msg").text("用户名格式错误【由1-10位字母、数字、下划线组成】");
		return false;
	}
	//密码
	if(password_one != password_two){
		$("#err_msg").text("两次密码不一致");
		return false;
	}
	if(password_one.replace(/\s+/g,'') == ''){
		$("#err_msg").text("密码不能为空");
		return false;
	}
	reg = new RegExp("^[a-zA-Z0-9]{6}$");
	if(!reg.exec(password_one)){
		$("#err_msg").text("密码格式错误【由6位字母和数字组成】");
		return false;
	}
	//真实姓名
	if(username.replace(/\s+/g,'') != ''){
		reg = new RegExp("^[a-zA-Z\u4E00-\u9FA5]{1,10}$");
		if(!reg.exec(real_name)){
			$("#err_msg").text("真实姓名格式错误【由1-20位字母、中文组成】");
			return false;
		}
	}
	//联系方式
	if(username.replace(/\s+/g,'') != ''){
		reg = new RegExp("^[0-9]{7,15}$");
		if(!reg.exec(contact)){
			$("#err_msg").text("联系方式格式错误【由7-15位数字组成】");
			return false;
		}
	}
	$("#err_msg").text("");
	return true;
}
var trId_ss;
/**启用、停用账户*/
function invalidAccount(id,invalid_flag,trId){
	$.post("account!invalidAccount.do",
		  "id="+id+"&invalid_flag="+invalid_flag,
		  function (response){
				if(response.success=='success'){
					if(invalid_flag == '0'){
						document.getElementById("accountTr"+trId).cells[4].innerHTML="<div align='center'>失效</div>";
						document.getElementById("accountTr"+trId).cells[5].innerHTML="<div align='center'><a href='javascript:invalidAccount("+id+",1,"+trId+");'>启用</a></div>";;
					}else{
						document.getElementById("accountTr"+trId).cells[4].innerHTML="<div align='center'>有效</div>";
						document.getElementById("accountTr"+trId).cells[5].innerHTML="<div align='center'><a href=" +
								                 "'javascript:invalidAccount("+id+",0,"+trId+");'>停用</a></div>";
					}
				}else{
					alert(res.success);
				}
		  },
		  "JSON");
};
/**查询用户*/
function queryAccount(){
	var search_text = $("#search_text").val();
	$.get("account!queryAccount.do",
			"search_text="+search_text,
			function (resp){
				document.getElementById("content_div").innerHTML=resp;
	},"html");
};
/**回车查询*/
function keyBoardQuery(va){
	if(va == 13){
		queryAccount();
	}else if(va == 27){
		$('#add_form')[0].reset();
		$("#err_msg").text("");
		$('#floatDiv').window('close');
	}
};