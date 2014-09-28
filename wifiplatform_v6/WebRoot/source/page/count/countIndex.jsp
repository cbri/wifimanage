<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" /> <!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta charset="utf-8" />
        <title></title>
        <link type="text/css" rel="stylesheet" href="${ctx}/source/countimages/index.css" />
        <script type="text/javascript" src="${ctx}/source/js/jquery-1.9.1.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/jquery.json-2.4.js">
        </script>
        <script type="text/javascript" src="${ctx}/source/js/highcharts.js">
        </script>
        <script type="text/javascript"> var level = ${sessionScope.user.level}
                                
                    
        </script>
        <script type="text/javascript">
            $(document).ready(function(){
				//初始化统计时间
				var now=new Date();
				var Year=parseInt(now.getYear())+1900;
				var Month=parseInt(now.getMonth())+1;
				$("#now").html("截至"+Year+"年" + Month+ "月" +now.getDate()+ "日 1时0分0秒"+"统计数据");
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
                        pro.append("<option value=''>选择省份</option>");
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
                //省级为空回调全国
                if (code == '') {
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "countController!toCountPage.do",
                        data: "flag=true",
                        success: function(json){
                            var countTable = $("#countTable");
                            countTable.empty();
                            var html = "";
                            html += "<table width='96%' border='1' style='margin: 0 auto; border: #74c1c4;' id='countTable'>";
                            html += "<tr style='height: 35px; line-height: 44px; background: #d4e1ee;font-size:16px;font-family:微软雅黑;'><td align='center'>区域</td><td align='center'>AP总数</td><td align='center'>离线数</td><td align='center'>在线数</td><td align='center'>在线比例</td><td align='center'>上行流量(MB)</td><td align='center'>下行流量(MB)</td><td align='center'>客户数</td></tr>";
                            for (var i = 0; i < json.length; i++) {
                                html += "<tr style='height: 20px; line-height: 28px;font-size:14px;font-family:微软雅黑;'>" +
                                "<td align='center'>" +
                                json[i].name +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].ap_total +
                                "</td>" +
                                "<td align='center'>" +
                                (json[i].ap_total - json[i].online_num) +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].online_num +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].online_rate +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].outgoing_total +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].inconming_total +
                                "</td>" +
                                "<td align='center'>" +
                                json[i].customer_num +
                                "</td>" +
                                "</tr>";
                            }
                            html += "</table>";
                            countTable.html(html);
                        },
                        error: function(){
                            if (!confirm('你的访问超时，请重新登陆!')) 
                                return;
                            window.location = '/denglu.jsp';
                        }
                    });
                    return;
                }
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
                //同时查询该省下所有市的统计信息
                initGrowth(code, 0);
            }
            
            //市区联动
            function findDistrict(city){
                var code = city.value;
                //市级为空回调省级
                if (code == '') {
                    var province = $("#province").val();
                    //同时查询该省下所有市的统计信息
                    initGrowth(province, 0);
                    return;
                }
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
                //同时查询该市下所有区的统计信息
                initGrowth(code, 0);
            }
            
            //查询
            function initGrowth(code, level){
                //level不为0且code为0即选择区域为空
                if (level != 0 && code == '') {
                    var city = $("#city").val();
                    initGrowth(city, 0);
                    return;
                }
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "countController!initGrowth.do",
                    data: "code=" + code + "&level=" + level,
                    success: function(json){
                        var countTable = $("#countTable");
                        countTable.empty();
                        var html = "";
                        html += "<table width='96%' border='1' style='margin: 0 auto; border: #74c1c4;' id='countTable'>";
                        html += "<tr style='height: 35px; line-height: 44px; background: #d4e1ee;font-size:16px;font-family:微软雅黑;'><td align='center'>区域</td><td align='center'>AP总数</td><td align='center'>离线数</td><td align='center'>在线数</td><td align='center'>在线比例</td><td align='center'>上行流量(MB)</td><td align='center'>下行流量(MB)</td><td align='center'>客户数</td></tr>";
                        for (var i = 0; i < json.length; i++) {
                            html += "<tr style='height: 20px; line-height: 28px;font-size:14px;font-family:微软雅黑;'>" +
                            "<td align='center'>" +
                            json[i].name +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].ap_total +
                            "</td>" +
                            "<td align='center'>" +
                            (json[i].ap_total - json[i].online_num) +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].online_num +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].online_rate +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].outgoing_total +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].inconming_total +
                            "</td>" +
                            "<td align='center'>" +
                            json[i].customer_num +
                            "</td>" +
                            "</tr>";
                        }
                        html += "</table>";
                        countTable.html(html);
                    },
                    error: function(){
                        if (!confirm('你的访问超时，请重新登陆!')) 
                            return;
                        window.location = '/denglu.jsp';
                    }
                });
            }
        </script>
        <!--highchart作图-->
        <script type="text/javascript">
            var speData = [];
            var categories = ['总数', '在线数', '离线数'];
            var columnX = ['上行总流量', '下行总流量'];
            $(function(){
                draw2DPieChart();
                get2DPieChartData();
                drawColumnChart();
                getColumnChartData();
            });
            //获取圆环图数据
            function get2DPieChartData(){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "countController!initAPChart.do",
                    success: function(json){
                        var data = [];
                        for (var i = 0; i < json.length; i++) {
                            data.push(json[i].ap_total);
                            data.push(json[i].online_num);
                            data.push(json[i].ap_total - json[i].online_num);
                        }
                        for (var i = 0; i < data.length; i++) {
                            speData.push({
                                name: categories[i],
                                y: data[i]
                            })
                        }
                        var chart = $("#left").highcharts();
                        chart.addSeries({
                            name: '',
                            data: speData,
                            size: '80%',
                            innerSize: '60%',
                            dataLabels: {
                                align: 'left',
                                formatter: function(){
                                    return this.y > 1 ? '<b style="font-size:15px;font-family:微软雅黑;">' + this.point.name + ': ' + this.y + '</b>' : null;
                                }
                            }
                        }, false);
                        chart.addSeries({
                            name: 'a',
                            size: '70%'
                        }, false);
                        chart.redraw();
                    }
                }, 'json');
            }
            
            // 创建圆环图
            function draw2DPieChart(){
                $('#left').highcharts({
                    chart: {
                        type: 'pie',
                        borderRadius: '0'
                    },
                    title: {
                        text: '管理域AP总量及在线率',
                        style: {
                            fontFamily: '微软雅黑',
                            fontSize: '20px'
                        }
                    },
                    yAxis: {
                        title: {
                            text: '比例'
                        }
                    },
                    plotOptions: {
                        pie: {
                            shadow: true,
                            center: ['50%', '50%']
                        }
                    },
                    tooltip: {
                        fontSize: '12px'
                    },
                    series: []
                });
            }
            
            //获取流量数据
            function getColumnChartData(){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "countController!initAPChart.do",
                    success: function(json){
                        var result = [];
                        for (var i = 0; i < json.length; i++) {
                            result.push(json[i].outgoing);
                            result.push(json[i].incoming);
                        }
                        var chart = $("#center").highcharts();
                        for (var i = 0; i < result.length; i++) {
                            chart.addSeries({
                                name: columnX[i],
                                data: [result[i]]
                            }, false);
                        }
                        chart.redraw();
                    }
                }, 'json');
            }
            
            // 创建柱状图
            function drawColumnChart(){
                $('#center').highcharts({
                    chart: {
                        type: 'column',
                        borderRadius: '0'
                    },
                    title: {
                        text: '管理域AP总流量',
                        style: {
                            fontFamily: '微软雅黑',
                            fontSize: '20px'
                        }
                    },
                    legend: {
                        align: 'center',
                        itemStyle: {
                            fontFamily: '微软雅黑',
                            fontSize: '14px'
                        }
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: '流量 (mb)',
                            style: {
                                fontFamily: '微软雅黑',
                                fontSize: '15px'
                            }
                        }
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:10px"></span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0;font-size:15px;font-family:微软雅黑;">{series.name}: </td>' +
                        '<td style="padding:0"><b style="font-size:15px;font-family:微软雅黑;">{point.y} mb</b></td></tr>',
                        footerFormat: '</table>',
                        useHTML: true
                    },
                    series: []
                });
            }
        </script>
    </head>
    <body>
        <div class="wrap" >
        	<div align="center" id="now" style="font-size:24px;font-family:微软雅黑;">
        	</div>
            <div class="title">
                <div class="left" id="left">
                </div>
                <div class="center" id="center">
                </div>
                <div class="right" style="background:white;">
                    <table background="white" width="100%">
                        <tr align="center" width="100%">
                            <td align="center">
                                <img src="${ctx}/source/countimages/kehushu.png" width="100%"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b style="font-size:25px;color:#0D233A;padding-left:38px;font-family:微软雅黑;">管理域客户总数</b>
                                <br>
                                <p align="right">
                                    <b style="font-size:61px;color:#0D233A;padding-right:32px;font-family:微软雅黑;">${customerTotal}</b>
                                </p>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="line">
            </div>
            <div class="city_select">
                <select style="margin-left: 200px;font-size:16px;font-family:微软雅黑;" id="province" onchange="findCity(this);">
                    <option>选择省份</option>
                </select>
                <select style="margin-left: 200px;font-size:16px;font-family:微软雅黑;" id="city" onchange="findDistrict(this);">
                    <option value="0">选择城市</option>
                </select>
                <select style="margin-left: 200px;font-size:16px;font-family:微软雅黑;" id="district" onchange="initGrowth(this.value,1)">
                    <option value="0">选择地区</option>
                </select>
            </div>
            <div style="height:220px;overflow:auto" id="countTable">
                <table width="96%" border="1" style="margin: 0 auto; border: #74c1c4;">
                    <tr style="height: 35px; line-height: 44px; background: #d4e1ee;font-size:16px;font-family:微软雅黑;">
                        <td align="center">
                            区域
                        </td>
                        <td align="center">
                            AP总数
                        </td>
                        <td align="center">
                            离线数
                        </td>
                        <td align="center">
                            在线数
                        </td>
                        <td align="center">
                            在线比例
                        </td>
                        <td align="center">
                            上行流量(MB)
                        </td>
                        <td align="center">
                            下行流量(MB)
                        </td>
                        <td align="center">
                            客户数
                        </td>
                    </tr>
                    <c:forEach var="count" items="${countList}">
                        <tr style="height: 20px; line-height: 28px;font-size:14px;font-family:微软雅黑;">
                            <td align="center">
                                ${count.name }
                            </td>
                            <td align="center">
                                ${count.ap_total }
                            </td>
                            <td align="center">
                                ${count.ap_total-count.online_num }
                            </td>
                            <td align="center">
                                ${count.online_num }
                            </td>
                            <td align="center">
                                ${count.online_rate }
                            </td>
                            <td align="center">
                                ${count.outgoing_total }
                            </td>
                            <td align="center">
                                ${count.inconming_total }
                            </td>
                            <td align="center">
                                ${count.customer_num }
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </body>
</html>
