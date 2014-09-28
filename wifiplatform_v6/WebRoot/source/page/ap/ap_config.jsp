<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" /> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
        <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.ztree.core-3.5.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/ap/tree.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/My97DatePicker/WdatePicker.js">
        </script>
        <script type="text/javascript">
            function myDate(obj){
                this.year = parseInt(obj.year) + 1900;
                this.month = parseInt(obj.month) + 1;
                this.day = obj.date;
                this.hour = obj.hours;
                this.minute = obj.minutes;
                this.second = obj.seconds;
                this.toString = function(){
                    return this.year + "-" + this.month + "-" + this.day + "      " + this.hour + ":" + this.minute + ":" + this.second;
                }
            }
            
            function onClickLoad(event, treeId, treeNode){
                var code = treeNode.id;
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "apmController!queryApConfig",
                    data: "code=" + code,
                    success: function(json){
                        var htmlStr = "<table width='100%' border='0' cellspacing='0' cellpadding='0' id='data_table' class='AP_table'>" +
                        "<tr style='background: #d4e1ee; '><td width='15%'><div align='center'>配置时间</div></td>" +
                        "<td width='15%'><div align='center'>实际执行时间</div></td>" +
                        "<td width='10%'> <div align='center'>AP MAC</div></td>" +
                        "<td width='14%'><div align='center'>商家名称 </div></td>" +
                        "<td width='6%'><div align='center'>AP配置指令 </div></td>" +
                        "<td width='6%'><div align='center'>执行状态 </div></td>" +
                        "<td width='6%'><div align='center'>执行次数 </div></td>" +
                        "<td width='8%'><div align='center'>操作</div></td></tr>";
                        for (var i = 0; i < json.length; i++) {
                            var result = "失败";
                            if (json[i].set_result.indexOf("200") == 0) {
                                result = "成功";
                            }
                            htmlStr += "<tr id='tr${i}'>" +
                            "<td width='15%'><div align='center'>" +
                            new myDate(json[i].set_time).toString() +
                            "</div></td>" +
                            "<td width='15%'><div align='center'>" +
                            new myDate(json[i].execute_time).toString() +
                            "</div></td>" +
                            "<td width='10%'><div align='center'><a href='${ctx}/apmController!queryap?mac=" +
                            json[i].mac +
                            "&pcode=" +
                            json[i].code +
                            "'>" +
                            json[i].mac +
                            "</div></td>" +
                            "<td width='14%'><div align='center'>" +
                            json[i].merchant_name +
                            "</a></div></td>" +
                            "<td width='6%'><div align='center'>" +
                            json[i].type +
                            "</div></td>" +
                            "<td width='6%'><div align='center' onmouseover='popueMac(this,event,\"" +
                            json[i].set_result +
                            "\")\" onmouseout=\'hiddenPopueMac(this,event)\'>" +
                            result +
                            "</div></td>" +
                            "<td width='6%'><div align='center'>" +
                            json[i].runtime +
                            "</div></td>" +
                            "<td width='8%'><div align='center'><a href='javascript:checkSettings(" +
                            json[i].id +
                            ",'" +
                            json[i].type +
                            "','" +
                            json[i].set_result +
                            "','" +
                            json[i].mac +
                            "', '" +
                            json[i].runtime +
                            "');'>查看设置</a></div></td></tr>";
                        }
                        htmlStr += "</table>";
                        $("#data_table").html(htmlStr);
                    },
                    error: function(){
                        if (!confirm('该地区没有数据，请重新选择!')) 
                            return;
                        
                    }
                });
                
            }
        </script>
        <script type="text/javascript">
            var taskid;
            var apmac;
            $(document).ready(function(){
                //协议设置
                $("#save_xieyi").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        cache: false,
                        url: "apmController!reExcuteProtocal",
                        data: $('#set_xieyiForm').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                });
                
                //白名单
                $("#save_whitelist").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "apmController!reExecuteInternetLimit",
                        data: $('#whitelist_Form').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                    
                });
                
                //白名单mac
                $("#save_whitelist_mac").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "apmController!reExecuteInternetLimitMac",
                        data: $('#whitelist_Form_mac').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                    
                });
                
                //远程控制保存
                $("#save_yckz").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "apmController!reExecuteUpgrade",
                        data: $('#set_yckz_Form').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                    
                });
                
                //认证设置保存
                $("#save_rzsz").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "apmController!reExecuteUpgrade",
                        data: $('#set_yckz_Form').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                });
                
                //portal设置保存
                $("#save_portal").click(function(){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "apmController!reExcutePortal",
                        data: $('#set_portalForm').serialize() + "&taskid=" + taskid + "&$mac=" + apmac + "&timestamp=" + new Date().getTime(),
                        success: function(data){
                            alert(data);
                            $("#ap_TabDiv").window('close');
                            window.location.reload();
                        }
                    });
                    
                });
            });
            //mac搜索功能
            function queryApConfigByMac(){
                var mac = $("#mac").val();
                window.location.href = "/wifiplatform/apmController!queryApConfig?mac=" + mac;
            }
            
            //查看设置功能
            function checkSettings(id, type, result, logmac, runtime){
                taskid = id;
                apmac = logmac;
                //判断是否成功
                var flag = result.indexOf("200");
                //最多执行3次
                if (runtime > 2) {
                    flag = 0;
                }
                var data = [];
                //ajax查询后台把该信息查询出来
                var arguments = "id=" + id + "&type=" + type;
                $.post("apmController!queryApConfig.do", arguments, function(data){
                    //将后台数据封装到数组中
                    var text = $.parseJSON(data.toString());
                    if (text[1] == 'portal_set_log') {
                        //把数据进行回显
                        $("#redirect_url").val(text[0].redirect_url);
                        $("#portal_url").val(text[0].portal_url);
                        $("#portal_name").val(text[0].portalname);
                        $("#set_time").val(text[0].set_time);
                        $("#ap_TabDiv").window('open');
                        $("#ap_xieyi").hide();
                        $("#remote_control").hide();
                        $("#ap_whitelist_mac").hide();
                        $("#ap_whitelist").hide();
                        $("#ap_rzsz").hide();
                        $("#ap_authinterval").hide();
                        $("#ap_portal").show();
                        if (flag == 0) {
                            $("#save_portal").css("display", "none");
                        }
                        else 
                            $("#save_portal").css("display", "block");
                    }
                    else 
                        if (text[1] == 'protocol_set_log') {
                            //把数据进行回显
                            if (text[0].authinterval == null){
	                            $("#heartbeat").val(text[0].heartbeat);
	                            $("#authenticate").val(text[0].authenticate);
	                            $("#offline_judge").val(text[0].offline_judge);
	                            $("#visitor_num").val(text[0].visitor_num);
	                            $("#ap_TabDiv").window('open');
	                            $("#ap_whitelist").hide();
	                            $("#ap_whitelist_mac").hide();
	                            $("#ap_portal").hide();
	                            $("#remote_control").hide();
	                            $("#ap_rzsz").hide();
	                            $("#ap_authinterval").hide();
	                            $("#ap_xieyi").show();
	                            if (flag == 0) {
	                                $("#save_xieyi").css("display", "none");
	                            }
	                            else 
	                                $("#save_xieyi").css("display", "block");
                            }
                            else {
                                $("#authinterval").val(text[0].authinterval);
	                            $("#ap_TabDiv").window('open');
	                            $("#ap_whitelist").hide();
	                            $("#ap_whitelist_mac").hide();
	                            $("#ap_portal").hide();
	                            $("#remote_control").hide();
	                            $("#ap_rzsz").hide();
	                            $("#ap_xieyi").hide();  
	                            $("#ap_authinterval").show(); 
	                            if (flag == 0) {
	                                $("#save_authinterval").css("display", "none");
	                            }
	                            else 
	                                $("#save_authinterval").css("display", "block");                            
                            }
                        }
                        else 
                            if (text[1] == 'internet_limit_log') {
                                //把数据进行回显
                                var ip = text[0].whitelist_ip;
                                var array = ip.split(";");
                                var allIp = "";
                                for (var x = 0; x < array.length; x++) {
                                    if (x == array.length - 1) {
                                        allIp += array[x] + "\n";
                                        continue;
                                    }
                                    allIp += array[x] + ";\n"
                                }
                                $("#ap_TabDiv").window('open');
                                $("#ap_portal").hide();
                                $("#remote_control").hide();
                                $("#ap_rzsz").hide();
                                $("#ap_xieyi").hide();
                                $("#ap_authinterval").hide();
                                if (text[0].flag == 'whitelist') {
                                    $("#whitelist_ip").val(allIp);
                                    $("#ap_whitelist_mac").hide();
                                    $("#ap_whitelist").show();
                                }
                                else {
                                    $("#ap_whitelist").hide();
                                    $("#whitelist_ip_mac").val(allIp);
                                    $("#ap_whitelist_mac").show();
                                }
                                if (flag == 0) {
                                    $("#save_whitelist").css("display", "none");
                                }
                                else 
                                    $("#save_whitelist").css("display", "block");
                            }
                            else {
                                var flagArr = "278";
                                $("input[value='" + text[0].cmd_flag + "']").attr("checked", "checked");
                                $("#ap_TabDiv").window('open');
                                $("#ap_xieyi").hide();
                                $("#ap_whitelist").hide();
                                $("#ap_whitelist_mac").hide();
                                $("#ap_portal").hide();
                                $("#ap_authinterval").hide();
                                $("#hidden_cmd").val(text[0].cmd_flag);
                                $("#hidden_cmd2").val(text[0].cmd_flag);
                                if (flagArr.indexOf(text[0].cmd_flag) != -1) {
                                    $("#remote_control").hide();
                                    $("#ap_rzsz").show();
                                }
                                else {
                                    $("#ap_rzsz").hide();
                                    $("#remote_control").show();
                                }
                                if (flag == 0) {
                                    $("#save_rzsz").css("display", "none");
                                }
                                else {
                                    $("#save_rzsz").css("display", "block");
                                }
                                
                            }
                }, "json");
            }
            
            //气泡提示
            var divOn = false;
            var arr = new Array();
            function divOnMouseover(event){
                divOn = true;
            }
            
            function divOnMouseout(event){
                divOn = false;
                setTimeout(function(){
                    if (!divOn) {
                        var div = document.getElementById("popue_div");
                        div.style.visibility = "hidden";
                        arr = new Array();
                    }
                }, 200);
            }
            
            function popueMac(obj, event, tips){
                setTimeout(function(){
                    var div = document.getElementById("popue_div");
                    if (arr.length != 0 || div.style.visibility == 'visible') {
                        return;
                    }
                    var macs = mac.toString().split(":");
                    arr[0] = div;
                    var x = obj.offsetLeft;
                    var y = obj.offsetTop;
                    var ele = obj.offsetParent;
                    var sTop = document.getElementById("up_div").scrollTop;
                    while (ele) {
                        x += ele.offsetLeft;
                        y += ele.offsetTop;
                        ele = ele.offsetParent;
                    }
                    y -= sTop;
                    y = y + obj.offsetHeight;
                    div.style.visibility = "visible";
                    div.style.top = y + "px";
                    div.style.left = x + "px";
                    //上面加内容
                    var tb = $("#popue_div_table");
                    tb.empty();
                    tb.append("<tr><td>" + tips + "</td></tr>");
                }, 200);
            }
            
            function hiddenPopueMac(obj, event){
                setTimeout(function(){
                    if (divOn) {
                        return;
                    }
                    var div = document.getElementById("popue_div");
                    div.style.visibility = "hidden";
                    arr = new Array();
                }, 200);
            }
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
        <div class="AP_wrap">
            <div class="AP_title">
                <ul>
                    <li class="rr">
                        <a href="#">首页</a>
                    </li>
                    <li class="rr">
                        <a href="#">AP管理</a>
                    </li>
                    <li>
                        <a href="${ctx}/apmController!queryApConfig">AP配置</a>
                    </li>
                </ul>
            </div>
            <div class="AP_used">
                <div class="AP_quicksearch">
                    <div class="AP_inpu_search">
                        <input type="text" placeholder="请输入MAC地址进行搜索" id="mac" /><span onclick="queryApConfigByMac()">搜索</span>
                    </div>
                </div>
            </div>
            <div style="height: 500px; overflow: auto; width: 100%;" id="up_div">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" id="data_table" class="AP_table">
                    <tr style="background: #d4e1ee; ">
                        <td width="15%">
                            <div align="center">
                                配置时间
                            </div>
                        </td>
                        <td width="15%">
                            <div align="center">
                                实际执行时间
                            </div>
                        </td>
                        <td width="10%">
                            <div align="center">
                                AP MAC
                            </div>
                        </td>
                        <td width="14%">
                            <div align="center">
                                商家名称
                            </div>
                        </td>
                        <td width="6%">
                            <div align="center">
                                AP配置指令
                            </div>
                        </td>
                        <td width="6%">
                            <div align="center">
                                执行状态
                            </div>
                        </td>
                        <td width="6%">
                            <div align="center">
                                执行次数
                            </div>
                        </td>
                        <td width="8%">
                            <div align="center">
                                操作
                            </div>
                        </td>
                    </tr>
                    <c:forEach items="${logList}" var="log" varStatus="i">
                        <tr id="tr${i}">
                            <td width="15%">
                                <div align="center">
                                    <fmt:formatDate value="${log.set_time}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </div>
                            </td>
                            <td width="15%">
                                <div align="center">
                                    <fmt:formatDate value="${log.execute_time}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </div>
                            </td>
                            <td width="10%">
                                <div align="center">
                                    <a href="${ctx}/apmController!queryap?mac=${log.mac}&pcode=${log.code}">${log.mac}</a>
                                </div>
                            </td>
                            <td width="14%">
                                <div align="center">
                                    ${log.merchant_name}
                                </div>
                            </td>
                            <td width="6%">
                                <div align="center">
                                    ${log.type}
                                </div>
                            </td>
                            <td width="6%">
                                <div align="center" onmouseover="popueMac(this,event,'${log.set_result}')" onmouseout="hiddenPopueMac(this,event)">
                                    <c:if test="${fn:startsWith(log.set_result, '200')}">
                                        成功
                                    </c:if>
                                    <c:if test="${!fn:startsWith(log.set_result, '200')}">
                                        失败
                                    </c:if>
                                </div>
                            </td>
                            <td width="6%">
                                <div align="center">
                                    ${log.runtime}
                                </div>
                            </td>
                            <td width="8%">
                                <div align="center">
                                    <a href="javascript:checkSettings(${log.id},'${log.type }','${log.set_result }','${log.mac}', '${log.runtime}');">查看设置</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <div id="popue_div" style="float: right;visibility:hidden;position:absolute;
 background-color:#BCD2E9;z-index: 9999;
 overflow: auto;width: 190px;"  onmouseover="divOnMouseover()" onmouseout="divOnMouseout()">
            <table id="popue_div_table" style="width: 170px;height: auto;margin-left: 10px;">
            </table>
        </div>
        <div id="ap_TabDiv" class="easyui-window" title="设置" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:500px;height:400px;padding:10px;background-color: #F0FFF0;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center',border:false" style="background-color: #F0FFF0;padding:10px;height:160px">
                    <!--协议设置-->
                    <div id="ap_xieyi" style="display: none">
                        <div id="box" style="border: none;">
                            <form id="set_xieyiForm">
                                <ul class="imglist" style="height: 274px;">
                                    <li style="display: block;" class="news">
                                        <p>
                                            <label>
                                                AP心跳间隔（秒）
                                            </label>
                                            <input name="heartbeat" id="heartbeat" type="text" />
                                        </p>
                                        <p>
                                            <label>
                                                终端检测间隔（秒）
                                            </label>
                                            <input name="authenticate" id="authenticate" type="text" />
                                        </p>
                                        <p>
                                            <label>
                                                访客下线检测次数（次）
                                            </label>
                                            <input name="offline_judge" id="offline_judge" type="text" />
                                        </p>
                                        <p>
                                            <label>
                                                访客数上限（个）
                                            </label>
                                            <input name="visitor_num" id="visitor_num" type="text" />
                                        </p>
                                        <p>
                                            <span style="bottom: 10px; right: 54px;" id="save_xieyi">重新执行</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!-- Portal设置 -->
                    <div id="ap_portal" style="display: none">
                        <div id="box" style="border: none;">
                            <form id="set_portalForm">
                                <ul class="imglist" style="height: 274px;">
                                    <li style="display: block;" class="news">
                                        <p>
                                            <label>
                                                当前认证页面
                                            </label>
                                            <input name="redirect_url" id="redirect_url" type="text" readonly="readonly" />
                                        </p>
                                        <p>
                                            <label>
                                                当前欢迎页面
                                            </label>
                                            <input name="portal_url" id="portal_url" type="text" readonly="readonly" />
                                        </p>
                                        <p style="margin-top: 8px;">
                                            <label>
                                                Portal名称
                                            </label>
                                            <input name="portal_name" id="portal_name" type="text" readonly="readonly" />
                                        </p>
                                        <p>
                                            <span style="bottom: 10px; right: 54px;" id="save_portal">重新执行</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!--白名单设置-->
                    <div id="ap_whitelist" style="display: none">
                        <div id="box" style="border: none;">
                            <form id="whitelist_Form">
                                <ul class="imglist" style="height: 274px;">
                                    <li style="display: block;" class="news">
                                        <p>
                                            <label>
                                                白名单设置:
                                            </label>
                                            <textarea rows="" cols="" id="whitelist_ip" name="whitelist_ip" style ="height:120px;width: 328px;margin-left: 105px;">
                                            </textarea>
                                        </p>
                                        <p>
                                            <span style="bottom: 10px; right: 54px;" id="save_whitelist">重新执行</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!--mac白名单设置-->
                    <div id="ap_whitelist_mac" style="display:none">
                        <div id="box" style="border:none;">
                            <form id="whitelist_Form_mac">
                                <ul class="imglist" style ="height: 224px;margin-top: 40px;">
                                    <li style="display:block;" class="news">
                                        <p>
                                            <label>
                                                mac白名单设置:
                                            </label>
                                        </p>
                                        <textarea rows="" cols="" id="whitelist_ip_mac" name="whitelist_ip" style ="height:120px;width: 328px;margin-left: 105px;">
                                        </textarea>
                                        <p>
                                            <span style="bottom:10px;right:40px;" id="save_whitelist_mac">重新执行</span>
                                        </p>
                                        <input name="flag" type="hidden" value="MAC" />
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!--远程控制-->
                    <div id="remote_control">
                        <div id="box" style="border:none;">
                            <span style="display:block;width:90%;text-align:left;height:8px;line-height:40px;">控制指令:</span>
                            <form id="set_yckz_Form">
                                <input type="hidden" name="cmd_flag" id="hidden_cmd"/>
                                <ul class="imglist" style="height: 242px;">
                                    <li style="display:block;" class="news">
                                        <p style="width: 82%;height:30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="1" style="width: 15px;" disabled="disabled">重启设备
                                        </p>
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="3" style="width: 15px;" disabled="disabled">关闭进程
                                        </p>
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="4" style="width: 15px;" disabled="disabled">进程重启
                                        </p>
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="5" style="width: 15px;" disabled="disabled">远程升级
                                        </p>
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="6" style="width: 15px;" disabled="disabled">文件更新
                                        </p>
                                        <p>
                                            <span style="bottom:10px;right:40px;" id="save_yckz">重新执行</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!-- 认证设置 -->
                    <div id="ap_rzsz" style="display:none">
                        <div id="box" style="border:none;">
                            <span style="display:block;width:90%;text-align:left;height:8px;line-height:40px;">认证设置:</span>
                            <form id="set_rzsz_Form">
                                <input type="hidden" name="cmd_flag" id="hidden_cmd2"/>
                                <ul class="imglist" style="height: 242px;">
                                    <li style="display:block;" class="news">
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="7" style="width: 15px;" disabled="disabled">一次一密
                                        </p>
                                        <p style="width: 82%;height:30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="8" style="width: 15px;" disabled="disabled">一键登录
                                        </p>
                                        <p style="width: 82%;height: 30px;margin:0;margin-left: 88px;">
                                            <input type="radio" name="cmd_flag" value="2" style="width: 15px;" disabled="disabled">免认证
                                        </p>
                                        <p>
                                            <span style="bottom:10px;right:40px;" id="save_rzsz">保存</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <!--认证间隔设置-->
                    <div id="ap_authinterval" style="display: none">
                        <div id="box" style="border: none;">
                            <form id="set_authintervalForm">
                                <ul class="imglist" style="height: 274px;">
                                    <li style="display: block;" class="news">
                                         <p>
                                            <label>
                                                认证间隔(分钟)
                                            </label>
                                            <input name="authinterval" id="authinterval" type="text" />
                                        </p>
                                        
                                        <p>
                                            <span style="bottom: 10px; right: 54px;" id="save_authinterval">重新执行</span>
                                        </p>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
