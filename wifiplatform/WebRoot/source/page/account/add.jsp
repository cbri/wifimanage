<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<link type="text/css" rel="stylesheet"
	href="${ctx}/source/css/easyui/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/source/css/easyui/icon.css">
	<style type="text/css">
		.add_div table {
		    border:1px solid #bcd2e9;
		    border-collapse: collapse;
			border-spacing: 0;
		}
		.add_div td {
		    border:none;
		    padding:0;
		    margin:0;
		    border-collapse:inherit;}
		.add_div tr {
		    height:35px;
		    line-height:0px;
		}
	</style>
	<form id="add_form">
<div class="add_div">
      <div class="AP_title">
          
          <ul>
              <li class="rr"><span>首页</span></li>
              <li><span id="operator_type">新增用户</span></li>
          </ul>
      </div>
     <input type="hidden" id="accountId" value=""/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="edit_td">
            <tr><td width="22%">用户名</td><td width="78%"><input name="user_name" id="username"/></td></tr>
	 
		  <tr><td>密码</td><td><input name="user_name" type="password" id="password_one"/></td></tr>
		
		  <tr><td>确认密码</td><td><input name="user_name" type="password" id="password_two"/></td></tr>
		  
		  <tr><td>真实姓名</td><td><input name="user_name" id="real_name"/></td></tr>
		
		  <tr><td>联系方式</td><td><input name="user_name" id="contact"/></td></tr>
		  
		  <tr>
	                <td >管理域</td>
	                <td>
	                    <select id="district" class="easyui-combotree" style="width:328px;height: 24px;" multiple></select>
	                </td>
	                </tr>
		       <tr style="height:40px;"><td colspan="2"><span style="color: #f00;font-size: 12px;display:block;margin-left: 112px;" id="err_msg"></span><span style="width:72px;height:26px;line-height:26px;display:block;background:#f8571a;color:#fff;border-radius:4px;text-align:center;cursor:pointer;float:right;margin-right:50px;" onclick="save()">保存</span></td></tr>
		                
          </table>
          
  </div>
  </form>