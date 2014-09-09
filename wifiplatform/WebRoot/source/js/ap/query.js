function querybymac() {

	openLoadDataGif();
	$("#scroll_top").val(0);
	$("#scroll_num").val(0);
	$("#up_div").scrollTop(0);
	var $mac = $("#searchbymac").val();
	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!highranksearch",
				data : "mac=" + $mac,
				success : function(json) {
					closeLoadDataGif();
					var htmlStr = "";
					htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
					htmlStr += " <tr style='background:#d4e1ee;'>";
					htmlStr += " <td width='12%'><div align='center'>AP名称</div></td>";
					htmlStr += " <td width='10%'><div align='center'>管理IP</div></td>";
					htmlStr += " <td width='10%'><div align='center'>AP MAC</div></td>";
					htmlStr += " <td width='18%'><div align='center'>商家</div></td>";
					htmlStr += " <td width='18%'><div align='center'>区域</div></td>";
					htmlStr += " <td width='15%'><div align='center'>安装位置</div></td>";
					htmlStr += " <td width='10%'><div align='center'>SSID</div></td>";
					htmlStr += " <td width='5%'><div align='center'>操作</div></td>";
					htmlStr += "</tr>";
					for ( var i = 0; i < json.length; i++) {
						if (json[i].onLine) {
							htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("
									+ json[i].id + ");>"
						} else {
							htmlStr += "<tr style='background:#ded8df' ondblclick=attrLook("
									+ json[i].id + ");>"
						}
						htmlStr += "<td width='12%'><div align='center'>"
								+ json[i].name + "</div></td>";
						htmlStr += "<td width='10%'><div align='center'>"
								+ json[i].ipaddr + "</div></td>";
						htmlStr += "<td width='10%' ><div align='center'>"
								+ json[i].mac + "</div></td>";
						htmlStr += "<td width='18%'><div align='center' >"
								+ "<a href='javascript:merchantlook("
								+ json[i].id
								+ ");'>"
								+ ((json[i].merchant == null || json[i].merchant == '') ? ''
										: (json[i].merchant.length > 10 ? json[i].merchant
												.substring(0, 10)
												+ "..."
												: json[i].merchant)) + "</a>"
								+ "</div></td>";
						htmlStr += "<td width='18%'><div align='center'>"
								+ ((json[i].province == '北京市') ? ''
										: json[i].province) + "" + json[i].city
								+ "" + json[i].district + "" + "</div></td>";
						htmlStr += "<td width='15%'><div align='left'  title='"
								+ json[i].detail
								+ "'>"
								+ ((json[i].detail == null) ? ''
										: (json[i].detail.length > 10 ? json[i].detail
												.substring(0, 10)
												+ "..."
												: json[i].detail))
								+ "</div></td>";
						htmlStr += "<td width='10%'><div align='center'>"
								+ ((json[i].ssid == null) ? '' : json[i].ssid)
								+ "</div></td>";
						if (json[i].onLine) {
							htmlStr += "<td width='5%'><div align='center'>"
									+ " <a href=\"javascript:ap_setAll('"
									+ json[i].id + "','" + json[i].mac + "','"
									+ json[i].merchant_id + "');\">设置</a>"
									+ "</div></td>";
						} else {
							htmlStr += "<td width='5%'><div align='center'>"
									+ "--" + "</div></td>";
						}
						htmlStr += "</tr>";
					}
					htmlStr += "</table>";
					$("#data_table").html(htmlStr);
				},
				error : function() {
					closeLoadDataGif();
					if (!confirm('没有搜索到内容'))
						return;
				}
			});
};
function queryMobymac() {

	openLoadDataGif();
	$("#scroll_top").val(0);
	$("#scroll_num").val(0);
	$("#up_div").scrollTop(0);
	var $mac = $("#searchbymac").val();
	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!highranksearch",
				data : "mac=" + $mac,
				success : function(json) {
					closeLoadDataGif();
					var htmlStr = "";
					htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
					htmlStr += " <tr style='background:#d4e1ee;'>";
					htmlStr += " <td width='12%'><div align='center'>AP名称</div></td>";
					htmlStr += " <td width='8%'><div align='center'>MAC地址</div></td>";
					htmlStr += " <td width='5%'><div align='center'>CPU负载</div></td>";
					htmlStr += " <td width='8%'><div align='center'>内存占用</div></td>";
					htmlStr += " <td width='8%'><div align='center'>运行时间</div></td>";
					htmlStr += " <td width='12%'><div align='center'>商家</div></td>";
					htmlStr += " <td width='15%'><div align='center'>区域</div></td>";
					htmlStr += " <td width='12%'><div align='center'>详细位置</div></td>";
					htmlStr += " <td width='4%'><div align='center'>操作</div></td>";
					htmlStr += " <td width='4%'><div align='center'>流量</div></td>";
					htmlStr += "</tr>";
					for ( var i = 0; i < json.length; i++) {
						if (json[i].onLine) {
							htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("
									+ json[i].id + ");>"
						} else {
							htmlStr += "<tr style='background:#ded8df' ondblclick=attrLook("
									+ json[i].id + ");>"
						}
						htmlStr += "<td width='12%'><div align='center'>"
								+ json[i].name + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].mac + "</div></td>";
						htmlStr += "<td width='5%'><div align='center'>"
								+ json[i].sys_upload + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].sys_memfree + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].uptime + "</div></td>";
						htmlStr += "<td width='12%'><div align='center' >"
								+ "<a href='javascript:merchantlook("
								+ json[i].id
								+ ");'>"
								+ ((json[i].merchant == null || json[i].merchant == '') ? ''
										: (json[i].merchant.length > 10 ? json[i].merchant
												.substring(0, 10)
												+ "..."
												: json[i].merchant)) + "</a>"
								+ "</div></td>";
						htmlStr += "<td width='15%'><div align='center'>"
								+ ((json[i].province == '北京市') ? ''
										: json[i].province) + "" + json[i].city
								+ "" + json[i].district + "" + "</div></td>";
						htmlStr += "<td width='12%'><div align='left'   title='"
								+ json[i].detail
								+ "'>"
								+ ((json[i].detail == null) ? ''
										: (json[i].detail.length > 10 ? json[i].detail
												.substring(0, 10)
												+ "..."
												: json[i].detail))
								+ "</div></td>";
						if (json[i].onLine) {
							htmlStr += "<td width='4%'><div align='center'>"
									+ " <a href=\"javascript:ap_setAll('"
									+ json[i].id + "','" + json[i].mac + "','"
									+ json[i].merchant_id + "');\">设置</a>"
									+ "</div></td>";
							htmlStr += "<td width='4%'><div align='center'><a href='#' onclick='lookFlow(\""
									+ json[i].mac + "\");'>查看</a></div></td>";
						} else {
							htmlStr += "<td width='4%'><div align='center'>"
									+ "--" + "</div></td>";
							htmlStr += "<td width='4%'><div align='center'>"
									+ "--" + "</div></td>";
						}
						htmlStr += "</tr>";
					}
					htmlStr += "</table>";
					$("#data_table").html(htmlStr);
				},
				error : function() {
					closeLoadDataGif();
					if (!confirm('没有查询到您需要的数据!'))
						return;
				}
			});
};
// 搜索
var query_content = "";
function mostquery() {
	$("#scroll_top").val(0);
	$("#scroll_num").val(0);
	$("#up_div").scrollTop(0);
	$("#ap_highserch").window('open');
}
// 高级查询
function highquery() {
	openLoadDataGif();
	var apname = $("#apname").val();
	var mac = $("#mac").val();
	var ipaddr = $("#ipaddr").val();
	var hardware_ver = $("#hardware_ver").val();
	var software_ver = $("#software_ver").val();
	var ssid = $("#ssid").val();
	var province = $("#province").val();
	var city = $("#city").val();
	var district = $("#district").val();
	var starttime = $("#starttime").val();
	var endtime = $("#endtime").val();
	var merchant = $("#merchant").val();
	var time = $("#time").val();
	query_content = "name=" + apname + "&mac=" + mac + "&ipaddr=" + ipaddr
			+ "&hardware_ver=" + hardware_ver + "&software_ver=" + software_ver
			+ "&ssid=" + ssid + "&merchant=" + merchant + "&province="
			+ province + "&city=" + city + "&district=" + district
			+ "&starttime=" + starttime + "&endtime=" + endtime + "&time="
			+ time;
	$("#ap_highserch").window('close');

	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!highranksearch",
				data : query_content,
				success : function(json) {
					$("#mac").attr("value", '');
					closeLoadDataGif();
					var htmlStr = "";
					htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
					htmlStr += " <tr style='background:#d4e1ee;'>";
					htmlStr += " <td width='12%'><div align='center'>AP名称</div></td>";
					htmlStr += " <td width='10%'><div align='center'>管理IP</div></td>";
					htmlStr += " <td width='10%'><div align='center'>AP MAC</div></td>";
					htmlStr += " <td width='18%'><div align='center'>商家</div></td>";
					htmlStr += " <td width='18%'><div align='center'>区域</div></td>";
					htmlStr += " <td width='15%'><div align='center'>安装位置</div></td>";
					htmlStr += " <td width='10%'><div align='center'>SSID</div></td>";
					htmlStr += " <td width='5%'><div align='center'>操作</div></td>";
					htmlStr += "</tr>";
					for ( var i = 0; i < json.length; i++) {
						if (json[i].onLine) {
							htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("
									+ json[i].id + ");>"
						} else {
							htmlStr += "<tr style='background:#ded8df'  ondblclick=attrLook("
									+ json[i].id + ");>"
						}
						htmlStr += "<td width='12%'><div align='center'>"
								+ json[i].name + "</div></td>";
						htmlStr += "<td width='10%'><div align='center'>"
								+ json[i].ipaddr + "</div></td>";
						htmlStr += "<td width='10%' ><div align='center'>"
								+ json[i].mac + "</div></td>";
						htmlStr += "<td width='18%'><div align='center' >"
								+ "<a href='javascript:merchantlook("
								+ json[i].id
								+ ");'>"
								+ ((json[i].merchant == null || json[i].merchant == '') ? ''
										: (json[i].merchant.length > 10 ? json[i].merchant
												.substring(0, 10)
												+ "..."
												: json[i].merchant)) + "</a>"
								+ "</div></td>";
						htmlStr += "<td width='18%'><div align='center'>"
								+ ((json[i].province == '北京市') ? ''
										: json[i].province) + "" + json[i].city
								+ "" + json[i].district + "" + "</div></td>";
						htmlStr += "<td width='15%'><div align='left'  title='"
								+ json[i].detail
								+ "'>"
								+ ((json[i].detail == null) ? ''
										: (json[i].detail.length > 10 ? json[i].detail
												.substring(0, 10)
												+ "..."
												: json[i].detail))
								+ "</div></td>";
						htmlStr += "<td width='10%'><div align='center'>"
								+ ((json[i].ssid == null) ? '' : json[i].ssid)
								+ "</div></td>";
						if (json[i].onLine) {
							htmlStr += "<td width='5%'><div align='center'>"
									+ " <a href=\"javascript:ap_setAll('"
									+ json[i].id + "','" + json[i].mac + "','"
									+ json[i].merchant_id + "');\">设置</a>"
									+ "</div></td>";
						} else {
							htmlStr += "<td width='5%'><div align='center'>"
									+ "--" + "</div></td>";
						}
						htmlStr += "</tr>";
					}
					htmlStr += "</table>";
					$("#data_table").html(htmlStr);
				},
				error : function() {
					closeLoadDataGif();
					if (!confirm('没有查询到您需要的数据!'))
						return;
				}
			});
}
// 监控高级查询
function highqueryMonitor() {
	openLoadDataGif();
	$("#scroll_top").val(0);
	$("#scroll_num").val(0);
	$("#up_div").scrollTop(0);
	var apname = $("#apname").val();
	var mac = $("#mac").val();
	var ipaddr = $("#ipaddr").val();
	var hardware_ver = $("#hardware_ver").val();
	var software_ver = $("#software_ver").val();
	var ssid = $("#ssid").val();
	var province = $("#province").val();
	var city = $("#city").val();
	var district = $("#district").val();
	var starttime = $("#starttime").val();
	var endtime = $("#endtime").val();
	var merchant = $("#merchant").val();
	var time = $("#time").val();
	$("#ap_highserch").window('close');
	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!highranksearch",
				data : "name=" + apname + "&mac=" + mac + "&ipaddr=" + ipaddr
						+ "&hardware_ver=" + hardware_ver + "&software_ver="
						+ software_ver + "&ssid=" + ssid + "&merchant="
						+ merchant + "&province=" + province + "&city=" + city
						+ "&district=" + district + "&starttime=" + starttime
						+ "&endtime=" + endtime + "&time=" + time,
				success : function(json) {
					closeLoadDataGif();
					var htmlStr = "";
					htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
					htmlStr += " <tr style='background:#d4e1ee;'>";
					htmlStr += " <td width='12%'><div align='center'>AP名称</div></td>";
					htmlStr += " <td width='8%'><div align='center'>MAC地址</div></td>";
					htmlStr += " <td width='5%'><div align='center'>CPU负载</div></td>";
					htmlStr += " <td width='8%'><div align='center'>内存占用</div></td>";
					htmlStr += " <td width='8%'><div align='center'>运行时间</div></td>";
					htmlStr += " <td width='12%'><div align='center'>商家</div></td>";
					htmlStr += " <td width='15%'><div align='center'>区域</div></td>";
					htmlStr += " <td width='12%'><div align='center'>详细位置</div></td>";
					htmlStr += " <td width='4%'><div align='center'>操作</div></td>";
					htmlStr += " <td width='4%'><div align='center'>查看</div></td>";
					htmlStr += "</tr>";
					for ( var i = 0; i < json.length; i++) {
						if (json[i].onLine) {
							htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("
									+ json[i].id + ");>"
						} else {
							htmlStr += "<tr style='background:#ded8df' ondblclick=attrLook("
									+ json[i].id + ");>"
						}
						htmlStr += "<td width='12%'><div align='center'>"
								+ json[i].name + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].mac + "</div></td>";
						htmlStr += "<td width='5%'><div align='center'>"
								+ json[i].sys_upload + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].sys_memfree + "</div></td>";
						htmlStr += "<td width='8%'><div align='center'>"
								+ json[i].uptime + "</div></td>";
						htmlStr += "<td width='12%'><div align='center' >"
								+ "<a href='javascript:merchantlook("
								+ json[i].id
								+ ");'>"
								+ ((json[i].merchant == null || json[i].merchant == '') ? ''
										: (json[i].merchant.length > 10 ? json[i].merchant
												.substring(0, 10)
												+ "..."
												: json[i].merchant)) + "</a>"
								+ "</div></td>";
						htmlStr += "<td width='15%'><div align='center'>"
								+ ((json[i].province == '北京市') ? ''
										: json[i].province) + "" + json[i].city
								+ "" + json[i].district + "" + "</div></td>";
						htmlStr += "<td width='12%'><div align='left'   title='"
								+ json[i].detail
								+ "'>"
								+ ((json[i].detail == null) ? ''
										: (json[i].detail.length > 10 ? json[i].detail
												.substring(0, 10)
												+ "..."
												: json[i].detail))
								+ "</div></td>";
						if (json[i].onLine) {
							htmlStr += "<td width='4%'><div align='center'>"
									+ " <a href=\"javascript:ap_setAll('"
									+ json[i].id + "','" + json[i].mac + "','"
									+ json[i].merchant_id + "');\">设置</a>"
									+ "</div></td>";
							htmlStr += "<td width='4%'><div align='center'><a href='#' onclick='lookFlow(\""
									+ json[i].mac + "\");'>查看</a></div></td>";
						} else {
							htmlStr += "<td width='4%'><div align='center'>"
									+ "--" + "</div></td>";
							htmlStr += "<td width='4%'><div align='center'>"
									+ "--" + "</div></td>";
						}
						htmlStr += "</tr>";
					}
					htmlStr += "</table>";
					$("#data_table").html(htmlStr);
				},
				error : function() {
					closeLoadDataGif();
					if (!confirm('没有查询到您需要的数据!'))
						return;
				}
			});
}

function initprovince() {
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!initProvince",
		data : "",
		success : function(json) {
			var pro = $("#province");
			pro.empty();
			pro.append("<option value=''>选择省份</option>")
			for ( var i = 0; i < json.length; i++) {
				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				pro.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
// 初始化
function init() {
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!init",
		data : "",
		success : function(json) {
			var pro = $("#province");
			pro.empty();
			pro.append("<option value=''>选择省份</option>");
			for ( var i = 0; i < json.length; i++) {
				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				pro.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
// 初始化市
function initcity() {
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!init",
		data : "",
		success : function(json) {
			var city = $("#city");
			for ( var i = 0; i < json.length; i++) {
				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				city.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
// 初始化地区
function initdistrict() {
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!init",
		data : "",
		success : function(json) {
			var district = $("#district");
			for ( var i = 0; i < json.length; i++) {
				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				district.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
// 根据省代码查找市
function findCityByCode(obj) {
	var code = obj.value;
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!findCityByCode",
		data : "code=" + code,
		success : function(json) {
			var city = $("#city");
			city.empty();
			city.append("<option value=''>选择城市</option>");
			for ( var i = 0; i < json.length; i++) {
				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				city.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
// 根据市代码查找区
function findDistrictByCode(obj) {
	var code = obj.value;
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "apmController!findDistrictByCode",
		data : "code=" + code,
		success : function(json) {
			var district = $("#district");
			district.empty();
			for ( var i = 0; i < json.length; i++) {

				var option = $("<option value=" + json[i].code + ">"
						+ json[i].name + "</option>");
				district.append(option);
			}
		},
		error : function() {
			if (!confirm('你的访问超时，请重新登陆!'))
				return;
			window.location = '/denglu.jsp';
		}
	});
}
window.onload = function() {
	document.getElementById("background").style.width = document.body.offsetWidth
			+ "px";
	document.getElementById("background").style.height = (document.body.offsetHeight + document.body.scrollHeight)
			+ "px";
	document.getElementById("background").childNodes[1].style.top = "200px";
	document.getElementById("background").childNodes[1].style.left = (document.body.offsetWidth - 90)
			/ 2 + "px";
	document.getElementById("background").childNodes[1].style.visibility = "hidden";
	document.getElementById("background").style.visibility = "hidden";
};
function openLoadDataGif() {
	document.getElementById("background").childNodes[1].style.visibility = "visible";
	document.getElementById("background").style.visibility = "visible";
}

function closeLoadDataGif() {
	document.getElementById("background").childNodes[1].style.visibility = "hidden";
	document.getElementById("background").style.visibility = "hidden";
}
function attrLook(id) {
	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!searchApbyid",
				data : "id=" + id,
				success : function(json) {
					var htmlStr = "";
					htmlStr += "<div class='apmess'  style='border:none;height:370px;'>";
					htmlStr += " <ul>";
					for ( var i = 0; i < json.length; i++) {
						htmlStr += " <li style='margin-left:5px;'>";
						htmlStr += "<label>名称</label><input name='' type='text' value="
								+ ((json[i].name == '') ? '暂无' : json[i].name)
								+ " Readonly /></li>";
						htmlStr += "<li><label>MAC</label><input name='' type='text' value="
								+ ((json[i].mac == '') ? '暂无' : json[i].mac)
								+ "  Readonly /></li>";
						htmlStr += "<li style='margin-left:5px;'><label>管理IP</label><input name='' type='text' value="
								+ ((json[i].ipaddr == '') ? '暂无'
										: json[i].ipaddr)
								+ "    Readonly /></li>";
						htmlStr += "<li><label>网关IP</label><input name='' type='text' value="
								+ ((json[i].gwip == '') ? '暂无' : json[i].gwip)
								+ "  Readonly /></li>";
						htmlStr += "<li  style='margin-left:5px;'><label>经度</label><input name='' type='text' value="
								+ ((json[i].lat == '') ? '暂无' : json[i].lat)
								+ " Readonly/></li>";
						htmlStr += "<li><label>纬度</label><input name='' type='text' value="
								+ ((json[i].long1 == '') ? '暂无' : json[i].long1)
								+ " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;'><label>状态</label><input name='' type='text' value="
								+ ((json[i].onLine == true) ? '在线' : '离线')
								+ "   Readonly /></li>";
						htmlStr += "<li><label>入网时间</label><input name='' type='text' value="
								+ ((json[i].created_at == '') ? '暂无'
										: json[i].created_at)
								+ " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;'><label>硬件版本</label><input name='' type='text' value="
								+ ((json[i].hardware_ver == '') ? '暂无'
										: json[i].hardware_ver)
								+ " Readonly/></li>";
						htmlStr += "<li><label>软件版本</label><input name='' type='text' value="
								+ ((json[i].software_ver == '') ? '暂无'
										: json[i].software_ver)
								+ " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;'><label>区域</label><input name='省' type='text' value="
								+ ((json[i].province == '北京市') ? ''
										: json[i].province)
								+ ""
								+ json[i].city
								+ "" + json[i].district + "  Readonly/></li>";
						htmlStr += "<li ><label>安装位置</label><input name='' type='text' value="
								+ ((json[i].detail == '') ? '暂无'
										: json[i].detail) + " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;'><label>认证方式</label><input name='' type='text' value="
								+ ((json[i].auth_type == '') ? '暂无'
										: json[i].auth_type)
								+ " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;'><label>认证间隔</label><input name='' type='text' value="
								+ ((json[i].time_limit == '') ? '暂无'
										: json[i].time_limit + "(分钟)")
								+ " Readonly/></li>";
						htmlStr += "<li style='margin-left:5px;width:580px;' ><label>商户名称</label><input name='' type='text' value="
								+ ((json[i].merchant == '') ? '暂无'
										: json[i].merchant)
								+ " style='width:500px;'  Readonly /></li>";
						htmlStr += "<li style='margin-left:19px;'><a href='javascript:showConf("
								+ json[i].id
								+ ");'>其他信息</a></li>";

					}
					htmlStr += "</ul>";
					htmlStr += "</div>";
					$("#attrLook").html(htmlStr);
					$("#ap_attrLook").window('open');
				},
				error : function() {
					if (!confirm('该AP没有详细信息'))
						return;
				}
			});
	
	ipmacconfshow(id);

}
function merchantlook(id) {
	$
			.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!querybyid",
				data : "id=" + id,
				success : function(json) {
					var htmlStr = "";
					for ( var i = 0; i < json.length; i++) {
						htmlStr += "<li><label>商户名称</label><input name='' type='text' value='"
								+ ((json[i].merchant == '') ? '暂无'
										: json[i].merchant)
								+ "' Readonly/></li>";
						htmlStr += "<li><label>联系人</label><input name='' type='text' value="
								+ ((json[i].mname == '') ? '暂无' : json[i].mname)
								+ " Readonly/></li>";
						htmlStr += "<li><label>手机</label><input name='' type='text' value="
								+ ((json[i].phonenum == '') ? '暂无'
										: json[i].phonenum)
								+ " Readonly/></li>";
						htmlStr += "<li><label>电话</label><input name='' type='text' value="
								+ ((json[i].telephonenum == '') ? '暂无'
										: json[i].telephonenum)
								+ " Readonly/></li>";
						htmlStr += "<li><label>邮箱</label><input name='' type='text' value="
								+ ((json[i].email == '') ? '暂无' : json[i].email)
								+ " Readonly/></li>";
						htmlStr += "<li><label>微信</label><input name='' type='text' value="
								+ ((json[i].weixin == '') ? '暂无'
										: json[i].weixin) + " Readonly/></li>";
					}
					$("#merchantlook").html(htmlStr);
					$("#ap_merchantlook").window('open');
				},
				error : function() {
					if (!confirm('该商户没有详细信息'))
						return;
				}
			});
}

var a1 = 0, a2 = 0;
/** 查看流量 */
function lookFlow(mac) {
	window.parent.open_lookFlow_window(mac);
}

function ipmacconfshow(id) {
	// 回显
	$
			.ajax({
				type : "POST",
				dataType : "json",
				cache : false,
				url : "apmController!ap_TabShow",
				data : "&$id=" + id + "&timestamp=" + new Date().getTime(),
				success : function(data) {

					for ( var x = 0; x < data.length; x++) {
						var obj = data[x];
						if (obj.setProtocolList.length > 0) {
							$("#heartbeat_show").val(
									obj.setProtocolList[0].checkinterval);
							$("#authenticate_show").val(
									obj.setProtocolList[0].authinterval);
							$("#offline_judge_show").val(
									obj.setProtocolList[0].httpmaxconn);
							$("#visitor_num_show").val(
									obj.setProtocolList[0].clienttimeout);
						}
						if (obj.whitelistList.length > 0) {
							var ip = obj.whitelistList[0].publicip;
							var array = ip.split(";");
							var allIp = "";
							for ( var x = 0; x < array.length; x++) {
								allIp += array[x] + ";\n"
							}
							$("#whitelist_ip_show").val(allIp);
						}
						if (obj.whitelistList_mac.length > 0) {
							var ip = obj.whitelistList_mac[0].publicip;
							var array = ip.split(";");
							var allIp = "";
							for ( var x = 0; x < array.length; x++) {
								allIp += array[x] + ";\n"
							}
							$("#whitelist_ip_mac_show").val(allIp);
						}

					}
				}
			});
}

function showConf(id){
		$("#ap_TabDiv_show_whiteip").window('open');
		$("#ap_whitelist_show").show();
}