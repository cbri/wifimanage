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
<!--<script type="text/javascript"  src="${ctx}/source/js/exporting.js"></script>-->

<script type="text/javascript"  src="${ctx}/source/js/statistics/growth_speed.js"></script>

</head>
<body>
	  <div style="width:1000px; margin-left:225px; margin-top: 8px; margin-bottom: 10px">
	  <table width="800" border="0" style="font-size:13px;">
	  <tr  width="800" >
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
	  	
		<td width="65" style="text-align:right;">日期：</td>
		<td width="228" >
		<select id="timeY" name="timeY"  multiple="multiple" >
		 	<option value='2014'>2014年</option>
		 	<option value='2013'>2013年</option>
		 	<option value='2012'>2012年</option>
		 	<option value='2011'>2011年</option>
		 	<option value='2010'>2010年</option>
		 	<option value='2009'>2009年</option>
		 	<option value='2008'>2008年</option>
		 	<option value='2007'>2007年</option>
		 	<option value='2006'>2006年</option>
		 	<option value='2005'>2005年</option>
		 	<option value='2004'>2004年</option>
		 	<option value='2003'>2003年</option>
		 	<option value='2002'>2002年</option>
		 	<option value='2001'>2001年</option>
		 	<option value='2000'>2000年</option>
	 	</select> 
		</td>
		<td width="228" >
		<select id="timeM" name="timeM"  multiple="multiple" >
	 		<option value=''>--请选择--</option>
	 		<option value='1'>1月</option>
	 		<option value='2'>2月</option>
	 		<option value='3'>3月</option>
	 		<option value='4'>4月</option>
	 		<option value='5'>5月</option>
	 		<option value='6'>6月</option>
	 		<option value='7'>7月</option>
	 		<option value='8'>8月</option>
	 		<option value='9'>9月</option>
	 		<option value='10'>10月</option>
	 		<option value='11'>11月</option>
	 		<option value='12'>12月</option>
	 	</select> 
		</td>
		<td>
		<input style=" width:65px; height:25px; background:url(${ctx}/source/images/a-bj.gif) left center no-repeat;line-height:25px;
text-align:center;border:none; color:#FFF; font-weight:bold;"
type="button" name="button" id="selectHighchartsButton" value="统计" class="anniu" onclick="selectHighcharts()"/>
		</td>
	  </tr>
	  </table>
	  </div>
	  
	  <!-- border-bottom: 2px solid #95B8E7; 
	   <div style="width: 1250px;overflow:auto ;float: left;margin-left: 30px;">
	 	 <div id="ap_total_div" style="float: left;" > </div> 
		 <div id="inconming_total_div"  style="float: left;margin-left: 15px;" > </div>  
		 
	 	 <div id="outgoing_tota_div" style="float: left;margin-top: 15px;" > </div>
		 <div id="customer_num_div" style="float: left;margin-top: 15px; margin-left: 15px; " > </div>  
	 	</div> -->
	 	
	 	<div class="ss_content">
	 	
	 	 <div class="one_cont">
		 	 <div class="one_title">
	                    <span>AP总数曲线图</span>
	         </div>
		 	 <div id="ap_total_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont">
		 	 <div class="one_title">
	                    <span>上行流量曲线图</span>
	         </div>
		 	 <div id="inconming_total_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont">
		 	 <div class="one_title">
	                    <span>下行流量曲线图</span>
	         </div>
		 	 <div id="outgoing_tota_div" class="one" > </div> 
	 	 </div>
	 	 
	 	  <div class="one_cont">
		 	 <div class="one_title">
	                    <span>累计客户总数曲线图</span>
	         </div>
		 	 <div id="customer_num_div" class="one" > </div> 
	 	 </div>
		
	 	</div>
	 	
</body>
</html>
