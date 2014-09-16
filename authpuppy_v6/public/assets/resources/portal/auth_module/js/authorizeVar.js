var AUTH_TYPE_MODULE = {
		'mobile':"<div class='AuthModuleMobile'>" +
				"<div class='AuthInputLine'>" +
				"	<input type='text' class='AuthInputText' name='MobileNumber' id='MobileNumber' placeholder='手机号码...'>" +
				"	<button type='button' class='AuthMobileSMS'>获取验证码</button>" +
				"</div>" +
				"<div class='AuthInputLine'>" +
				"	<input type='text' class='AuthInputText' name='SMSCodeNumber' id='SMSCodeNumber' placeholder='手机验证码...'>" +
				"</div>"+
				"<div class='AuthInputLine'>" +
				"	<button class='AuthSubmitID ValidatorMobile'>马上登录</button>" +
				"</div>" +
				"</div>",
		'email':"<div class='AuthModuleEmail'></div>",
		'userpwd':"<div class='AuthModuleUserpwd'></div>",
		'option':"<div calss='AuthModuleOption'></div>",
		'extend':"<div class='AuthModuleExtend'></div>"
};