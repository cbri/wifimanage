var frame_title_text = "爱WiFi联盟";
var frame_footer_text = "版权所有：浙江省公众信息产业有限公司";
var frame_header_placeholder_text = "";
var login_box_title_text = "帐号登录";
var session_timeout_title = "未操作时间超过30分钟";
var session_timeout_text = "即将跳转到登录页...";	

//$("#frame_title_text").html(frame_title_text);
document.title = frame_title_text;
$("#frame_footer_text").html(frame_footer_text);
$("#frame_header_placeholder").html(frame_header_placeholder_text)
$("#login_box_title").html(login_box_title_text);

var isBSIE = false;
var isIE8 = false;
var isIE9 = false;
isIE8 = !! navigator.userAgent.match(/MSIE 8.0/);
isIE9 = !! navigator.userAgent.match(/MSIE 9.0/);
if(isIE8 || isIE9){ 
	isBSIE = true;
}

//////////////////////////////////////////////////////////////////////
//main menu definition
var MAIN_MENU = new function() {
	this.ALL_MENUS = [{'name': ' 帐号概览', 'id': 'id_mm_overview', 'icon':'glyphicon glyphicon-home', 'dest_url': '/account/account_overview.htm'},
	                  {'name': ' 设备管理', 'id': 'id_mm_device', 'icon':'glyphicon glyphicon-subtitles', 'dest_url': '/device/devicelist.htm'},
	                  {'name': ' WiFi门户', 'id': 'id_mm_portal', 'icon':'glyphicon glyphicon-globe', 'dest_url': '/merchant/sites.htm'},
	                  {'name': ' 用户管理', 'id': 'id_mm_user', 'icon':'glyphicon glyphicon-tower', 'dest_url': '/user/users.htm'},
	                  {'name': ' 统计分析', 'id': 'id_mm_statistics', 'icon':'glyphicon glyphicon-stats', 'dest_url': '/system/statistics.htm'},
	                  {'name': ' 帐号管理', 'id': 'id_mm_account', 'icon':'glyphicon glyphicon-user', 'dest_url': '/account/account_management.htm'},
	                  {'name': ' 系统设置', 'id': 'id_mm_system', 'icon':'glyphicon glyphicon-fire', 'dest_url': '/system/platformsettings.htm'},
	                  {'name': ' 商户设置', 'id': 'id_mm_merchant', 'icon':'glyphicon glyphicon-leaf', 'dest_url': '/merchant/smspurchasemgmt.htm'},
	                  ];
	
	this.ACCESS_MENU_MATRIX = {
		"SUPER_MAN": 		['id_mm_overview', 'id_mm_device', 'id_mm_portal', 'id_mm_user', 'id_mm_statistics', 'id_mm_account', 'id_mm_system'],
		"ADMINISTRATOR": 	['id_mm_overview', 'id_mm_device', 'id_mm_portal', 'id_mm_user', 'id_mm_statistics', 'id_mm_account'],
		"REPRESENTATIVE": 	['id_mm_overview', 'id_mm_device', 'id_mm_portal', 'id_mm_user', 'id_mm_statistics', 'id_mm_account'],
		"MERCHANT": 		['id_mm_overview', 'id_mm_device', 'id_mm_portal', 'id_mm_user', 'id_mm_statistics', 'id_mm_merchant']
	};
	
	this.getDestUrl = function (dest_menu_item_id) {
		if (this.ALL_MENUS != null && this.ALL_MENUS.length > 0 
				&& dest_menu_item_id != null && typeof dest_menu_item_id == "string") {
			for (var i = 0; i < this.ALL_MENUS.length;i++) {
				if (dest_menu_item_id == this.ALL_MENUS[i].id){
					return this.ALL_MENUS[i].dest_url;
				}
			}
		}
		return null;
	};
	
	this.getMenuByAcctType = function(acctType) {
		var permitted_menu_ids = null;
		if (acctType == ACCOUNT_TYPE_CONST[0].en_name) {
			permitted_menu_ids = this.ACCESS_MENU_MATRIX.SUPER_MAN;
		}
		else if (acctType == ACCOUNT_TYPE_CONST[1].en_name) {
			permitted_menu_ids = this.ACCESS_MENU_MATRIX.ADMINISTRATOR;
		}
		else if (acctType == ACCOUNT_TYPE_CONST[2].en_name) {
			permitted_menu_ids = this.ACCESS_MENU_MATRIX.REPRESENTATIVE;
		}
		else if (acctType == ACCOUNT_TYPE_CONST[3].en_name) {
			permitted_menu_ids = this.ACCESS_MENU_MATRIX.MERCHANT;
		}
		else {
			// undefined account type
		}
		
		var permitted_main_menu = null;
		if (permitted_menu_ids != null && permitted_menu_ids.length > 0) {
			var html_menu = '';
			permitted_main_menu = [];
			for (var i = 0; i < permitted_menu_ids.length;i++) {
				var menu_id = permitted_menu_ids[i];
				
				for (var j = 0; j < this.ALL_MENUS.length;j++) {
					if (menu_id == this.ALL_MENUS[j].id) {
						permitted_main_menu.push(this.ALL_MENUS[j]);
						break;
					} 
				}
			}
		
			return permitted_main_menu;
		}
		else {
			return null;
		}
	};
	
	this.drawMainMenuForAccount = function(acctType) {
		var permitted_menu = this.getMenuByAcctType(acctType);
		
		if (permitted_menu != null) {
			this.doDrawMainMenu(permitted_menu, null);
		}
	};

	this.doDrawMainMenu = function(menu_items, active_item_id) {
		if (menu_items != null && menu_items.length > 0) {
			
			if ($(".main-nav-item").length == 0) {
				var html_menu = '';
				for (var i = 0; i < menu_items.length ; i++) {
					var menu_id = menu_items[i]['id'];
					var menu_name = menu_items[i]['name'];
					var menu_icon_class = menu_items[i]['icon'];
					
					html_menu += "<li class='main-nav-item' id='" + menu_id + "'>";
					html_menu += 	"<a href=\"javascript:show_maincontent('id_main_content','" + menu_id + "');\">";
					html_menu += 		"<i class='" + menu_icon_class + "'></i>"
					html_menu += 		menu_name
					html_menu += 	"</a>";
					html_menu += "</li>";
				}
				$("#id_nav").html(html_menu);
			}
			
			this.setActiveMenuItem(active_item_id);
		}
		return true;
	};
	
	this.setActiveMenuItem = function(active_item_id) {
		// 默认设置 菜单item list 中第一项为激活状态
		if (active_item_id != null && typeof active_item_id == "string") {
			var objActiveItem = $("#" + active_item_id) ; 
			if (objActiveItem.length > 0 && !objActiveItem.hasClass('active')) {
				$(".main-nav-item").removeClass('active');
				$("#" + active_item_id).addClass('active');
			}
		}
		else {
			$(".main-nav-item").removeClass('active');
			$("#" + this.ALL_MENUS[0]['id']).addClass('active');
		}
	};
};

	
//////////////////////////////////////////////////////////////////////
// these consts below should load from server site.
var ACCOUNT_TYPE = {'SUPER_MAN': 'SUPER_MAN', 'ADMINISTRATOR': 'ADMINISTRATOR', 'REPRESENTATIVE': 'REPRESENTATIVE', 'MERCHANT': 'MERCHANT'}
var ACCOUNT_TYPE_CONST = [{'SUPER_MAN': 'SUPER_MAN', 			'en_name': 'SUPER_MAN', 'cn_name': '超级管理员'}, 
                          {'ADMINISTRATOR': 'ADMINISTRATOR', 	'en_name': 'ADMINISTRATOR', 'cn_name': '管理员'}, 
                          {'REPRESENTATIVE': 'REPRESENTATIVE', 	'en_name': 'REPRESENTATIVE', 'cn_name': '代理商'}, 
                          {'MERCHANT': 'MERCHANT', 				'en_name': 'MERCHANT', 'cn_name': '商户'}];

function getAccountTypeEnName(cn_name) {
	if (cn_name != null && typeof cn_name == 'string') {
		for (var i = 0; i < ACCOUNT_TYPE_CONST.length;i++) {
			if (cn_name == ACCOUNT_TYPE_CONST[i].cn_name) {
				return ACCOUNT_TYPE_CONST[i].en_name;
			}
		}
	}
	
	return null;
}

function getAccountTypeCnName(en_name) {
	if (en_name != null && typeof en_name == 'string') {
		for (var i = 0; i < ACCOUNT_TYPE_CONST.length;i++) {
			if (en_name == ACCOUNT_TYPE_CONST[i].en_name) {
				return ACCOUNT_TYPE_CONST[i].cn_name;
			}
		}
	}
	
	return null;
}

function getDisplayableAccountTypes() {
	var displayableAcctTypes = ACCOUNT_TYPE_CONST.clone();
	
	displayableAcctTypes.removeOnIndex(0); // cannot set account to SUPER_MAN
	
	return displayableAcctTypes;
}

//////////////////////////////////////////////////////////////////////
// permission definition
var WHOLE_PERMISSIONS = [{'cn_name': '下属管理员管理', 		'id': 'id_perm_subadmin_mgmt', 			'perm_code': 'SUBADMIN_MGMT', 		'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR']},
		                   {'cn_name': '代理商管理', 		'id': 'id_perm_representative_mgmt', 	'perm_code': 'REPRESENTATIVE_MGMT', 'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR']},
		                   {'cn_name': '商户管理', 		'id': 'id_perm_merchant_mgmt', 			'perm_code': 'MERCHANT_MGMT',		'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR', 'REPRESENTATIVE']},
		                   {'cn_name': '用户管理', 		'id': 'id_perm_user_mgmt', 				'perm_code': 'USER_MGMT',			'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR', 'REPRESENTATIVE', 'MERCHANT']},
		                   {'cn_name': '设备管理', 		'id': 'id_perm_device_mgmt', 			'perm_code': 'DEVICE_MGMT',			'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR', 'REPRESENTATIVE', 'MERCHANT']},
		                   {'cn_name': 'WiFi门户管理', 	'id': 'id_perm_portal_mgmt', 			'perm_code': 'PORTAL_MGMT', 		'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR', 'REPRESENTATIVE', 'MERCHANT']},
		                   {'cn_name': '基本信息管理', 		'id': 'id_perm_profile_mgmt', 			'perm_code': 'PROFILE_MGMT',		'default_account_type': ['SUPER_MAN', 'ADMINISTRATOR', 'REPRESENTATIVE', 'MERCHANT']},
		                   {'cn_name': '系统设置管理', 		'id': 'id_perm_system_cfg_mgmt', 		'perm_code': 'SYSTEM_CFG_MGMT',		'default_account_type': ['SUPER_MAN']}];

function acctTypePermCodeFilter(accountType, permCode_lst) {
	var whole_perms_type_filted = perm_lst.clone();
	
	if (accountType == null) {
		return whole_perms_type_filted;
	}
	
	// whole_permissions_lst add accountType filter
	for (var i = 0; i < permCode_lst.length ; i++) {
		for (var j = 0; j < WHOLE_PERMISSIONS.length; j++) {
			if (permCode_lst[i] == WHOLE_PERMISSIONS[j].perm_code 
					&& WHOLE_PERMISSIONS[i].default_account_type.indexOf(accountType) < 0) {
				whole_perms_type_filted.remove(permCode_lst[i]);
			}
		}
	}
	
	return whole_perms_type_filted;
}

//function filterWholePermissionByAcctType(accountType) {
function AcctTypeFilterForWholePermission(accountType) {
	var whole_perms_type_filted = WHOLE_PERMISSIONS.clone();

	if (accountType == null) {
		return whole_perms_type_filted;
	}
	
	if (accountType == ACCOUNT_TYPE_CONST.SUPER_MAN) {
		// super_man should not be displayable or editable.
		return whole_perms_type_filted;
	}
	
	// whole_permissions_lst add accountType filter
	for (var i = 0; i < WHOLE_PERMISSIONS.length ; i++) {
		if (WHOLE_PERMISSIONS[i].default_account_type.indexOf(accountType) < 0) {
			whole_perms_type_filted.remove(WHOLE_PERMISSIONS[i]);
		}
	}
	
	return whole_perms_type_filted;
}

//////////////////////////////////////////////////////////////////////
// CONST definition
var LOGIN_ACCOUNT_INFO = "login_account_info"

//////////////////////////////////////////////////////////////////////
// Account Status
var ACCOUNT_STATUS_NORMAL = 'NORMAL';
var ACCOUNT_STATUS_INACTIVE = 'LOCKED';

var ACCOUNT_STATUS_OPT_LOCK = 'LOCK';
var ACCOUNT_STATUS_OPT_UNLOCK = 'UNLOCK';
var PORTAL_PAGE_TYPE_AUTH = 'AUTH';
var PORTAL_PAGE_TYPE_LOGIN = 'LOGIN';
var PORTAL_PAGE_TYPE_INSITE = 'INSITE';
var DEVICE_STATUS_ONLINE = 'ONLINE';
var DEVICE_STATUS_OFFLINE = 'OFFLINE';
var DEVICE_STATUS_LOCKED  = 'LOCKED';
var DEVICE_STATUS_UNLOCKED = 'UNLOCKED';
var PORTAL_SITE_STATUS_NORMAL = 'NORMAL';
var PORTAL_SITE_STATUS_LOCKED = 'LOCKED';

//////////////////////////////////////////////////////////////////////
//ACCOUNT LEVEL definition
var ACCOUNT_GEO_LEVEL = [{"level": 1, "cn_name": "L1 - 全国"},
                         {"level": 2, "cn_name": "L2 - 省级"},
                         {"level": 3, "cn_name": "L3 - 市级"},
                         {"level": 4, "cn_name": "L4 - 县区级"}];

function accountGeoLevelSort() {
	return ACCOUNT_GEO_LEVEL.sort(function(a, b) {return a.level - b.level;});
}

function getGeoCnNameByGeoLevel(geoLevel) {
	var geo_levels = accountGeoLevelSort().clone();
	for (var i = 0; i < geo_levels.length; i++) {
		if (String(geo_levels[i].level) == String(geoLevel)) {
			return geo_levels[i].cn_name;
		}
	}
}

function getGeoLevelByCnName(cnName) {
	var geo_levels = accountGeoLevelSort().clone();
	for (var i = 0; i < geo_levels.length; i++) {
		if (geo_levels[i].cn_name.equalsIgnoreCase(cnName)) {
			return geo_levels[i].level;
		}
	}
}

function getEditableGeoLevel(optAcctGeoLevel, optAcctType) {
	var geo_levels = accountGeoLevelSort().clone();
	var retGeoLevels = [];
	
	if (((optAcctGeoLevel == null || optAcctGeoLevel == undefined) && (optAcctType == null || optAcctType == undefined))
			|| optAcctType == ACCOUNT_TYPE.SUPER_MAN) {
		return geo_levels;
	}
	
	var nAcctGeoLevel = parseInt(optAcctGeoLevel);
	
	if (typeof nAcctGeoLevel === 'number') {
		for (var i = 0; i < geo_levels.length; i++) {
			if (nAcctGeoLevel < geo_levels[i].level) {
				retGeoLevels.push(geo_levels[i]);
			}
		}
		
		return retGeoLevels.sort(function(a, b) {return a.level - b.level;});
	}
	
	return null;
}
//////////////////////////////////////////////////////////////////////
//geoLocation JSON 格式编码

function getObjectAddress(province, city, county, detailAddress) {
	detailAddress = detailAddress.replace("\r\n", " ").replace("\n", " ").replace("\r", " ");
	var address = {
			"province": province,
			"city": city,
			"county": county,
			"address": detailAddress
	};
	
	return address;
}
	
//////////////////////////////////////////////////////////////////////
// PORTAL POLICY ITEM 
var PRECISION = 1; // hours,   2 / 1 / 0.5 / 0.25
var TIMESHEET_COL_NUMBER = 24 / PRECISION;

//////////////////////////////////////////////////////////////////////
//file upload settings
var MAX_FILE_SIZE = 2*1024*1024;

function UPLOAD_FILE_VALIDATION(data) {
	var isValidFile = true;
	if(isBSIE){
		$.each(data.files, function (index, file) {
			var filePath =file.name;
			var fileType;
			if(filePath != '' && filePath != null && filePath != "undefined"){
				 fileType =filePath.substring(filePath.lastIndexOf("."),filePath.length).toLowerCase();
			}			
			if(fileType!= '.jpeg' && fileType != '.png' && fileType != '.jpg'){
				$.pnotify({
		            title: "不支持的类型文件",
		            text: "请使用jpg、jpeg、png文件",
		            type: 'error',
		            delay: 1500
		        });
				isValidFile = false;
			}
		});
	}
	else{
		$.each(data.files, function (index, file) {
			if (file.size > MAX_FILE_SIZE) {
		        $.pnotify({
		            title: "图片超过限制，图片大小应该小于 " + MAX_FILE_SIZE / (1024*1024) + "M",
		            type: 'error',
		            delay: 1500
		        });
				isValidFile = false;
			}
			
			if (file.type != 'image/jpeg' && file.type != 'image/png') {
		        $.pnotify({
		            title: "不支持的类型文件",
		            text: "请使用jpg、jpeg、png文件",
		            type: 'error',
		            delay: 1500
		        });
				isValidFile = false;
			}
		});
	}
	return isValidFile;
}

function UPLOAD_ZIPFILE_VALIDATION(data) {
	var iszipValidFile = true;
	if(isBSIE){
		$.each(data.files, function (index, file) {
			var filePath =file.name;
			var fileType;
			if(filePath != '' && filePath != null && filePath != "undefined"){
				 fileType =filePath.substring(filePath.lastIndexOf("."),filePath.length).toLowerCase();
			}			
			if(fileType!= '.zip'){
				$.pnotify({
		            title: "不支持的类型文件",
		            text: "请使用Zip文件",
		            type: 'error',
		            delay: 1500
		        });
				iszipValidFile = false;
			}
		});
	}
	else{
		$.each(data.files, function (index, file) {
			
			if (file.type != 'application/zip') {
		        $.pnotify({
		            title: "不支持的类型文件",
		            text: "请使用ZIP文件",
		            type: 'error',
		            delay: 1500
		        });
		        iszipValidFile = false;
			}
		});	
	}
	return iszipValidFile;
}
//////////////////////////////////////////////////
// shortcut references

var SHORTCUT_REFS = new function () {
	this.REFS = [{"resourceLocation":"/resources/img/biao_01.png", "ref": "DeviceAction.devicelist"},
                     {"resourceLocation":"/resources/img/biao_02.png", "ref": "MerchantAction.siteList"},
                     {"resourceLocation":"/resources/img/biao_03.png", "ref": "MerchantAction.addSite"},
                     {"resourceLocation":"/resources/img/biao_04.png", "ref": "MerchantAction.portalPoliciesManagement"},
                     {"resourceLocation":"/resources/img/biao_05.png", "ref": "MerchantAction.addPortalPolicy"},
                     {"resourceLocation":"/resources/img/biao_06.png", "ref": "UserAction.userlist"},
                     {"resourceLocation":"/resources/img/biao_07.png", "ref": "SystemAction.statistics"},
                     {"resourceLocation":"/resources/img/biao_08.png", "ref": "MerchantAction.trafficstatis"},
                     {"resourceLocation":"/resources/img/biao_09.png", "ref": "MerchantAction.portalsstatis"},
                     {"resourceLocation":"/resources/img/biao_10.png", "ref": "AccountAction.accountmanage"},
                     {"resourceLocation":"/resources/img/biao_11.png", "ref": "AccountAction.editAccount"},
                     {"resourceLocation":"/resources/img/biao_12.png", "ref": "SystemAction.releaseComponent"},
                     {"resourceLocation":"/resources/img/biao_13.png", "ref": "SystemAction.platformSettings"}];

	
	this.getResourceLocationByRef = function (ref) {
		var location = null;
		
		for (var i = 0; i < this.REFS.length; i++){
			if (ref == this.REFS[i].ref) {
				location = this.REFS[i].resourceLocation;
			}
		}
		
		return location;
	};
}
//////////////////////////////////////////////////
//authentication types
var PORTAL_AUTH_TYPE = new function () {
	this.ALL_TYPES = [{"cn_name": "短信", "en_name":"MOBILE"},
	                  {"cn_name": "微信", "en_name":"WECHAT"},
	                  {"cn_name": "邮件", "en_name":"EMAIL"},
	                  {"cn_name": "用户名密码", "en_name":"USERPWD"},
	                  {"cn_name": "可选", "en_name":"OPTION"},
	                  {"cn_name": "第三方", "en_name":"EXTEND"}
	                  ];
	
	this.getAuthTypeByCnName = function(cnName) {
		var auth_type = null;
		
		if (isNotEmptyString(cnName)) {
			for (var i =0; i< this.ALL_TYPES.length;i++) {
				if (cnName == this.ALL_TYPES[i].cn_name) {
					auth_type = this.ALL_TYPES[i];
				}
			}
		}
	
		return auth_type;
	};
	this.getEnNameByCnName = function(cnName) {
		var auth_type = this.getAuthTypeByCnName(cnName);
		return auth_type.en_name;
	}
	
	this.getAuthTypeByEnName = function(enName) {
		var auth_type = null;
		
		if (isNotEmptyString(enName)) {
			for (var i =0; i< this.ALL_TYPES.length;i++) {
				if (enName == this.ALL_TYPES[i].en_name) {
					auth_type = this.ALL_TYPES[i];
				}
			}
		}
	
		return auth_type;
	};
	this.getCnNameByEnName = function(enName) {
		var auth_type = this.getAuthTypeByEnName(enName);
		return auth_type.cn_name;
	}
}

//////////////////////////////////////////////////
// system configuration
var SYSTEM_ITEMS = {
		"AUTH_TYPES": "auth_types", 
		"SMS_GATEWAY": "sms_gateway",
		"OPERATION_LOG_SIZE":"operation_log_size",
		"SMS_UNIT_PRICE": "sms_unit_price"
};

/////////////////////////////////////////////////
//device module constants definition

var DEVICE_LIST_REFRESH_TIMER = new function() {
	this.REFRESH_INTERVAL = 30*1000; //30 seconds
	this.contextPath = null;
	this.timer_handler = null;
	this.stopSign = false;
	this.refreshCallBack = null;
	this.deviceIds = null;

	this.errorStack = [];
	this.failStack = [];
	
	this.stopTimer = function () {
		this.stopSign = true;
	}
	this.initialTimer = function(refreshCallBackFunc) {
		if (this.timer_handler == null) {
			if (refreshCallBackFunc != null  && refreshCallBackFunc != undefined && typeof(refreshCallBackFunc) == "function") {
				this.refreshCallBack = refreshCallBackFunc;
				
				DEVICE_LIST_REFRESH_TIMER.setRefreshTimer();
				return true;
			}
			return false;
		}

		return true;
	};
	this.setRefreshTimer = function () {
		if (this.stopSign) {
			if (this.timer_handler != null && this.timer_handler != undefined) {
				clearTimeout(this.timer_handler);
				this.timer_handler = null;
				this.stopSign = false;
			}
		}
		else {
			clearTimeout(this.timer_handler);
			this.refreshDevice();
			
			var actionJs = "DEVICE_LIST_REFRESH_TIMER.setRefreshTimer();";
			this.timer_handler = setTimeout(actionJs, DEVICE_LIST_REFRESH_TIMER.REFRESH_INTERVAL);
		}
	};
	
	this.refreshDevice = function () {
		if (isNotEmptyString(DEVICE_LIST_REFRESH_TIMER.deviceIds)) {
			$.ajax({
				type : 'GET',
				dataType : 'json',
				url : DEVICE_LIST_REFRESH_TIMER.contextPath + '/device/devicesinfo.htm',
				data : {
					'deviceids' : DEVICE_LIST_REFRESH_TIMER.deviceIds
				},
				success : function(data) {
					if (data.result != 'FAIL') {
						DEVICE_LIST_REFRESH_TIMER.refreshCallBack(data);
					} else {
						DEVICE_LIST_REFRESH_TIMER.failStack.push(data);
					}
				},
				error : function(data) {
					DEVICE_LIST_REFRESH_TIMER.errorStack.push(data);
				}
			});
		}
	};
};

/////////////////////////////////////////////////
// third part access status
var THIRD_PART_ACCESS_STATUS = new function() {
/*	this.THIRD_PART_ACCESS_STATUS_NORMAL = "NORMAL";
	this.THIRD_PART_ACCESS_STATUS_LOCKED = "LOCKED";
	this.THIRD_PART_ACCESS_STATUS_DELETED = "DELETED";*/
	
	this.NORMAL = "NORMAL";
	this.LOCKED = "LOCKED";
	this.DELETED = "DELETED";
	
	this.NORMAL_CN = "正常";
	this.LOCKED_CN = "锁定";
	this.DELETED_CN = "删除";
	
	this.convertStatusToCn = function(status) {
		var cnName = null;
		if (status == THIRD_PART_ACCESS_STATUS.NORMAL) {
			cnName = THIRD_PART_ACCESS_STATUS.NORMAL_CN;
		} else if (status == THIRD_PART_ACCESS_STATUS.LOCKED) {
			cnName = THIRD_PART_ACCESS_STATUS.LOCKED_CN;
		} else if (status == THIRD_PART_ACCESS_STATUS.DELETED) {
			cnName = THIRD_PART_ACCESS_STATUS.DELETED_CN;
		}
		
		return cnName;
	}
};

function getHttpConPath(){
	//return "http://" + window.location.hostname + (window.location.port ? ":"+http_port : "");
	return "http://" + window.location.hostname + (http_port ? ":"+http_port : "");
}

//全局的ajax访问，处理ajax清求时sesion超时
$.ajaxSetup({
	cache: false,
    contentType:"application/x-www-form-urlencoded;charset=utf-8", 
    complete:function(XMLHttpRequest,textStatus){ 
            var sessionstatus=XMLHttpRequest.getResponseHeader("sessionstatus"); //通过XMLHttpRequest取得响应头，sessionstatus，
            if(sessionstatus=="timeout"){ 
                //如果超时就处理 ，指定要跳转的页面
            	$.pnotify({
            		title: session_timeout_title,
            		text: session_timeout_text,
            		type: 'success'
            	});
            	setTimeout ("window.location.replace('" + contextPath + "/account/logout.htm');", 2500);
            }
        }
    } 
);
