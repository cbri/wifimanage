<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>云Wifi管理平台</title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/index.css" />
    <link rel="stylesheet" type="text/css" href="${ctx}/source/css/grey.css">
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
    <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/load.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/iframe.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/modify.password.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/highcharts.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/exporting.js"></script>
	<script type="text/javascript">
		/**切库操作*/
		function dataSourceChange(ev){
			var current_dataSource = $("#dataSource_manager option:selected").val();
			$.ajax({
				type : "POST",
				dataType : "json",
				url : "apmController!querybycode",
				data : "code="+current_dataSource,
				success : function(json) {
				},
				error : function() {
				if (!confirm('该地区没有数据，请重新选择!'))
					return;
				
				}
			});
			document.getElementById('indexFrame').contentWindow.onClickLoad(ev, -1, {'id':current_dataSource});
		};
		/**清掉AP监控，流量>>查看的定时器*/
		function clear_timeInterval(){
			if(document.getElementById('indexFrame').contentWindow.timeInterval != null && 
					document.getElementById('indexFrame').contentWindow.timeInterval != 'undefined'){
				clearInterval(document.getElementById('indexFrame').contentWindow.timeInterval);
			}
		}
		function open_lookFlow_window(mac){
				var hidden_mac = $("#hidden_mac").val();
				//如果隐藏mac和当前要弹出的mac相同时，应该直接弹出，不再清掉定时器，否则清掉定时器
				var index = 1;
				if(hidden_mac != ''){
					if(hidden_mac == mac){
						$("#lookFlow_window").window("open");
						return;
					}else{
						//清掉定时器
						clearInterval(timeInterval);
					}
				}
				$("#hidden_mac").val(mac);
			    $.get("apmController!lookApFlow.do","mac="+mac,function(data){
			    	//时间
			    	var x = (new Date()).getTime();
			    	var chart = initChart();
			    	//上行流量
				    var series1 = chart.series[0];
				    //下行流量
				    var series2 = chart.series[1];
				    a1 = parseInt(data.incoming);
				    a2 = parseInt(data.outgoing);
				    $("#lookFlow_window").window("open");
			    	//将打开的window放入缓存中
			    	timeInterval = setInterval(function() {
			        	$.get("apmController!lookApFlow.do","mac="+mac,function(data){
			        	    series1 = chart.series[0];
			        	    series2 = chart.series[1];
			        		var x = (new Date()).getTime();
			        		series1.addPoint([x, parseInt(data.outgoing)-a1], true, true);
			            	series2.addPoint([x, parseInt(data.incoming)-a2], true, true);
			            	a1 = parseInt(data.incoming);
			            	a2 = parseInt(data.outgoing);
			        	},"JSON");
			        }, 100000);
				},"JSON");
			return;
		}
	</script>
  </head>
 <body scroll="no" style="overflow-x:hidden;overflow-y:hidden" onkeydown="closeModifyWindow(event.keyCode)">
    <div class="wrap">
        <div class="tt_title" style="height:10%">
            <div class="title">
            <img src="${ctx}/source/images/logo.png"  class="tt_img"/>
            <ul>
                <li><img src="${ctx}/source/images/exit_icon.png" style="margin-top:22px;"/><a href="login!outLogin.do" onclick="clear_timeInterval();">退出</a></li>
                <li><img src="${ctx}/source/images/password_icon.png"style="margin-top:20px;" /><a href="javascript:openModifyWindow();">修改密码</a></li>
           		<li style="width:auto;"><span style="color: white;margin-top:20px;margin-right: 20px;">欢迎您!  ${sessionScope.user.name}</span></li>
           		<li style="width:auto;"><span style="color: white;margin-top:20px;margin-right: 20px;">选择省份：
           				<select id="dataSource_manager" onchange="dataSourceChange(event);" style="border-radius: 2px;border: 1px solid #999;font-size:16px;font-family:微软雅黑;">
           					<c:forEach items="${provinces}" var="pro">
           						<c:if test="${sessionScope.user.pcode == pro.id}">
           							<option value="${pro.id}" selected="selected">${pro.name}</option>
           						</c:if>
           						<c:if test="${sessionScope.user.pcode != pro.id}">
           							<option value="${pro.id}" >${pro.name}</option>
           						</c:if>
           						
           					</c:forEach>
           				</select>
           				</span>
           		</li>
            </ul>
        </div>
        </div>
        
        
        <div class="nav_box">
              <ul id="nav">
                <li id="dashboard" class="click">
                    <i class="icon-home"><img src="${ctx}/source/images/1.png" /></i>
                    <a href="${ctx}/index!homePage.do"><span class="word_title">首页</span></a>
                    
                </li>
                <li id="resource">
                    <i class="icon-group"><img src="${ctx}/source/images/2.png" /></i>
                    <span class="word_title">AP管理</span><span class="selected"></span><span class="arrow open slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                   <ul class="s_box">
                      <li><a href="${ctx}/apmController!queryap"><span class="word_title">AP资源</span></a></li>
                      
                      <li><a href="${ctx}/apmController!queryapMonitor"><span class="word_title">AP监控</span></a></li>
                      <li><a href="${ctx}/apmController!queryApConfig"><span class="word_title">AP配置</span></a></li>  
                    </ul>
                </li>
                   <!--li id="yewu">
                    <i class="icon-cus"><img src="${ctx}/source/images/3.png" /></i>
                    <span class="word_title">业务管理</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
					  <li><a href="shopowner.html"><span class="word_title">商家管理</span></a></li>
                      <li><a href="${ctx}/portal!portalManage.do"><span class="word_title">Portal管理</span></a></li>
                    </ul>
                </li-->
                <li id="members">
                    <i class="icon-cus"><img src="${ctx}/source/images/4.png" /></i>
                    <span class="word_title">客户管理</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
                      <li><a href="onclien!initAccountManage.do"><span class="word_title">在线客户</span></a></li>
					  <li><a href="onclien!initAccountAnalysis.do"><span class="word_title">客户分析</span></a></li>
                      <!--li><a href="source/page/onclien/onlinelog.html"><span class="word_title">上线日志</span></a></li-->
                    </ul>
                </li>
                  <li id="report">
                    <i class="icon-cus"><img src="${ctx}/source/images/5.png" /></i>
                    <span class="word_title">统计报表</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
                      <li><a href="${ctx}/countController!toCountPage.do"><span class="word_title">发展量统计</span></a></li>
                        <li><a href="${ctx}/source/page/statistics/growth_speed.jsp"><span class="word_title">发展速度统计</span></a></li>
                         <li><a href="${ctx}/source/page/statistics/growth_speed_2.jsp"><span class="word_title">数据对比统计</span></a></li>
                      
                    </ul>
                </li>
                
                  <li id="behavior_analysis">
                    <i class="icon-cus"><img src="${ctx}/source/images/6.png" /></i>
                    <span class="word_title">Rom升级管理</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
                        <li><a href="upgrade!upGradePlan.do"><span class="word_title">升级计划</span></a></li>
                        <li><a href="upGrade!upGradeLog.do"><span class="word_title">升级日志</span></a></li>
                    </ul>
                </li>
                
                <li id="accounts">
                    <i class="icon-cogs"><img src="${ctx}/source/images/8.png" /></i>
                    <span class="word_title">系统管理</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
                    	<c:if test="${sessionScope.user.level != 2}">
                        	<li><a href="account!initAccountManage.do"><span class="word_title">用户管理</span></a></li>
                        </c:if>
                        <li><a href="account!initAccountSetting.do"><span class="word_title">账户设置</span></a></li>
                    </ul>
                </li>
                <li id="appstores">
                    <i class="icon-cogs"><img src="${ctx}/source/images/9.png" /></i>
                    <span class="word_title">APP商店管理</span><span class="arrow   slide"><img src="${ctx}/source/images/jiantou.png" style="margin-top: 14px"/></span>
                    <ul class="s_box">
                    	<c:if test="${sessionScope.user.level != 2}">
                        	<li><a href="app!initRouterManage.do"><span class="word_title">Router管理</span></a></li>
                        </c:if>
                        <li><a href="app!initPluginManage.do"><span class="word_title">APP管理</span></a></li>
                    </ul>
                </li>
              </ul>
        </div>
            <div class="continer" style="width:97.2%;height:602px;">
  
                <iframe id="indexFrame" src="${ctx}/index!homePage.do" scrolling="No"  noresize="noresize" runat="server" frameborder ="0" style="width:100%;height:100%;padding-left:38px;" ></iframe>

            </div>
    </div>
    <div id="modifyPassword" class="easyui-window" title="修改密码" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:300px;height:200px;padding:10px;">
        <div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'center',border:false" style="padding:10px;height:160px">
				<table border="0" style="border: 0px;">
					<tr>
						<td style="border: 0px;text-align: right;">新密码：</td>
						<td style="border: 0px;"><input type="password" id="password_one"></td>
					</tr>
					<tr>
						<td style="border: 0px;text-align: right;">确认密码：</td>
						<td style="border: 0px;"><input type="password" id="password_two"></td>
					</tr>
				</table>
				<span style="color: red;" id="err_msg"></span>
				<input id="userid" type="hidden" value="${sessionScope.user.id }"/>
			</div>
			<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0 0;height: 35px;">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-ok'" href="#" onclick="javascript:modifyPassword();" style="width:80px">确定</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:$('#modifyPassword').window('close');" style="width:80px">取消</a>
			</div>
		</div>
    </div>
     <!-- 查询流量弹出框 -->
	<%@include file="/source/page/ap/lookFlow.jsp"%>
</body>
</html>
