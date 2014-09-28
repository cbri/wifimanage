<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<head>
    <meta charset="utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/index.css" />
    <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
    <script type="text/javascript">
    /**
    	window.onload=function(){
    		alert(document.cookie);
    		if(document.cookie.indexOf("username=", 0) >= 0){
    			var a = document.cookie.substring(document.cookie.indexOf("username=", 0)+9,document.cookie.length);
	    		a = a.substring(0, a.indexOf(";", 0));
	    		$("#username").val(a);
    		}
    	};
    	*/
    	function login(){
    		var u = $("#username").val();
    		/**
    		if(document.getElementById("cc").checked){
    			var pos1 = document.cookie.substring(0,document.cookie.indexOf("username=", 0));
    			var pos2 = document.cookie.substring(document.cookie.indexOf("username=", 0),document.cookie.length);
    			var pos3 = pos2.substring(document.cookie.indexOf(";", 0)+1, document.cookie.length);
    			document.cookie = pos1+"username="+u+";"+pos2;
    		}
    		*/
    		var p = $("#password").val();
    		$.post("/wifiplatform/login!checkUser.do","user.name="+u+"&user.pwd="+p,function(res){
    			if(res.success=="success"){
    				window.location="login!index.do";
    			}else{
    				$("#err").text(res.success);
    			}
    		},"json");
    	};
    	/**回车登陆*/
    	function keyBoard(va){
    		if(va == 13){
    			login();
    		}
    	};
    	
    </script>
</head>
<body onkeydown="keyBoard(event.keyCode)">
    <div class="denglu">
        <img src="${ctx}/source/images/denglu_bg.png" id="bg"/>
    </div>
    <div class="denglu_border">
        <div class="denglu_inpu">
            <input type="text" style="left:72px;top:100px;"placeholder="用户名" class="inpu" id="username"/>
            <input type="password" style="left:72px;top:173px;" placeholder="密码"class="inpu" id="password"/>
            <p><input type="checkbox" id="cc"/><label for="cc">记住密码</label>&nbsp;<label style="color: #f00;size: 6px" id="err"></label></p>
            <img src="${ctx}/source/images/denglu.png" onclick="login()"/>
        </div>
    </div>
</body>
</html>
