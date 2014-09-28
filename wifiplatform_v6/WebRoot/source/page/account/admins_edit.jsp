<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" import="com.sinosoft.account.bean.AccountDistrictRel"%>
<%@ page language="java" import="com.sinosoft.account.bean.Account"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
    <link type="text/css" rel="stylesheet"
		href="${ctx}/source/css/easyui/easyui.css" />
	<link rel="stylesheet" type="text/css"
		href="${ctx}/source/css/easyui/icon.css">
	<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
	<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/jsAddress.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/address.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/account/accountsetting.js"></script>
    <script type="text/javascript" src="${ctx}/source/js/account/account_tree.js"></script>
    <script type="text/javascript">
    		function initTree() {
				// 初始化菜单树
				$.getJSON("PositionController!getTreeData", "userid="+<%=((Account)request.getSession().getAttribute("user")).getId()%>, function(data){
					zNodes = $.parseJSON(data.toString());
					zNodes = eval(zNodes);
					// 测试
					$.fn.zTree.init($("#menuTree"), setting, zNodes);
					
					});
			}
				
			$(function(){
				// 初始化应用树
				initTree();
				// 模型库和应用菜单切换效果 from ui desiger
			});
    </script>
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
		    height:33px;
		    line-height:0px;
		}
	</style>
</head>
<body>
    <div class="AP_wrap">
        <div class="AP_title">
            
            <ul>
                <li class="rr"><a href="#">首页</a></li>
                <li><a href="#">帐户设置</a></li>
            </ul>
        </div>
       	<div class="add_div" style="background:#d4e1ee">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="edit_td">
	              <tr style="background:#d4e1ee"><td width="22%">用户名</td><td width="78%"><input name="user_name"  value="${account.name}" disabled="disabled"/></td></tr>
				 
				  <tr style="background:#d4e1ee"><td>真实姓名</td><td><input name="user_name"  id="real_name" value="${account.real_name }"/></td></tr>
				
				  <tr style="background:#d4e1ee"><td>联系方式</td><td><input name="user_name"  id="contact" value="${account.contact }"/></td></tr>
				  <tr style="background:#d4e1ee" class="sheng">
	                  <td>管理域</td>
                 	  <td style="float:left;width:100%;border:none;" rowspan="5">
                 			<div style="width: 330px;height: 200px;overflow: auto;overflow-style:marquee,panner;background-color: #fff;border: 1px solid #999;border-radius: 4px;">
			                  	<ul class="ztree"  id="menuTree"></ul>
			             </div>
                      </td>
	                        
	              </tr>
				       <tr style="height:40px; background:#d4e1ee"><td colspan="2"><span style="color: #f00;font-size: 12px;display:block;margin-left: 112px;" id="err_msg"></span><span style="width:72px;height:26px;line-height:26px;display:block;background:#f8571a;color:#fff;border-radius:4px;text-align:center;cursor:pointer;float:right;margin-right:50px;" id="save_ele">保存</span></td></tr>
	        </table>
	         
	        <input type="hidden" id="userid" value="${account.id }"/>
	        <!-- <select id="district" class="easyui-combotree" style="width:328px;height: 24px;"></select> -->
        </div>
    </div>
</body>
</html>
