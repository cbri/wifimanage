<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
	var chart;
	var options;
	var timeInterval = null;
	$(function () {
    $(document).ready(function() {
       Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
       Highcharts.theme = {
			colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'],
			chart: {
				backgroundColor: {
					linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
					stops: [
						[0, 'rgb(255, 255, 255)'],
						[1, 'rgb(240, 240, 255)']
					]
				},
				borderWidth: 2,
				plotBackgroundColor: 'rgba(255, 255, 255, .9)',
				plotShadow: true,
				ignoreHiddenSeries :true,
				plotBorderWidth: 1
			},
			title: {
				style: {
					color: '#000',
					font: 'bold 16px "Trebuchet MS", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 12px "Trebuchet MS", Verdana, sans-serif'
				}
			},
			xAxis: {
				gridLineWidth: 1,
				lineColor: '#000',
				tickColor: '#000',
				labels: {
					style: {
						color: '#000',
						font: '11px Trebuchet MS, Verdana, sans-serif'
					}
				},
				title: {
					style: {
						color: '#333',
						fontWeight: 'bold',
						fontSize: '12px',
						fontFamily: 'Trebuchet MS, Verdana, sans-serif'
					}
				}
			},
			yAxis: {
				minorTickInterval: 'auto',
				lineColor: '#000',
				lineWidth: 1,
				tickWidth: 1,
				tickColor: '#000',
				min:0,
				labels: {
					style: {
						color: '#000',
						font: '11px Trebuchet MS, Verdana, sans-serif'
					}
				},
				title: {
					style: {
						color: '#333',
						fontWeight: 'bold',
						fontSize: '12px',
						fontFamily: 'Trebuchet MS, Verdana, sans-serif'
					}
				}
			},
			legend: {
				itemStyle: {
					font: '9pt Trebuchet MS, Verdana, sans-serif',
					color: 'black'
				},
				itemHoverStyle: {
					color: '#039'
				},
				itemHiddenStyle: {
					color: 'gray'
				}
			},
			labels: {
				style: {
					color: '#99b'
				}
			},
			navigation: {
				buttonOptions: {
					theme: {
						stroke: '#CCCCCC'
					}
				}
			}
		}; 
		//设置主题
        Highcharts.setOptions(Highcharts.theme);
        chart = initChart();
        //窗口关闭时。清掉定时器
        $('#lookFlow_window').window({
	       onBeforeClose:function(){
	       	   //窗口关闭的时候，将MAC清掉
	       	   $("#hidden_mac").val("");
	           $('#lookFlow_window').window('close', true);
	           if(timeInterval != null){
	           		clearInterval(timeInterval);
	           }
	       },
	       onMinimize:function(){ //最小化时清掉所有
	           $('#lookFlow_window').window('close', true);
	       }
	   });
    });
});
/**初始化Chart*/
function initChart(){
	options = {
            chart: {
                type: 'spline',
                renderTo: 'container',
                animation: Highcharts.svg
             },
            title: {
                text: 'AP流量'
            },
            xAxis: {
                type: 'datetime',
                tickPixelInterval: 100
            },
            yAxis: {
                title: {
                    text: '流量(KB)'
                }
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.series.name +'</b><br/>'+
                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+
                        Highcharts.numberFormat(this.y, 2);
                }
            },
            legend: {
	            layout: 'horizontal',
	            align: 'center',
	            verticalAlign: 'bottom',
	            borderWidth: 0
            },
            exporting: {
                enabled: false
            },
            series: [{
                name: '上行流量',
                dataLabels: {
                	enabled: true
            	},
                data: (function() {
                    var data = [],
                        time = (new Date()).getTime(),
                        i;
                    for (i = -5; i <= 0; i++) {
                        data.push({
                            x: time,
                            y: 0
                        });
                    }
                    return data;
                })()
            },{
                name: '下行流量',
                dataLabels: {
                	enabled: true
            	},
                data: (function() {
                    var data = [],
                        time = (new Date()).getTime(),
                        i;
                    for (i = -5; i <= 0; i++) {
                        data.push({
                            x: time,
                            y: 0
                        });
                    }
                    return data;
                })()
            }]
        };
    chart = new Highcharts.Chart(options);
    return chart;
}
</script>
<div id="lookFlow_window" class="easyui-window" title="查看流量" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:650px;height:400px;padding:10px;background-color: #F0FFF0;">
		<div data-options="region:'center',border:false" style="background-color: #F0FFF0;padding:10px;height:290px;overflow: auto;" id="container">
		</div>
		<div data-options="region:'south',border:false" style="background-color: #F0FFF0;text-align:center;padding:5px 0 0;height: 25px;">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:$('#lookFlow_window').window('close');" style="width:80px">关闭</a>
		</div>
		<input type="hidden" id="hidden_mac" value=""/>
</div>