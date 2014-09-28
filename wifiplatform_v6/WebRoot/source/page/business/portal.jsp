<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
	<link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
	<link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
	<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
	<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
	<script type="text/javascript"> var level = ${sessionScope.user.level}; </script>
	<script type="text/javascript"> var parent_userid = ${sessionScope.user.parent_userid};</script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
	
	
	<script type="text/javascript">
	/**点击加载*/
	var staticJson ;
	var pcode;
	function onClickLoad(event, treeId, treeNode){
		var code= treeNode.id;
			$.ajax({
					type : "POST",
					dataType : "json",
					url : "apmController!querybycode",
					data : "code="+code,
					success : function(json) {
						staticJson = json;
						pcode= code;
						var htmlStr = "";
						htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
						htmlStr += " <tr style='background:#d4e1ee;height:42px;line-height:42px;'>";
						htmlStr += " <td width='6%'><div align='center'>AP名称</div></td>";
						htmlStr += " <td width='10%'><div align='center'>AP IP</div></td>";
						htmlStr += " <td width='10%'><div align='center'>AP MAC</div></td>";
						htmlStr += " <td width='6%'><div align='center'>商家</div></td>";
						htmlStr += " <td width='10%'><div align='center'>区域</div></td>";
						htmlStr += " <td width='10%'><div align='center'>SSID</div></td>";
						htmlStr += " <td width='19%'><div align='center'>操作</div></td>";
						htmlStr += "</tr>";
						for ( var i = 0; i < json.length; i++) {
							htmlStr += "<td width='6%'><div align='center'>"
									+ json[i].token
									+ "</div></td>";
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].ipaddr
									+ "</div></td>";
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].mac
									+ "</div></td>";
							htmlStr += "<td width='6%'><div align='center'>"
									+ json[i].phonenum
									+ "</div></td>";
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].access_mac
									+ "</div></td>";
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].device
									+ "</div></td>";
							htmlStr += "<td width='19%'><div align='center'><ul>"
									+ " <li><a href="#">设置</a></li>"
			                        + " </ul>"
									+ "</div></td>";
							htmlStr += "</tr>";
						}
						htmlStr += "</table>";
						$("#data_table").html(htmlStr);
					},
					error : function() {
						if (!confirm('你的访问超时，请重新登陆!'))
							return;
						window.location = '${ctx}/denglu.jsp';
					}
				});
		
	}


</script>
<script type="text/javascript" src="${ctx}/source/js/ap/tree.js"></script>
<script type="text/javascript" src="${ctx}/source/js/ap/query.js"></script>
<script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="${ctx}/source/js/ap/apUpgradeControl.js"></script>
    <script>
        $(document).ready(function () {
            $('.more_search').click(function () {
                $('.tan_search').show();
            });
            $('.search_close,.quxiao').click(function () {
                $('.tan_search').hide();
            });
            $('.tree_1_list').hover(function () {
                $(this).stop().animate({ "right": 0 }, 500, function () {
                });
            }, function () {
                $(this).stop().animate({"right": -360 }, 500, function () {
                });
            });
		//判断用户level,显示高级查询省市区三级联动初始化
			if(parent_userid==0){
				initprovince();	
			}else if(level==0){
            	init();
            }else if(level==1){
            	$("#province").hide();
            	initcity();
            }else if(level==2){
            	$("#province").hide();
            	$("#city").hide();
            	initdistrict();
                }
        });

</script>
<style type="text/css">
ul.nav_ul {
	border-width: 0px;
	margin: 0px;
	padding: 0px;
	text-indent: 0px;
}
</style>
</head>
<body>
	<div class="tree_1_list">
		<span class="tree_1_hover"><img
			src="${ctx}/source/images/share.png" />
		</span>
		<div class="tree_1_cont" style="overflow: auto;">
			<ul class="ztree"  id="menuTree">
			</ul>
		</div>
	</div>
    <div class="AP_wrap">
        <div class="AP_title">
            
            <ul>
                <li class="rr"><a href="#">首页</a></li>
                <li><a href="#">客户管理</a></li>
            </ul>
        </div>
        <div class="AP_used">
            <img src="${ctx}/source/images/chuangjian.png" />
            <img src="${ctx}/source/images/delet.png" />

            <div class="AP_search">
                <div class="AP_inpu_search">
                    <input type="text" placeholder="请输入AP名称进行搜索"/>
                    <span>搜索</span>
                </div>

                <span>高级搜索</span>
            </div>
            
            
        </div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AP_table">
              <tr style="background:#d4e1ee">
                <td width="7%"><div align="center"><input type="checkbox" /></div></td>
                <td width="11%"><div align="center">Portal名称</div></td>
                <td width="20%"><div align="center">认证页面</div></td>
                <td width="20%"><div align="center">欢迎页面</div></td>
                <td width="10%"><div align="center">广告间隔</div></td>
                <td width="10%"><div align="center">启用状态</div></td>
                <td width="10%"><div align="center">关联AP</div></td>
                <td width="12%"><div align="center">&nbsp</div></td>
              </tr>
              <c:forEach items="${connList}" var="c"></c:forEach>
              <tr>
                <td><div align="center"><input type="checkbox" /></div></td>
                <td><div align="center">${c.token }</div></td>
                <td><div align="center">${c.mac }</div></td>
                <td><div align="center">${c.ipaddr }</div></td>
                <td><div align="center">2</div></td>
                <td><div align="center">${c.phonenum }</div></td>
                <td><div align="center">1</div></td>
                <td><div align="center"><img src="${ctx}/source/images/zhuangtai.png" /></div></td>
              </tr>

              
            </table>

    </div>
</body>
</html>
