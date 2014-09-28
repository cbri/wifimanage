<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="com.sinosoft.account.bean.AccountDistrictRel"%>
<%@ page language="java" import="com.sinosoft.account.bean.Account"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title></title>
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/upgrade.dialog.css" />
<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/source/js/account/account_tree.js"></script>
<script type="text/javascript"
	src="${ctx}/source/js/jquery.easyui.min.js"></script>
<script type="text/javascript">var parentId = ${requestScope.userLevel};</script>
<script type="text/javascript" src="${ctx}/source/js/account/popCreateAccount.js"></script>
<script type="text/javascript">	
   	var execute;
   	var divOn = false;
		var arr = new Array();
		function divOnMouseover(event){
			divOn = true;
		}
		function divOnMouseout(event){
			divOn = false;
			setTimeout(function (){
				if(!divOn){
					clearTimeout(execute);
					var div = document.getElementById("popue_div");
					div.style.visibility="hidden";
					arr = new Array();
				}
			},200);
		}
	   	function popueMac(obj,event,id){
	   		execute = setTimeout(function (){
	   			var div = document.getElementById("popue_div");
	   			if(arr.length != 0||div.style.visibility == 'visible'){
	   				return;
	   			}
		   		arr[0] = div;
		   		var x = obj.offsetLeft;
		   		var y = obj.offsetTop;
		   		var ele = obj.offsetParent;
		   		var sTop = document.getElementById("popue_div").scrollTop;
		   		while(ele){
		   			x+=ele.offsetLeft;
		   			y+=ele.offsetTop;
		   			ele = ele.offsetParent;
		   		}
		   		y-=sTop;
		   		y=y+obj.offsetHeight;
		   		div.style.top=y+"px";
		   		div.style.left=x+"px";
		   		//忘上面加内容
		   		$.get("PositionController!getTreeData","userid="+id,function(data){
		   			var zNodes = $.parseJSON(data.toString());
		   			zNodes = eval(zNodes);
					// 测试
					var treeObj = $.fn.zTree.getZTreeObj("menuTree");
					$.fn.zTree.destroy("menuTree");
					$.fn.zTree.init($("#menuTree"), setting, zNodes);
					div.style.visibility="visible";
		   		});
	   		},200);
	   	}
	   	function hiddenPopueMac(obj,event){
	   		setTimeout(function (){
		   		if(divOn){
		   			return;
		   		}
		   		clearTimeout(execute);
	   			var div = document.getElementById("popue_div");
	   			div.style.visibility="hidden";
	   			arr = new Array();
	   		},200);
	   	}
   </script>
</head>
<body onkeydown="keyBoardQuery(event.keyCode)">
	<div class="AP_wrap">
		<div class="AP_title">
			<img alt="" src="" height="">
			<ul>
				<li class="rr"><a href="#">首页</a>
				</li>
				<li><a href="#">用户管理</a>
				</li>
			</ul>
		</div>
		<div class="AP_used">
			<a href="javascript:popCreateAccount();"><img
				src="${ctx}/source/images/chuangjian.png" />
			</a>

			<div class="AP_quicksearch">
				<div class="AP_inpu_search">
					<input type="text" placeholder="请输入名称进行搜索" id="search_text"/> <span onclick="queryAccount()">搜索</span>
				</div>
			</div>


		</div>
		<div style="width: 100%;height: 450px;overflow: auto;" id="content_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="AP_table" id="content_table">
				<tr style="background:#d4e1ee">
					<td width="20%"><div align="center">用户名</div>
					</td>
					<td width="20%"><div align="center">真实姓名</div>
					</td>
					<td width="20%"><div align="center">联系方式</div>
					</td>
					<td width="10%"><div align="center">管理域</div>
					</td>
					<td width="15%"><div align="center">账号状态</div>
					</td>
					<td width="15%"><div align="center">操作</div>
					</td>
				</tr>
				<%
				List<Account> account = (List<Account>)request.getAttribute("account");
				for(int i = 0;i<account.size();i++){
					if(account.get(i) == null){
					    continue;
					}
					%>
						<tr id="accountTr<%=i%>" ondblclick="showUpdateDialog(<%=i%>,<%=account.get(i).getId()%>)">
						        <c:set var="positions" value=""></c:set>
									<%
										List<AccountDistrictRel> pos = account.get(i).getPositions();
										String s = "";
										if(pos != null){
											for(AccountDistrictRel p:pos){
											if(p != null){
												if(!"".equals(s)){
													s = s+","+p.getCode();
												}else{
													s=p.getCode();
												}
											}
										}
										}
									 %>
									<input type="hidden" id="hidden_district<%=i%>" value="<%=s%>"/>
							<td><div align="center" id="td_1_<%=i %>"><%=account.get(i).getName() %></div>
							</td>
							<td><div align="center" id="td_2_<%=i %>"><%=account.get(i).getReal_name() %></div>
							</td>
							<td><div align="center" id="td_3_<%=i %>"><%=account.get(i).getContact() %></div>
							</td>
							<td><div align="center">
									<a href="#" onmouseover="popueMac(this,event,'<%=account.get(i).getId()%>')" onmouseout="hiddenPopueMac(this,event)">查看</a>
									<!-- 
									<a href="javascript:#" onmouseout="hiddenDistrict()" onmousemove="showDistrict(<%=account.get(i).getId() %>,this,event)" >查看</a>
									 -->
								</div>
							</td>
							<td><div align="center"><%=account.get(i).getInvalid_flag()==0?"有效":"失效"%></div>
							</td>
							<td><div align="center">
									<a href="javascript:invalidAccount(<%=account.get(i).getId()%>,<%=account.get(i).getInvalid_flag()%>,<%=i%>);">
									<%=account.get(i).getInvalid_flag()==0?"停用":"启用"%></a>
								</div>
							</td>
						</tr>
					<%
				} %>
			</table>
		</div>
		<div id="popue_div" style="float: right;visibility:hidden;position:absolute;
    			background-color:#BCD2E9;z-index: 9999;
    			overflow: auto;width: 190px;height: 200px;" onmouseover="divOnMouseover()" onmouseout="divOnMouseout()">
							<ul class="ztree"  id="menuTree">
							</ul>
	            </div>
		<div id="floatDiv" class="easyui-window" title="新增用户" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:500px;height:400px;padding:10px;background-color: #F0FFF0;">
	      <div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'center',border:false" style="background-color: #F0FFF0;padding:10px;height:160px">
				<div
					style="background-color:#F0FFF0;position: relative;top: 0;height: 320px;z-index: 999">
					<%@include file="add.jsp"%>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
