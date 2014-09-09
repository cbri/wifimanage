<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
	<c:forEach items="${account}" var="acc" varStatus="i">
		  <tr id="accountTr${i.index}">
			<td><div align="center">${acc.name}</div>
			</td>
			<td><div align="center">${acc.real_name}</div>
			</td>
			<td><div align="center">${acc.contact}</div>
			</td>
			<td><div align="center">
					<a href="#">查看</a>
				</div>
			</td>
			<td><div align="center">${acc.invalid_flag==0?"有效":"失效"}</div>
			</td>
			<td><div align="center">
					<a href="javascript:invalidAccount(${acc.id},${acc.invalid_flag},${i.index});">${acc.invalid_flag==0?"停用":"启用"}</a>
					</div>
				</td>
			</tr>
		</c:forEach>
	</table>