<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>

<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/source/js/ui/css/ui-lightness/jquery-ui-1.9.2.custom.min.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/js/ui/multiselect/jquery.multiselect.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/css/growth_speed.css" />

<script type="text/javascript"> var level = ${sessionScope.user.level}; </script>
<script type="text/javascript"> var parent_userid = ${sessionScope.user.parent_userid};</script>
<script type="text/javascript"> var code = '${sessionScope.user.code}'; </script>

<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/source/js/ui/js/jquery-ui-1.9.2.custom.min.js"></script>
<script type="text/javascript" src="${ctx}/source/js/ui/multiselect/jquery.multiselect.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
<script type="text/javascript"  src="${ctx}/source/js/highcharts.js" ></script>
<script type="text/javascript"  src="${ctx}/source/js/highcharts-more.js" ></script>
<!--打印去除<script type="text/javascript"  src="${ctx}/source/js/exporting.js"></script>-->
<script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript"  src="${ctx}/source/js/statistics/growth_speed_2.js"></script>

</head>
<body>
	<div style="width:1000px;margin-left:225px; margin-top: 8px; margin-bottom: 10px" >
	 	 <table width="800" border="0" style="font-size:13px;">
	 	 <tr   style="float: left;width: 900px;" >
			   <td width="50" style="text-align: right;">地区：</td>
			   <td id="provinceTD"  ><select id="province" name="province" data-level="1" multiple="multiple" ></select></td>
			   
			   <td id="cityTD" ><select id="city" name="city" data-level="2" multiple="multiple" style="display: none">
				<option>---请选择---</option>
				</select>
				</td>
			   
			   <td id="districtTD" ><select id="district" name="district" data-level="3" multiple="multiple" style="display: none">
				<option>---请选择---</option>
				</select>
				</td>
	  	 </tr>
	  	 <tr>
	  	 <td>
	  	 		<input type="radio" value="time_d" name="radio" checked="checked" >日期 <!--input 弄到成一排。求解美工-->
			 	<input id="time_d" name="time_d" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate" style=""/>
			 	<input name="time_d" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate" style=" " />
			 	<input name="time_d" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate" style="" />
			 	<input name="time_d" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate" style="" />
			 	<input name="time_d" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" class="Wdate" style="" />
	  	 </td>
	  	 </tr>
	  	 <tr>
	  	 <td>
	  	 		<input type="radio" value="time_m" name="radio">月份
			 	<input id="time_m"  name="time_m" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" class="Wdate" style="" disabled="disabled" />
			 	<input name="time_m" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" class="Wdate" style=""  disabled="disabled" />
			 	<input name="time_m" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" class="Wdate" style=""  disabled="disabled" />
			 	<input name="time_m" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" class="Wdate" style=""  disabled="disabled" />
			 	<input name="time_m" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" class="Wdate" style=""  disabled="disabled" />
	  	 </td>
	  	 <td>
	  	 		<input style=" width:65px; height:25px; background:url(${ctx}/source/images/a-bj.gif) left center no-repeat;line-height:25px;
	  	 		margin-bottom:40px ;text-align:center;border:none; color:#FFF; font-weight:bold;"
type="button" name="button" id="selectHighchartsButton" value="统计" class="anniu" onclick="selectHighcharts()"/>
	  	 </td>
	  	 </tr>
	 	 </table>
	 	</div>
	 	
<div style=" width:100%;margin:0 auto;background:#e8edf1;height: 430px;overflow: auto;" >
	 	<div class="one_cont2">
		 	 <div class="one_title">
	                    <span>AP总数曲线图</span>
	         </div>
		 	 <div id="ap_total_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont2">
		 	 <div class="one_title">
	                    <span>上行流量曲线图</span>
	         </div>
		 	 <div id="inconming_total_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont2">
		 	 <div class="one_title">
	                    <span>累计客户总数曲线图</span>
	         </div>
		 	 <div id="customer_num_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont2">
		 	 <div class="one_title">
	                    <span>下行流量曲线图</span>
	         </div>
		 	 <div id="outgoing_tota_div" class="one" > </div> 
	 	 </div>
	 	 
		
	 	</div>
</body>
</html>
