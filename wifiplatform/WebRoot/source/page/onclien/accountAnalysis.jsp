<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" import="com.sinosoft.onclien.bean.Connections" %>
<%@ page language="java" import="com.sinosoft.onclien.service.impl.OnclienServiceImpl" %>
<%@ page language="java" import="java.text.SimpleDateFormat" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" /> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title></title>
        <link type="text/css" rel="stylesheet" href="${ctx}/source/css/grey.css" />
        <link type="text/css" rel="stylesheet" href="${ctx}/source/css/tab.css" />
        <link type="text/css" rel="stylesheet" href="${ctx}/source/css/easyui/easyui.css" />
        <link rel="stylesheet" type="text/css" href="${ctx}/source/css/easyui/icon.css">
        <link href="${ctx}/source/css/ztree/zTreeStyle.css" rel="stylesheet">
        <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.easyui.min.js">
        </script>
        <script type="text/javascript"> var level = ${sessionScope.user.level}
        </script>
        <script type="text/javascript" src="${ctx}/source/js/highcharts.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery-ui-1.9.2.custom.min.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/selectToUISlider.jQuery.js">
        </script>
        <link rel="stylesheet" href="${ctx}/source/css/jquery-ui-1.7.1.custom.css" type="text/css" />
        <link rel="Stylesheet" href="${ctx}/source/css/ui.slider.extras.css" type="text/css" />
        <style type="text/css">
             * {
                margin: 0;
                padding: 0;
                list-style-type: none;
            }
            
            a, img, fieldset {
                border: 0;
            }
            
            form {
                margin: 0 30px;
            }
            
            fieldset {
                border: 0;
                margin-top: 1em;
            } .ui-slider {
                clear: both;
                top: 2em;
            }
            
            body, p {
                margin: 0;
                padding: 0;
                font-family: '微软雅黑';
            } .ss_wrap {
                width: 100%;
            } .ss_title {
                width: 100%;
                height: 82px;
                background: #e8edf1
            } .ss_title_cont {
                width: 1040px;
                height: 100%;
                margin: 0 auto;
                position: relative;
            } .ss_title_cont p {
                width: 850px;
            } .ss_title_cont p select {
                width: 140px;
                margin-left: 10px;
                font-size: 16px;
                font-family: 微软雅黑;
                color: #45cae6
            } .ss_title_cont img {
                position: absolute;
                right: 90px;
                top: 8px;
                cursor: pointer;
            } .content {
                width: 96%;
                margin: 0 auto;
                background: #e8edf1
            } .one_cont {
                width: 100%;
                margin-top: 15px;
                height: 226px;
                border-top: none;
                background: #fff;
            } .one {
                border: 1px solid #74c1c4;
                height: 191px;
                overflow: auto;
            } .one_title {
                height: 34px;
                background: #e8edf1;
                position: relative;
            } .one_title span {
                display: block;
                height: 34px;
                line-height: 34px;
                padding-left: 10px;
                color: #fff;
                background: url(${ctx}/source/images/one.png) no-repeat;
                width: 250px;
            } .one_title img {
                float: right;
                position: absolute;
                cursor: pointer;
            }
        </style>
        <!--时间轴-->
        <script type="text/javascript">
            $(function(){
                $('#valueA').selectToUISlider({
                    labels: 6
                });
                //fix color 
                fixToolTipColor();
            });
            //purely for theme-switching demo... ignore this unless you're using a theme switcher
            //quick function for tooltip color match
            function fixToolTipColor(){
                //grab the bg color from the tooltip content - set top border of pointer to same
                $('.ui-tooltip-pointer-down-inner').each(function(){
                    var bWidth = $('.ui-tooltip-pointer-down-inner').css('borderTopWidth');
                    var bColor = $(this).parents('.ui-slider-tooltip').css('backgroundColor')
                    $(this).css('border-top', bWidth + ' solid ' + bColor);
                });
            }
        </script>
        <!--下拉框-->
        <script type="text/javascript">
            $(document).ready(function(){
                //初始化下拉框
                initSelect();
                if (level == 1) {
                    initcity();
                }
                if (level == 2) {
                    initdistrict();
                }
            });
            //下拉框初始化
            function initSelect(){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "countController!initSelectProvince.do",
                    success: function(json){
                        var pro = $("#province");
                        pro.empty();
                        pro.append("<option value='0'>选择省份</option>");
                        for (var i = 0; i < json.length; i++) {
                            var option = $("<option value=" + json[i].code + ">" + json[i].name + "</option>");
                            pro.append(option);
                        }
                    }
                });
            }
            
            //初始化市
            function initcity(){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "apmController!init",
                    data: "",
                    success: function(json){
                        var city = $("#city");
                        for (var i = 0; i < json.length; i++) {
                            var option = $("<option value=" + json[i].code + ">" + json[i].name + "</option>");
                            city.append(option);
                        }
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
            
            //初始化地区
            function initdistrict(){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "apmController!init",
                    data: "",
                    success: function(json){
                        var district = $("#district");
                        for (var i = 0; i < json.length; i++) {
                            var option = $("<option value=" + json[i].code + ">" + json[i].name + "</option>");
                            district.append(option);
                        }
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
            
            //省市联动
            function findCity(province){
                var code = province.value;
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "apmController!findCityByCode",
                    data: "code=" + code,
                    success: function(json){
                        var city = $("#city");
                        city.empty();
                        var district = $("#district");
                        district.empty();
                        district.append("<option value=''>选择区域</option>");
                        city.append("<option value=''>选择城市</option>");
                        for (var i = 0; i < json.length; i++) {
                            var option = $("<option value=" + json[i].code + ">" + json[i].name + "</option>");
                            city.append(option);
                        }
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
            
            //市区联动
            function findDistrict(city){
                var code = city.value;
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "apmController!findDistrictByCode",
                    data: "code=" + code,
                    success: function(json){
                        var district = $("#district");
                        district.empty();
                        district.append("<option value=''>选择区域</option>");
                        for (var i = 0; i < json.length; i++) {
                            var option = $("<option value=" + json[i].code + ">" + json[i].name + "</option>");
                            district.append(option);
                        }
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
            
            
            //根据区域查询ap客户统计Rank
            function queryApCusCount(){
                var district = $("#district").val();
                var province = $("#province").val();
                var city = $("#city").val();
                var rank = $("#rank").val();
                var timeInterval = $("#valueA").val();
                if (province == '0') {
                    alert('请选择省份');
                    return;
                }
                if (rank == '99') {
                    alert('请选择排名等级');
                    return;
                }
                var type;
                var code;
                if (district != 0) {
                    code = district;
                    type = '';
                }
                else 
                    if (city != 0) {
                        code = city;
                        type = '1';
                    }
                    else 
                        if (province != 0) {
                            code = province;
                            type = '0';
                        }
                
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "onclien!queryApCusCount.do",
                    data: "code=" + code + "&type=" + type + "&rank=" + rank + "&timeInterval=" + timeInterval,
                    success: function(json){
                        var countTable = $("#countTable");
                        countTable.empty();
                        var html = "";
                        html += "<table width='96%' border='1' style='margin: 0 auto; border: #74c1c4;' id='countTable'>";
                        html += "<tr style='height: 35px; line-height: 44px; background: #d4e1ee;font-size:16px;font-family:微软雅黑;'><td align='center'>MAC</td><td align='center'>商户名称</td><td align='center'>在线客户数量</td><td align='center'>所在区域</td><td align='center'>详细地址</td><td align='center'>日期</td></tr>";
                        for (var i = 0; i < json.length; i++) {
                            html += "<tr style='height: 28px; line-height: 28px;'>" +
                            "<td align='center'><a href='#' onclick='drawLineChart(\"" +
                            json[i].ap_mac.toString() +
                            "\");'>" +
                            json[i].ap_mac +
                            "</a></td>" +
                            "<td align='center'>" +
                            json[i].merchant_name +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].online_num +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].area +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].detail +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].date +
                            "</td>" +
                            "</tr>";
                        }
                        html += "</table>";
                        countTable.html(html);
                        ;
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
        </script>
        <!--作图功能-->
        <script type="text/javascript">
            // 创建点线图
            function drawLineChart(mac){
                $('#container').highcharts({
					chart:{
					    type: 'area',
						width: 1250,
                  		height: 191
					},
                    title: {
                        text: '',
                        x: -20 //center 
                    },
                    xAxis: {
                        labels: {
                            rotation: 315,
                            style: {
                               fontFamily: '微软雅黑',
                               fontSize: '10px'
                            }
                        },
                        categories: ['00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30', '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30', '24:00']
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: '在线客户数 (个)',
                            style: {
                               fontFamily: '微软雅黑',
                               fontSize: '15px'
                            }
                        }
                    },
                    tooltip: {
                        formatter: function(){
                            return this.y > 0 ? '在' + this.x + '的时候有' + this.y + '个在线客户' : '无';
                        }
                    },
                    series: []
                });
                $('#content').show();
                $('#container').show();
                //获取数据
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "onclien!initAPCustomerChart.do",
                    data: "mac=" + mac,
                    success: function(json){
                        var chart = $("#container").highcharts();
                        var result = [];
                        for (var i = 0; i < 48; i++) {
							var flag=true;
							for(var j=0;j<json.length;j++){
								if(json[j].time_interval==i){
									result.push(json[j].online_num);
									flag=false;
								}
							}
							if(flag)
								result.push(0);
                        }
                        chart.addSeries({
                            name: json[0].merchant_name + '（' + mac + '）',
                            data: result
                        }, false);
                        chart.redraw();
                    }
                }, 'json');
            }
        </script>
    </head>
    <body>
        <div class="ss_title">
            <div class="ss_title_cont">
                <p style="height:60px;line-height:60px;">
                    <span style="margin-left: 50px;">区域</span>
                    <select id="province" onchange="findCity(this);">
                        <option value='0'>选择省份</option>
                    </select>
                    <select id="city" onchange="findDistrict(this);">
                        <option value='0'>选择城市</option>
                    </select>
                    <select id="district">
                        <option value='0'>选择区域</option>
                    </select>
                    <span style="margin-left: 30px;">排行榜</span>
                    <select style="margin-left: 10px;" id="rank">
                        <option value='99'>请选择</option>
                        <option value='5'>Top 5</option>
                        <option value='10'>Top 10</option>
                        <option value='20'>Top 20</option>
                    </select>
                </p>
                <a href="#" onclick="queryApCusCount();"><img src="${ctx}/source/images/tongji_btn.png" /></a>
                <form action="#">
                    <fieldset>
                        <label for="valueA" style="display:none;">
                            Start Date:
                        </label>
                        <select name="valueA" id="valueA" style="display:none;">
                            <option value="00:00">00:00</option>
                            <option value="00:30">00:30</option>
                            <option value="01:00">01:00</option>
                            <option value="01:30">01:30</option>
                            <option value="02:00">02:00</option>
                            <option value="02:30">02:30</option>
                            <option value="03:00">03:00</option>
                            <option value="03:30">03:30</option>
                            <option value="04:00">04:00</option>
                            <option value="04:30">04:30</option>
                            <option value="05:00">05:00</option>
                            <option value="05:30">05:30</option>
                            <option value="06:00">06:00</option>
                            <option value="06:30">06:30</option>
                            <option value="07:00">07:00</option>
                            <option value="07:30">07:30</option>
                            <option value="08:00">08:00</option>
                            <option value="08:30">08:30</option>
                            <option value="09:00">09:00</option>
                            <option value="09:30">09:30</option>
                            <option value="10:00">10:00</option>
                            <option value="10:30">10:30</option>
                            <option value="11:00">11:00</option>
                            <option value="11:30">11:30</option>
                            <option value="12:00" selected>12:00  </option>
                            <option value="12:30">12:30</option>
                            <option value="13:00">13:00</option>
                            <option value="13:30">13:30</option>
                            <option value="14:00">14:00</option>
                            <option value="14:30">14:30</option>
                            <option value="15:00">15:00</option>
                            <option value="15:30">15:30</option>
                            <option value="16:00">16:00</option>
                            <option value="16:30">16:30</option>
                            <option value="17:00">17:00</option>
                            <option value="17:30">17:30</option>
                            <option value="18:00">18:00</option>
                            <option value="18:30">18:30</option>
                            <option value="19:00">19:00</option>
                            <option value="19:30">19:30</option>
                            <option value="20:00">20:00</option>
                            <option value="20:30">20:30</option>
                            <option value="21:00">21:00</option>
                            <option value="21:30">21:30</option>
                            <option value="22:00">22:00</option>
                            <option value="22:30">22:30</option>
                            <option value="23:00">23:00</option>
                            <option value="23:30">23:30</option>
                            <option value="24:00">24:00</option>
                        </select>
                    </fieldset>
                </form>
            </div>
        </div>
        <div style="height: 191px;overflow:auto;margin-top: 85px;">
            <table width="96%" border="1" style="margin: 0 auto; border: #74c1c4;" id="countTable">
                <tr style="height: 35px; line-height: 44px; background: #d4e1ee;font-size:16px;font-family:微软雅黑;">
                    <td align="center">
                        MAC
                    </td>
                    <td align="center">
                        商户名称
                    </td>
                    <td align="center">
                        在线客户数量
                    </td>
                    <td align="center">
                        所在区域
                    </td>
                    <td align="center">
                        详细地址
                    </td>
                    <td align="center">
                        日期
                    </td>
                </tr>
                <c:forEach items="${countList}" var="count">
                    <tr style="height: 28px; line-height: 28px;">
                        <td align="center">
                            <a href="#" onclick="drawLineChart('${count.ap_mac}')">${count.ap_mac}</a>
                        </td>
                        <td align="center">
                            ${count.merchant_name}
                        </td>
                        <td align="center">
                            ${count.online_num}
                        </td>
                        <td align="center">
                            ${count.area}
                        </td>
                        <td align="center">
                            ${count.detail}
                        </td>
                        <td align="center">
                            ${count.date}
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div class="content" id="content" style="display:none;">
            <div class="one_cont">
                <div class="one_title">
                    <span>各时段在线客户数曲线</span>
                </div>
                <div class="one">
                    <div id="container" style="height:191px;display:none;">
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
