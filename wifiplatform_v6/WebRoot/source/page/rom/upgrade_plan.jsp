<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java"
	import="com.sinosoft.rommanage.bean.UpgradePlan"%>
<%@ page language="java"
	import="com.sinosoft.rommanage.bean.UpgradePlanApRel"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title></title>
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/upgrade.dialog.css" />
<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">var pageNum = 0;var scrollTop = 0;</script>
<script type="text/javascript">var account_name = "'"+${sessionScope.user.name}+"'";</script>
<script type="text/javascript" src="${ctx}/source/js/rom/rom_tree.js"></script>
<script type="text/javascript" src="${ctx}/source/js/rom/upgrade_plan.js"></script>
<script type="text/javascript" src="${ctx}/source/js/rom/scroll.js"></script>
<script type="text/javascript">
	   	function lookApMessage(id){
	   		$.post("upgrade!lookApMessage.do","id="+id,function(res){
	   			var data = eval(res);
	   			$("#lookApMessage_table").empty();
	   			$("#lookApMessage_table").append("<tr style='background:#d4e1ee;'>"+
	                "<td width='20%'><div align='center'>AP名称</div></td>"+
	                "<td width='20%'><div align='center'>MAC</div></td>"+
	                "<td width='25%'><div align='center'>商家</div></td>"+
	                "<td width='25%'><div align='center'>区域</div></td>"+
	            "</tr>");
	   			for(var i = 0;i<data.length;i++){
	   				$("#lookApMessage_table").append("<tr>"+
	   				"<td>"+data[i].apname+"</td>"+
	   				"<td>"+data[i].mac+"</td>"+
	   				"<td title='"+data[i].contacts+"'>"+(data[i].contacts.length>10?data[i].contacts.substring(0,10)+"...":data[i].contacts)+"</td>"+
	   				"<td>"+data[i].pname+data[i].cname+data[i].dname+"</td>"+
	   				"</tr>");
	   			}
	   			$("#lookApMessage_window").window("open");
	   		},"json");
	   	}
   </script>
<style type="text/css">
.AP_quicksearch {
	width: 292px;
	height: 44px;
	margin-top: 8px;
	float: right;
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
	visibility: hidden;
}
.tip-yellow td{
	border:0px;
}
.tip-yellow tr{
	height: auto;
}
.tip-yellow table{
	border:0px;
}
.AP_used{
	line-height:0px;
}
.AP_quicksearch_time input{
	border: #D9E0E7 1px solid;
	background-color: #E8EDF2;
	height: 32px;
}
</style>
</head>
<body onkeydown="esc(event.keyCode)">
	<div class="AP_wrap">
		<div class="AP_title">
			<ul>
				<li class="rr"><a href="#">首页</a>
				</li>
				<li class="rr"><a href="#">AP升级</a>
				</li>
				<li><a href="#">升级计划</a>
				</li>
			</ul>
		</div>
		<div class="AP_used">
			<img src="${ctx}/source/images/chuangjian.png"
				onclick="openCreateWindow()" /> <img
				src="${ctx}/source/images/delet.png"
				onclick="if(confirm('确认删除选中计划？')){deleteUpgradePlan();}" />
			<div class="AP_quicksearch">
				<div class="AP_inpu_search">
					<input placeholder="请输入名称进行搜索" id="search_text" type="text">
					<span onclick="search()">搜索</span>
				</div>
			</div>
			<div class="AP_quicksearch_time">
				  <input  placeholder="请输入截止时间" name="set_time" id="end_time"  type="text" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'start_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d'})" class="Wdate" />
			</div>
			<div class="AP_quicksearch_time">
			      <input placeholder="请输入起始时间" name="set_time" id="start_time"  type="text" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'end_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d'})" class="Wdate" />
			</div>
		</div>
		<div id="background" class="background">
			<input type="image" id="background_image" src="${ctx}/source/images/circular.gif" style="position: absolute;top: 200px;"/>
		</div>
		<div style="overflow: auto;width: 100%;height: 500px;" id="up_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="AP_table" id="upgrade_table">
				<tr style="background:#d4e1ee;">
					<td width="7%"><div align="center">
							<input type="checkbox" />
						</div>
					</td>
					<td width="11%"><div align="center">计划名称</div>
					</td>
					<td width="8%"><div align="center">AP信息</div>
					</td>
					<td width="15%"><div align="center">计划执行时间</div>
					</td>
					<td width="15%"><div align="center">实际执行时间</div>
					</td>
					<td width="12%"><div align="center">审核状态</div>
					</td>
					<td width="12%"><div align="center">创建人</div>
					</td>
				</tr>
				<%
              	List<UpgradePlan> upGradePlans = (List<UpgradePlan>)request.getAttribute("upGradePlans");
               	for(int i = 0;i<upGradePlans.size();i++){
              		UpgradePlan upgrade = upGradePlans.get(i);
              %>
				<tr
					ondblclick="editUpGradePlans(<%=upgrade.getId()%>,<%=upgrade.getIsSelfCreate()%>,event)"
					id="editUpGradePlans_<%=upgrade.getId()%>">
					<td align="center"><input type="checkbox"
						<%if(upgrade.getIsSelfCreate() != 1 || upgrade.getIsexecute() == 1){%> disabled="disabled" <%}%> />
						<input type="hidden" value="<%= upgrade.getId()%>" /> <input
						type="hidden" value="<%= upgrade.getIsSelfCreate()%>" /> <input
						type="hidden" value="<%= upgrade.getCheck_state()%>" /></td>
					<td align="center" title="<%= upgrade.getPlan_name()%>"><%= upgrade.getPlan_name()== null ? "":(upgrade.getPlan_name().length() > 10 ?upgrade.getPlan_name().subSequence(0, 10)+"...":upgrade.getPlan_name())%></td>
					<td align="center"><a
						href="javascript:lookApMessage(<%=upgrade.getId()%>);">查看</a></td>
					<td align="center"><%= upgrade.getExecute_time()%></td>
					<td align="center"><%= upgrade.getReal_time() == null ? "":upgrade.getReal_time()%></td>
					<%
	                	if(upgrade.getIsSelfCreate()== 1 && upgrade.getCheck_state() == 0){
	                %>
					<td align="center"><a href="#"
						onclick="verify(<%= upgrade.getId()%>,event,1)">审核</a>(未审核)</td>
					<%		
	                	}else if(upgrade.getIsSelfCreate()== 0 && upgrade.getCheck_state() == 0){
	                %>
					<td align="center"><span style="color: gray;">未审核</span>
					</td>
					<%		
	                	}else if(upgrade.getIsSelfCreate()== 1 && upgrade.getCheck_state() == 1){
	                		if(upgrade.getIsexecute() != 1){
	                %>
					<td align="center"><span style="color: gray;">已审核</span>(<a
						href="#" onclick="verify(<%= upgrade.getId()%>,event,0)">取消审核</a>)
					</td>
					<%	
	                		}else{
	                %>
					<td align="center"><span style="color: gray;">已审核</span>
					</td>
					<%		
	                		}
	                	}else{
	                %>
					<td align="center"><span style="color: gray;">已审核</span>
					</td>
					<%
	                	}
	                 %>
	                 <td align="center"><%= upgrade.getCreate_user()%></td>
					<%}
               %>
				
			</table>
		</div>
	</div>
	<div id="popue_div"
		style="float: right;visibility:hidden;position:absolute;
    			background-color:#BCD2E9;z-index: 9999;
    			overflow: auto;width: 190px;height: 200px;"
		onmouseover="divOnMouseover()" onmouseout="divOnMouseout()">
		<table id="popue_div_table"
			style="width: 170px;;height: auto;margin-top: 5px;margin-left: 10px;">
		</table>
	</div>
	<div id="upgrade_plan_window" class="easyui-window" title="新增计划"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width:820px;height:480px;padding:10px;background-color: #F0FFF0;">
		<div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'center',border:false"
				style="background-color: #F0FFF0;padding:10px;height:160px">
				<div class="wrap">
					<div class="top">
						<p style="border-bottom: 1px solid #95B8E7;">
							<span style="margin-left:20px;">计划名称</span><input type="text"
								id="plan_name" style="margin-left:55px;" /> <span
								style="margin-left:60px;">计划执行时间</span> <input name="set_time"
								id="plan_time" style="margin-left:44px;" type="text"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
								class="Wdate" />
					</div>
					<div class="left" style="overflow: auto;">
						<ul class="ztree" id="menuTree"></ul>
					</div>
					<div class="right">
						<div class="rr_left" style="overflow: auto;">
							<div class="search">
								<input type="text" id="searchLeftTable_text" /> <span
									onclick="searchLeftTable()">搜索</span> <input type="hidden"
									id="hidden_row_id" />
							</div>
							<table border="1" width="96%" id="ap_table_1" class="AP_table">
								<tr style="background:#d4e2ef">
									<td align="center" width="8%"><input type="checkbox"
										onclick="checkAll(0)" id="check_input_all" />
									</td>
									<td align="center" width="40%">MAC</td>
									<td align="center" width="52%">区域</td>
								</tr>
							</table>
						</div>
						<img src="${ctx}/source/images/sanjiao.png"
							style="margin-top:150px;" />
						<div class="rr_right">
							<div class="APzhi">选中AP数值</div>
							<div style="overflow: auto;">
								<table border="1" width="96%" "  class="AP_table"
									id="ap_table_2">
									<tr style="background:#d4e2ef">
										<td align="center"><input type="checkbox" />
										</td>
										<td align="center">MAC</td>
										<td align="center">区域</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div data-options="region:'south',border:false"
				style="background-color: #F0FFF0;text-align:center;padding:5px 0 0;height: 35px;">
				<span style="color: #f00;margin-right: 20px;" id="err_msg"></span> <a
					class="easyui-linkbutton" data-options="iconCls:'icon-ok'" href="#"
					onclick="javascript:saveGradePlan();" style="width:80px">确定</a> <a
					class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"
					href="javascript:void(0)"
					onclick="javascript:$('#upgrade_plan_window').window('close');"
					style="width:80px">取消</a>
			</div>
		</div>
	</div>
	<!-- 查询AP信息的弹出框 -->
	<%@include file="/source/page/rom/lookApMessage.jsp"%>
	<div id="divProgressbar"></div>
</body>
</html>
