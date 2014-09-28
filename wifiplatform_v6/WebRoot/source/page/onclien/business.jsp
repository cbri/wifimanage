<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" import="com.sinosoft.onclien.bean.Connections"%>
<%@ page language="java" import="com.sinosoft.onclien.service.impl.OnclienServiceImpl"%>
<%@ page language="java" import="java.text.SimpleDateFormat"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
<link type="text/css" rel="stylesheet" href="${ctx}/source/css/upgrade.dialog.css" />
<link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js"></script>
<script type="text/javascript"> var level = ${sessionScope.user.level}; </script>
<script type="text/javascript"> var parent_userid = ${sessionScope.user.parent_userid};</script>
<script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/source/js/onclien/scroll.js"></script>
<script type="text/javascript" src="${ctx}/source/js/onclien/Clien.js"></script>
<script type="text/javascript" src="${ctx}/source/js/onclien/n.js"></script>
<script type="text/javascript">
/**点击加载*/
var staticJson ;
var pcode;
function onClickLoad(event, treeId, treeNode){
	var code= treeNode.id;
		$.ajax({
					type : "POST",
					dataType : "json",
					url : "onclien!querybycode",
					data : "code="+code,
					success : function(json) {
						staticJson = json;
						pcode= code;
						var htmlStr = "";
						htmlStr += " <table width='100%' border='0' cellspacing='0' cellpadding='0' class='AP_table'  id='data_table'>";
						htmlStr += " <tr style='background:#d4e1ee;'>";
						htmlStr += "<td width='10%'><div align='center'>客户标识</div></td>";
						htmlStr += "<td width='10%'><div align='center'>终端MAC</div></td>";				
						htmlStr += "<td width='10%'><div align='center'>上行流量</div></td>";					
						htmlStr += "<td width='10%'><div align='center'>下行流量</div></td>";				
						htmlStr += "<td width='10%'><div align='center'>终端类型</div></td>";
						htmlStr += "<td width='10%'><div align='center'>上线时间</div></td>";
						htmlStr += "<td width='10%'><div align='center'>AP MAC</div></td>";
						htmlStr += "<td width='15%'><div align='center'>商户名称</div></td>";
						htmlStr += "<td width='15%'><div align='center'>区域</div></td>";
							
						htmlStr += "</tr>";
												
						for ( var i = 0; i < json.length; i++) {
						htmlStr += "<tr style='background:#d5e8e2'>"
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].phonenum
									+ "</div></td>";
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].mac
									+ "</div></td>";

							var n = json[i].outgoing;
							if(n%Math.pow(1024,3)!=n){
								n = n / Math.pow(1024,3);
								var num = Math.round(n * 10) / 10;
								var outgoing = num+"GB"
							}else if(n%Math.pow(1024,2)!=n){
									n = n/Math.pow(1024,2);
									var num = Math.round(n * 10) / 10;
									var outgoing = num+"MB"
							}else if(n%1024){
									var outgoing = n+"KB";
							}else{
									var outgoing = "B";
							}
							htmlStr += "<td width='10%'><div align='center'>"
									+ outgoing
									+ "</div></td>";	
									
							var n = json[i].incoming;
							if(n%Math.pow(1024,3)!=n){
								n = n / Math.pow(1024,3);
								var num = Math.round(n * 10) / 10;
								var incoming = num+"GB"
							}else if(n%Math.pow(1024,2)!=n){
									n = n/Math.pow(1024,2);
									var num = Math.round(n * 10) / 10;
									var incoming = num+"MB"
							}else if(n%1024){
									var incoming = n+"KB";
							}else{
							}
							htmlStr += "<td width='10%'><div align='center'>"
									+ incoming
									+ "</div></td>";
							
							var s = "";
							if(json[i].device.toUpperCase().indexOf("ANDROID") != -1){
								s = "android";
							}else if(json[i].device.toUpperCase().indexOf("IPHONE") != -1){
									s = "iphone";
							}else if(json[i].device.toUpperCase().indexOf("WINDOWS") != -1){
									s =  "pc";
							}else if(json[i].device.toUpperCase().indexOf("MAC OS") != -1){
									s =  "pc";
							}else if(json[i].device.toUpperCase().indexOf("IPAD") != -1){
									s = "ipad";
							}else {
									s = json[i].device;
							}
							htmlStr += "<td width='10%'><div align='center'>"
									+ s
									+ "</div></td>";								
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].time
									+ "</div></td>";		
							htmlStr += "<td width='10%'><div align='center'>"
									+ json[i].access_mac
									+ "</div></td>";					
							
							htmlStr += "<td width='15%'><div align='center'>"
									+ "<a href='#' onclick=attrLook1("+json[i].id+"); title='"+json[i].merchant+"'>"
									+ ((json[i].merchant==null || json[i].merchant=='')?'':json[i].merchant.substring(0,10)+"......")+ "</a>"
									+ "</div></td>";

							var c = "";
							if(json[i].pname == json[i].cname){
								json[i].cname = c;
							}	
							htmlStr += "<td width='15%'><div align='center'>"
									+ json[i].pname+""+json[i].cname+""+json[i].dname+""
									+ "</div></td>";
							
							htmlStr += "</tr>";
						}
						htmlStr += "</table>";
						$("#data_table").html(htmlStr);
					},
					error : function() {
						if (!confirm('该地区没有数据，请重新选择!'))
							return;
						window.location = '${ctx}/onclien!initAccountManage.do';
					}
				});
	}



function attrLook1(id){
	var htmlStr = "";
	htmlStr += " <form id='setProtocolForm' >";
	htmlStr += " <ul class='imglist' style='height:100px';>";
for ( var i = 0; i < staticJson.length; i++) {
	 if(id==staticJson[i].id){
		 htmlStr += " <li style='display:block;' class='news'>";
   			htmlStr +="<p><label>商户名称</label><input name='' type='text' value="+staticJson[i].merchant+" Readonly/></p>";
   			htmlStr +="<p><label>联系人</label><input name='' type='text' value="+staticJson[i].mname+" Readonly/></p>";
   			htmlStr +="<p><label>手机</label><input name='' type='text' value="+staticJson[i].phone+" Readonly/></p>";
   			htmlStr +="<p><label>电话</label><input name='' type='text' value="+staticJson[i].telephonenum+" Readonly/></p>";
   			htmlStr +="<p><label>邮箱</label><input name='' type='text' value="+staticJson[i].email+" Readonly/></p>";
   			htmlStr +="<p><label>微信</label><input name='' type='text' value="+staticJson[i].weixin+" Readonly/></p>";
			htmlStr +=" </li>";
	  }
	}   
	htmlStr +="</ul></form>";
	$("#attrLook1").html(htmlStr);
	$("#ap_attrLook1").window('open');
}	
	
	
var divOn = false;
function divOnMouseover(event){
	divOn = true;
}
function divOnMouseout(event){
	divOn = false;
	setTimeout(function (){
		if(!divOn){
			var div = document.getElementById("popue_div");
			div.style.visibility="hidden";
		}
	},200);
}
function divshow(access_node_id,obj){
	setTimeout(function (){
			var div = document.getElementById("popue_div");
			if(div.style.visibility == 'visible'){
				return;
			}
   		var x = obj.offsetLeft;
   		var y = obj.offsetTop;
   		var ele = obj.offsetParent;
   		var sTop = document.getElementById("up_div").scrollTop;
   		while(ele){
   			x+=ele.offsetLeft;
   			y+=ele.offsetTop;
   			ele = ele.offsetParent;
   		}
   		y-=sTop;
   		y=y+obj.offsetHeight;
   		div.style.visibility="visible";
   		div.style.top=y+"px";
   		div.style.left=x+"px";
   		//往上面加内容
   		var htmlStr = "";
   		htmlStr += " <ul style='height:99px';>";
   	for ( var i = 0; i < staticJson.length; i++) {
   		 if(access_node_id==staticJson[i].access_node_id){
   			htmlStr += " <li style='display:block;' class='merchant'> ";
   			htmlStr +="<p><label>商户名称</label><input name='' type='text' value="+staticJson[i].merchant+" Readonly/></p>";
   			htmlStr +="<p><label>联系人</label><input name='' type='text' value="+staticJson[i].mname+" Readonly/></p>";
   			htmlStr +="<p><label>手机</label><input name='' type='text' value="+staticJson[i].phonenum+" Readonly/></p>";
   			htmlStr +="<p><label>电话</label><input name='' type='text' value="+staticJson[i].telephonenum+" Readonly/></p>";
   			htmlStr +="<p><label>邮箱</label><input name='' type='text' value="+staticJson[i].email+" Readonly/></p>";
   			htmlStr +="<p><label>微信</label><input name='' type='text' value="+staticJson[i].weixin+" Readonly/></p>";
   			htmlStr +=" </li>";
   		  }
   		}   
   		htmlStr +="</ul>";
   		var tb = $("#popue_div_table");
   		tb.empty();
   		tb.html(htmlStr);
		},200);
	
}
function divhide(obj,event){
	setTimeout(function (){
		if(divOn){
   			return;
   		}
			var div = document.getElementById("popue_div");
			div.style.visibility="hidden";
		},200);
}

</script>
<script type="text/javascript" src="${ctx}/source/js/ap/tree.js"></script>
<script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="${ctx}/source/js/ap/apUpgradeControl.js"></script>
<script>
        $(document).ready(function () {
            $('.tree_1_list').hover(function () {
                var t = parent.document.getElementById("dataSource_manager");
                var p_code = t.options[t.selectedIndex].value;
                var obj = $(this);
                if(p_code == '0'){
                	$.getJSON("PositionController!getTreeData", null, function(data){
						var zNodes = $.parseJSON(data.toString());
						// 测试
						$.fn.zTree.init($("#menuTree"), setting, zNodes);
						obj.stop().animate({ "right": 0 }, 500, function () {});
					});
                }else{
	            	$.getJSON("PositionController!getTreeDataById", "id="+p_code, function(data){
						var zNodes = $.parseJSON(data.toString());
						// 测试
						$.fn.zTree.init($("#menuTree"), setting, zNodes);
						obj.stop().animate({ "right": 0 }, 500, function () {});
					});
				}
            }, function () {
                $(this).stop().animate({ "right": -360 }, 500, function () {
                });
            });
             var ajaxbg = $("#background,#progressBar");
            	ajaxbg.hide();
            $(document).ajaxStart(function () {
            	ajaxbg.show();
            }).ajaxStop(function () {
                ajaxbg.hide();
            }); 
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
.background {
display: block;
width: 100%;
height: 100%;
opacity: 0.4;
filter: alpha(opacity=40);
background:while;
position: absolute;
top: 0;
left: 0;
z-index: 2000;
}
.progressBar {
border: solid 2px #86A5AD;
background: white url(${ctx}/source/images/loading.gif) no-repeat 10px 10px;
}
.progressBar {
display: block;
width: 99px;
height: 69px;
position: fixed;
top: 45%;
left: 50%;
margin-left: -74px;
margin-top: -14px;
padding: 10px 10px 10px 50px;
text-align: left;
line-height: 27px;
font-weight: bold;
position: absolute;
z-index: 2001;
} 
</style>
</head>
<body>
	<!------------进度条开始----------->
	<div id="background" class="background" style="display: none; "></div>
	<div id="progressBar" class="progressBar" style="display: none; "></div> 
	<!------------进度条结束----------->
	
	<!------------泡沫预览开始----------->
	<div id="popue_div" style="float: right;visibility:hidden;position:absolute;
    			background-color:#BCD2E9;z-index: 9999;
    			width: 230px;height: 245px;" onmouseover="divOnMouseover()" onmouseout="divOnMouseout()">
   		<table id="popue_div_table" style="width:225px;height:240;margin-top: 5px;margin-left: 5px;">
   		</table>
	</div>
	<!------------泡沫预览结束----------->
	
	
	<!------------右侧 树菜单 快捷停靠----------->
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
				<li class="rr"><a href="#">首页</a>
				</li>
				<li class="rr"><a href="#">客户管理</a>
				</li>
				<li><a href="${ctx}/onclien!initAccountManage.do">在线客户</a>
				</li>
			</ul>
		</div>
		<div class="AP_used">
			<div class="AP_quicksearch">
				<div class="AP_inpu_search">
					<input type="text" placeholder="请输入MAC地址进行搜索" id="searchbymac"/> <span onclick="querybymac(pcode);">搜索</span>
					<input type="Hidden" id="hiddencode"/>
				</div>
			</div>
		</div>
		
		<!--查看开始-->
		<div id="ap_attrLook1" class="easyui-window" title="商户信息" data-options="iconCls:'icon-save',modal:true,closed:true,top:'99px'" style="height:250px;width:500px;padding:10px;background-color: #F0FFF0;">
	      		<div id="attrLook1" style="border:none;">
		      
				</div>
		</div>
		
		<div id="ap_merchantlook" class="easyui-window" title="商户信息" data-options="iconCls:'icon-search',modal:true,closed:true,top:'99px'" style="height:280px;width:400px;padding:10px;background-color: #F0FFF0;">
	      		<div id="merchantlook" style="border:none;" class="merch">
		      
				</div>
			</div>
		
	<!--查看结束-->
		<div style="height:450px;width: 100%;overflow-y:auto;" id="up_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="data_table" class="AP_table">
				<tr style="background:#d4e1ee;">
					<td width='10%'><div align='center'>客户标识</div></td>
					<td width='10%'><div align='center'>所属平台</div></td>
					<td width='10%'><div align='center'>终端MAC</div></td>					
					<td width='10%'><div align='center'>上行流量</div></td>					
					<td width='10%'><div align='center'>下行流量</div></td>					
					<td width='10%'><div align='center'>终端类型</div></td>
					<td width='10%'><div align='center'>上线时间</div></td>
					<td width='10%'><div align='center'>AP MAC</div></td>
					<td width='15%'><div align='center'>商户名称</div></td>
					<td width='15%'><div align='center'>区域</div></td>
				</tr>
				<c:forEach items="${connList}" var="c">
				<tr>
					<td width='10%'><div align='center'>${c.phonenum }</div></td>
					<td width='10%'><div align='center'>${c.platform }</div></td>	
					<td width='10%'><div align='center'>${c.mac }</div></td>					
					<td width='10%'><div align='center'>${c.out }</div></td>					
					<td width='10%'><div align='center'>${c.in }</div></td>					
					<td width='10%'><div align='center'>${c.device }</div></td>
					<td width='10%'><div align='center'>${c.time }</div></td>
					<td width='10%'><div align='center'>${c.access_mac }</div></td>
					<td width='15%'>
						<div align="center"><a href="javascript:merchantlook(${c.id})">
	                  	${c.merchant }</a></div>
					</td>
					<td width='15%'><div align='center'>${c.pname }${c.cname }${c.dname }</div></td>
				</tr>
				</c:forEach>
			</table>
		</div>
</body>
</html>
