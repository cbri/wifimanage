<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/upgrade.dialog.css" />
<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/source/js/ap/scroll_mon.js"></script>
<script type="text/javascript">
var pcode;
function onClickLoad(event, treeId, treeNode){
	openLoadDataGif();
	query_content = "";
	$("#scroll_top").val(0);
	$("#scroll_num").val(0);
	$("#up_div").scrollTop(0);
	var code= treeNode.id;
		$.ajax({
					type : "POST",
					dataType : "json",
					url : "apmController!querybycode",
					data : "code="+code,
					success : function(json) {
			closeLoadDataGif();
						pcode= code;
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
							if(json[i].onLine){
								htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("+json[i].id+");>"
							}else{
								htmlStr += "<tr style='background:#ded8df' ondblclick=attrLook("+json[i].id+");>"
							}
							htmlStr += "<td width='8%'><div align='center'>"
									+ json[i].name
									+ "</div></td>";
							htmlStr += "<td width='8%'><div align='center'>"
									+ json[i].mac
									+ "</div></td>";
							htmlStr += "<td width='5%'><div align='center'>"
									+ json[i].sys_upload
									+ "</div></td>";
							htmlStr += "<td width='8%'><div align='center'>"
									+ json[i].sys_memfree
									+ "</div></td>";
							htmlStr += "<td width='8%'><div align='center'>"
									+ json[i].uptime
									+ "</div></td>";
							htmlStr += "<td width='12%'><div align='center' >"
									+ "<a href='javascript:merchantlook("+json[i].id+");'>"
									+ ((json[i].merchant==null || json[i].merchant=='')?'':(json[i].merchant.length>10?json[i].merchant.substring(0,10)+"...":json[i].merchant))+ "</a>"
									+ "</div></td>";
							htmlStr += "<td width='15%'><div align='center'>"
									+ ((json[i].province=='北京市')?'':json[i].province)+""+json[i].city+""+json[i].district+""
									+ "</div></td>";
							htmlStr += "<td width='12%'><div align='left'   title='"+json[i].detail+"'>"
									+ ((json[i].detail==null)?'':(json[i].detail.length>10?json[i].detail.substring(0,10)+"...":json[i].detail))
									+ "</div></td>";
							if(json[i].onLine){
								htmlStr += "<td width='4%'><div align='center'>"
										+ " <a href=\"javascript:ap_setAll('"+json[i].id+"','"+json[i].mac+"','"+json[i].merchant_id+"');\">设置</a>"
										+ "</div></td>";
								htmlStr += "<td width='4%'><div align='center'><a href='#' onclick='lookFlow(\""+json[i].mac+"\");'>查看</a></div></td>";
								}else{
									htmlStr += "<td width='4%'><div align='center'>"
										+ "--"
										+ "</div></td>";
									htmlStr += "<td width='4%'><div align='center'>"
										+ "--"
										+ "</div></td>";
									}
							
							htmlStr += "</tr>";
						}
						htmlStr += "</table>";
						$("#data_table").html(htmlStr);
					},
					error : function() {
						closeLoadDataGif();
						if (!confirm('该地区无数据显示,请重新选择'))
							return;
					}
				});
		if(code!=null){
			$.ajax({
		  		type: "POST",
		  	 	dataType:"json",   
				   url:"apmController!initProvince", 
				   data:"code="+code,
				   success: function(json){
									var pro =$("#province");
										pro.empty();
										pro.append("<option value=''>选择省份</option>")
									 for(var i =0; i<json.length ;i++){
										var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
										pro.append(option);
										 }
				   },
				   error:function(){  
					   
						    return;
					 } 
					});
		}
	}
</script>
<script type="text/javascript" src="${ctx}/source/js/ap/tree.js"></script>
<script type="text/javascript" src="${ctx}/source/js/ap/query.js"></script>
<script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="${ctx}/source/js/ap/apUpgradeControl.js"></script>
<script type="text/javascript"> var level = ${sessionScope.user.level}; </script>
<script type="text/javascript"> var parent_userid = ${sessionScope.user.parent_userid};</script>
<script>
        $(document).ready(function () {
            $('.tree_1_list').hover(function () {
                var t = parent.document.getElementById("dataSource_manager");
                var p_code = t.options[t.selectedIndex].value;
                var obj = $(this);
                if(p_code == '0'){
                	$.getJSON("PositionController!getTreeData", null, function(data){
						var zNodes = $.parseJSON(data.toString());
						// 测试
						$.fn.zTree.init($("#menuTree"), setting, zNodes);
						obj.stop().animate({ "right": 0 }, 500, function () {});
					});
                }else{
	            	$.getJSON("PositionController!getTreeDataById", "id="+p_code, function(data){
						var zNodes = $.parseJSON(data.toString());
						// 测试
						$.fn.zTree.init($("#menuTree"), setting, zNodes);
						obj.stop().animate({ "right": 0 }, 500, function () {});
					});
				}
            }, function () {
                $(this).stop().animate({ "right": -360 }, 500, function () {
                });
            });

    		if(level==0){
            	init();
            }else if(level==1){
            	$("#province").hide();
            	initcity();
            }else if(level==2){
            	$("#province").hide();
            	$("#city").hide();
            	initdistrict();
                }
        });
        //获取选择行ID 根据ID查询ap信息
    
    </script>
<style type="text/css">
ul.nav_ul {
	border-width: 0px;
	margin: 0px;
	padding: 0px;
	text-indent: 0px;
}
.background {
	display: block;
	opacity: 0.6;
	filter: alpha(opacity = 40);
	background: while;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 2000;
	background-color: #fff;
	text-align: center;
}
-->
</style>
</head>
<body>
<!--查看商户-->
			<div id="ap_merchantlook" class="easyui-window" title="商户信息" data-options="iconCls:'icon-search',modal:true,closed:true,top:'99px'" style="height:280px;width:400px;padding:10px;background-color: #F0FFF0;">
	      		<div id="merchantlook" style="border:none;" class="merch">
		      
				</div>
			</div>
		
	<!--查看商户-->
	<!------------进度条开始----------->
	<div id="background" class="background">
			<img alt="" src="${ctx}/source/images/circular.gif"
				style="position: absolute;visibility: hidden">
		</div>
	<!------------进度条结束----------->
	<!------------右侧 树菜单 快捷停靠----------->
	<div class="tree_1_list">
		<span class="tree_1_hover"><img
			src="${ctx}/source/images/share.png" />
		</span>
		<div class="tree_1_cont" style="overflow: auto;">
			<ul class="ztree"  id="menuTree">
			</ul>
		</div>
	</div>
	<div class="AP_wrap">
		<div class="AP_title">
			<ul>
				<li class="rr"><a href="#">首页</a>
				</li>
				<li class="rr"><a href="#">APP管理</a>
				</li>
				<li><a href="${ctx}/apmController!queryapMonitor">APP监控</a>
				</li>
			</ul>
		</div>
		<div class="AP_used">
			<div class="AP_search">
				<div class="AP_inpu_search">
					<input type="text" placeholder="请输入MAC地址进行搜索" id="searchbymac"/> <span  onclick="queryMobymac();">搜索</span>
				</div>
				<span onclick="mostquery();">高级搜索</span>
				<input type="Hidden" id="hiddencode"/>
			</div>
			<!-- 高级搜索开始 -->
				<div id="ap_highserch" class="easyui-window" title="高级搜索" data-options="iconCls:'icon-search',modal:true,closed:true,top:'99px'" style="height:430px;width:656px;padding:10px;background-color: #F0FFF0;">
	      			<div class="search_cont" id="ap_serch" style="border:none;">
					<ul>
						
						<li style="margin-left:10px;">
						<label>名称</label>
						 <input type="text" name="apname" id="apname" /></li>
						 <li><label>MAC</label> 
						<input type="text" name="mac" id="mac"/></li>
						<li style="margin-left:10px;"><label>硬件版本</label> 
						<input type="text" name="hardware_ver" id="hardware_ver" /></li>
						<li><label>软件版本</label> 
						<input type="text" name="software_ver" id="software_ver"></li>
						<li style="margin-left:10px;">
						<label>管理IP</label> 
						<input type="text" name="ipaddr" id="ipaddr" />
						</li>
						<li><label>ssid</label>
						<input type="text" name="ssid" id="ssid"/></li>
						<li style="margin-left:10px;">
						<label for="textfield">入网时间</label> 
						<input type="text" name="starttime" id="starttime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'starttime\')}'})"/></li>
						<li><label for="textfield">到</label> 
						<input type="text" name="endtime" id="endtime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'endtime\')}'})"/></li>
						<li style="margin-left:10px;">
						<label>商户名称</label>
						<input type="text" name="merchant" id="merchant"/></li>
						<li><label>状态</label> 
						<select style="width:188px;high:24px;" id="time" name="time">
									<option value="">选择状态</option>
									<option value="0">在线</option>
									<option value="1">离线</option>
							</select></li>
						
						<li style="width:100%; margin-left:10px;"><label>区域</label> <span class="li_ss"> 
							<select style="margin-left:0;" id="province" name="province" onchange="findCityByCode(this)">
									<option value="">选择省份</option>
							</select> 
							<select id="city" name="city" onchange="findDistrictByCode(this)">
									<option value="">选择城市</option>
							</select> 
							<select id="district" name="district">
									<option value="">选择地区</option>
							</select> </span></li>
						<li style="width:100%" class="btn">
						<span style="background:#f8571a;margin-right:52px;"  onclick="highqueryMonitor()">查询</span>
						</li>
						</ul>
					</div>
				</div>
			<!-- 高级搜索结束 -->
		</div>
	<!--查看开始-->
		<div id="ap_attrLook" class="easyui-window" title="AP信息" data-options="iconCls:'icon-search',modal:true,closed:true,top:'50px'" style="height:385px;width:630px;padding:10px;background-color: #F0FFF0;">
	      		<div id="attrLook" style="border:none;">
		      
				</div>
			</div>
		
	<!--查看结束-->
  	
		<div style="height:450px;width: 100%;overflow-y:auto;"id="up_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="data_table" class="AP_table">
				<tr style="background:#d4e1ee;">
					<td width="8%"><div align="center">MAC地址</div>
					</td>
					<td width="12%"><div align="center">创建时间</div>
					</td>
					<td width="12%"><div align="center">更新时间</div>
					</td>
					<td width="8%"><div align="center">软件</div>
					</td>
					<td width="8%"><div align="center">拥有者</div>
					</td>
					<td width="12%"><div align="center">在线时间</div>
					</td>
					<td width="12%"><div align="center">插件</div>
					</td>
					
				</tr>
				<c:forEach items="${router}" var="apm" >
					<tr style="background:#d5e8e2;"ondblclick="attrLook(${apm.id})" >
	                <td  width="8%"><div align="center">${apm.mac}</div></td>
	                <td  width="10%"><div align="center">${apm.created_at}</div></td>
	                <td width="10%"><div align="center">${apm.updated_at}</div></td>
	                <td width="8%"><div align="center">${apm.software}</div></td>
	                <td width="8%"><div align="center">${apm.factory}</div></td>
	                <td width="10%"><div align="center">${apm.last_seen}</div></td>
	                <td width="5%"><div align="center"><a href="${ctx}/app!initRouterPluginManage.do?id=${apm.id}" style="text-decoration:blink;">查看</a></div></td>
	              </tr>
			      
	              
	              </c:forEach> 
			</table>
		</div>

	</div>
		</div>
    </div>	
    <input type="hidden" id="scroll_top" value="0"/>
	<input type="hidden" id="scroll_num" value="0"/>
</body>
</html>
