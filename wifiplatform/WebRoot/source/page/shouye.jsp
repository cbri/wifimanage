<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/index.css" />
    <script src="${ctx}/source/js/raphael.2.1.0.min.js"></script>
    <script src="${ctx}/source/js/justgage.1.0.1.min.js"></script>
    <script type="text/javascript">var num = ${onLineRes};</script>
    <script type="text/javascript">
      var g1;
      
      window.onload = function(){
        var g1 = new JustGage({
          id: "g1", 
          value:num, 
          min: 0,
          max: 100,
          title: "",
          label: "",
			levelColors: [
			  "#6D1C24"
			]    
        });
      

      };
    </script>
</head>
<body>
    <div class="main">
        <div class="main_left">
            <div class="main_top">
                <div class="top_left">
                    
                </div>
                <div class="top_right">
                    <img src="${ctx}/source/images/33.png" style="float:left;margin:20px 0 0 20px;"/>
                    <div id="g1"></div>
                </div>
            </div>
            <div class="main_bottom">
                 <div class="bottom_left">
                     <img src="${ctx}/source/images/44.png" style="float:left;margin:20px 0 0 20px;"/>
                    <span style="text-align:center;font-size:80px;color:#fff;float:left;margin-top:120px;margin-left:10px;">${apTotal}</span>
                 </div>
                <div class="bottom_right">
                    <img src="${ctx}/source/images/55.png" style="float:right;margin:20px 70px 0 0 "/>
                    <span style="float:right;color:#fff;font-size:80px;margin-top:60px;margin-right:-100px;">${customerNum}</span>
                </div>
            </div>
        </div>
        <div class="main_right" id="main_right" style="height: 100%;overflow: scroll;">
           <div style="width: 100%;overflow: auto;" id="main_right_content">
	           	 <table width="90%" border="0" class="page_table" style="margin-top: 30px;">
	              <tr height="30px;">
		                   <td>全网</td>
		                   <td>AP</td>
		                   <td>客户</td>
		                   <td>在线比</td>
		               </tr>
	              <c:forEach items="${adrs}" var="adr">
	              		<tr>
		                   <td>${adr.name}</td>
		                   <td>${adr.ap_total}</td>
		                   <td>${adr.customer_num}</td>
		                   <td>${adr.online_rate}</td>
		               </tr>
	              </c:forEach>
	            </table>
           </div>
           
        </div>
    </div>
</body>
</html>
