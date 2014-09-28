/********************修改密码js*******************/
function modifyPassword(){
	var old_password = $("#password_one").val();
	var userid = $("#userid").val();
	var new_password = $("#password_two").val();
	if(old_password != new_password){
		$("#err_msg").text("两次输入密码不一致");
		return;
	}
	if(new_password.replace(/\s+/g,'') == ''){
		$("#err_msg").text("密码不能为空");
		return;
	}
	var reg = new RegExp("^[a-zA-Z0-9]{6}$");
	if(!reg.exec(new_password)){
		$("#err_msg").text("密码格式错误【由6位字母和数字组成】");
		return;
	}
	$.post("account!modifyPassword.do",
			"new_password="+new_password+"&" +
			"userid="+userid,
			function(res){
				if(res.success == 'success'){
					$('#modifyPassword').window('close');
				}else{
					$("#err_msg").text(res.success);
				}
			},
			"json");
}
/**打开修改密码的弹出框*/
function openModifyWindow(){
	$("#password_one").val("");
	$("#password_two").val("");
	$("#err_msg").text("");
	$('#modifyPassword').window('open');
}
/**ESC键退出修改密码的弹出框*/
function closeModifyWindow(va){
	if(va == 27){
		$('#modifyPassword').window('close');
	}
}