<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
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
    <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">var pageNum = 0;var scrollTop = 0;</script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/rom/rom_log.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/rom/scroll_log.js"></script>
	<script type="text/javascript">
		var divOn = false;
		var arr = new Array();
		function divOnMouseover(event){
			divOn = true;
		}
		function divOnMouseout(event){
			divOn = false;
			setTimeout(function (){
				if(!divOn){
					var div = document.getElementById("popue_div");
					div.style.visibility="hidden";
					arr = new Array();
				}
			},200);
		}
	   	function popueError(obj,event,mac){
	   		setTimeout(function (){
	   			var div = document.getElementById("popue_div");
	   			if(arr.length != 0||div.style.visibility == 'visible'){
	   				return;
	   			}
		   		arr[0] = div;
		   		var x = obj.offsetLeft;
		   		var y = obj.offsetTop;
		   		var ele = obj.offsetParent;
		   		var sTop = document.getElementById("up_div").scrollTop;
		   		while(ele){
		   			x+=ele.offsetLeft;
		   			y+=ele.offsetTop;
		   			ele = ele.offsetParent;
		   		}
		   		y-=sTop;
		   		y=y+obj.offsetHeight;
		   		div.style.visibility="visible";
		   		div.style.top=y+"px";
		   		div.style.left=x+"px";
		   		//忘上面加内容
		   		$("#popue_div").html(mac);
	   		},200);
	   	}
	   	function hiddenPopueError(obj,event){
	   		setTimeout(function (){
		   		if(divOn){
		   			return;
		   		}
	   			var div = document.getElementById("popue_div");
	   			div.style.visibility="hidden";
	   			arr = new Array();
	   		},200);
	   		
	   	}
   </script>
</head>
<body onkeydown="esc(event.keyCode)">
    <div class="AP_wrap">
        <div class="AP_title">
            
            <ul>
                <li class="rr"><a href="#">首页</a></li>
                <li class="rr"><a href="#">AP升级</a></li>
                <li><a href="#">升级日志</a></li>
            </ul>
        </div>
        <div class="AP_used">
			<div class="AP_quicksearch">
				<div class="AP_inpu_search">
					<input placeholder="请输入名称进行搜索" id="searchbyname" type="text">
					<span onclick="search();">搜索</span>
				</div>
			</div>
			<div class="AP_quicksearch_time">
				  <input placeholder="请输入截止时间" name="set_time" id="end_time"  type="text" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'start_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d'})" class="Wdate" />
			</div>
			<div class="AP_quicksearch_time">
			      <input placeholder="请输入起始时间" name="set_time" id="start_time"  type="text" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'end_time\')}',dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d'})" class="Wdate" />
			</div>
		</div>
        <div style="overflow: auto;width: 100%;height: 400px;" id="up_div">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AP_table" id="data_table">
              <tr style="background:#d4e1ee">
                <td width="15%"><div align="center">计划名称</div></td>
                <td width="20%"><div align="center">实际执行时间</div></td>
                <!-- 
                <td width="15%"><div align="center">旧版本名称</div></td>
                <td width="15%"><div align="center">新版本名称</div></td>
                 -->
                <td width="15%"><div align="center">成功数</div></td>
				<td width="15%"><div align="center">失败数</div></td>
              </tr>
             <%
             	List<Map<String,Object>> romloglist = (List<Map<String,Object>>)request.getAttribute("romloglist");
             	for(int i = 0;i<romloglist.size();i++){
             		Map<String,Object> rll = romloglist.get(i);
             %>
             	<tr>
	                <td><div align="center" title="<%= rll.get("planname")%>">
	                <%
	                	Object plnameObj = rll.get("planname");
	                	if(plnameObj != null){
	                		if(plnameObj.toString().length() > 10){
	                %>
	                			<%=plnameObj.toString().subSequence(0, 10)+"..." %>
	                <%
	                		}else{
	                %>
	                			<%=plnameObj.toString()%>
	                <%		
	                		}
	                	}
	                 %>
					</div></td>
	                <td><div align="center"><%= rll.get("real_time")%></div></td>
	                <!-- 
	                <td><div align="center">${rll.pre_upgrade_ver}</div></td>
	                <td><div align="center">${rll.version_name}</div></td>
	                 -->
	                <td><div align="center"><span id="span_01_<%= rll.get("planid")%>"><%= rll.get("success_time")%></span></div></td>
	                <!-- onmouseover="popueError(this,event,'${rll.fail_reason}')" onmouseout="hiddenPopueError(this,event)" -->
	                <td><div align="center"><span id="span_02_<%= rll.get("planid")%>"><%= rll.get("fail_time")%></span><a href="javascript:open_upgrade_log_window(<%= rll.get("planid")%>);">【查看详细】</a></div></td>
               </tr>
             <%
             	}
              %>
            </table>
            </div>
    </div>
    <div id="popue_div" style="float: right;visibility:hidden;position:absolute;
    			background-color:#BCD2E9;z-index: 9999;
    			overflow: auto;width: 190px;height: 200px;" onmouseover="divOnMouseover()" onmouseout="divOnMouseout()">
	</div>
	<%@include file="/source/page/rom/upgrade_log_detail.jsp"%>
	<div id="background" class="background">
			<img alt="" src="${ctx}/source/images/circular.gif"
				style="position: absolute;visibility: hidden">
		</div>
</body>
</html>
