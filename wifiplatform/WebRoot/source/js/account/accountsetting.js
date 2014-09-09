/**********************账户设置js**********************/
$(function(){
	$('#district').combotree(
			{
				url : 'euTreeData!getTreeData.do',
				valueField : 'id',
				method : 'get',
				onlyLeafCheck : true,
				textField : 'text',
				onBeforeSelect : function(node){  
					 return false;    
                }
	         });
	/**保存*/
	$("#save_ele").click(function(){
		var real_name = $("#real_name").val();
		var contact = $("#contact").val();
		var id = $("#userid").val();
		if(!checkFields(real_name,contact)){
			return;
		}
		var arguments = "real_name=" +real_name+"&" +
		"contact=" +contact+"&accountId="+id;
		$.post("account!updateAccount.do",arguments,function(res){
			if(res.success == 'success'){
				alert("修改成功！");
			}else{
				//更新失败
				alert("修改失败："+res.success);
			}
		},"json");
	});
	
	/**检查字段的合法性*/
	function checkFields(real_name,contact){
		//真实姓名
		reg = new RegExp("^[a-zA-Z\u4E00-\u9FA5]{1,10}$");
		if(!reg.exec(real_name)){
			$("#err_msg").text("真实姓名格式错误【由1-20位字母、中文组成】");
			return false;
		}
		//联系方式
		reg = new RegExp("^[0-9]{7,15}$");
		if(!reg.exec(contact)){
			$("#err_msg").text("联系方式格式错误【由7-15位数字组成】");
			return false;
		}
		$("#err_msg").text("");
		return true;
	}
});