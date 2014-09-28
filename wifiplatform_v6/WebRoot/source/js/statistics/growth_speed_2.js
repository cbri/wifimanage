



//根据省代码查找市
function findCityByCode(obj){
	var code=obj.value;
	$.ajax({
  		type: "POST",
  	 	dataType:"json",   
		   url:"apmController!findCityByCode", 
		   data:"code="+code,
		   success: function(json){
							var city =$("#city");
							city.empty();
							city.append("<option value=''>选择城市</option>");
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								city.append(option);
								 }	
		   },
		   error:function(){  
			   if(!confirm('你的访问超时，请重新登陆!')) return;
				 window.location='/denglu.jsp';
			 } 
});
}

//初始化全国省
function initprovince(){
	$.ajax({
  		type: "POST",
  	 	dataType:"json",   
		   url:"/wifiplatform/apmController!initProvince2", 
		   data:"",
		   success: function(json){
							var pro =$("#province");
							pro.empty();
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								$("#province").append(option);
								 }
							$("#province").multiselect({
								selectedList:10, 
									noneSelectedText:'---请选择省---',
									selectedText:'选择',
									multiple:false,
						        close: function(event, ui) { 
				                	showNextDist($(this)); 
				            	} 
							 }).multiselect('refresh'); 
				}
	});
}

//初始化省份
function init(){
	$.ajax({
  		type: "POST",
  	 	dataType:"json",   
		   url:"/wifiplatform/apmController!init", 
		   data:"timestamp=" + new Date().getTime(),
		   success: function(json){
							var pro =$("#province");
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								pro.append(option);
								 }
							 $("#province").multiselect({
								 	selectedList:10, 
									noneSelectedText:'---请选择省---',
									selectedText:'选择',
									multiple:false,
							        close: function(event, ui) { 
					                	showNextDist($(this)); 
					            	} 
								 }).multiselect('refresh'); 
				}
		});
	
	}


//初始化市
function initcity(){
	$.ajax({
  		type: "POST",
  	 	dataType:"json",   
		   url:"/wifiplatform/apmController!init", 
		   data:"",
		   success: function(json){
							var city =$("#city");
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								city.append(option);
								 }
							 $("#city").multiselect({
								    selectedList:10, 
									noneSelectedText:'---请选择市---',
									selectedText:'选择',
									multiple:false,
							        close: function(event, ui) { 
					                	showNextDist($(this)); 
					            	} 
								 }).multiselect('refresh'); 
		   },
		   error:function(){  
			   if(!confirm('你的访问超时，请重新登陆!')) return;
				 window.location='/denglu.jsp';
			 } 
});
}
//初始化地区
function initdistrict(){
	$.ajax({
  		type: "POST",
  	 	dataType:"json",   
		   url:"/wifiplatform/apmController!init", 
		   data:"",
		   success: function(json){
							var district =$("#district");
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								district.append(option);
								 }
							 $("#district").multiselect({
								 	selectedList:10, 
									noneSelectedText:'---请选择区---',
									selectedText:'选择',
									multiple:false,
							        close: function(event, ui) { 
					                	showNextDist($(this)); 
					            	} 
								 }).multiselect('refresh'); 
		   },
		   error:function(){  
			   if(!confirm('你的访问超时，请重新登陆!')) return;
				 window.location='/denglu.jsp';
			 } 
});
}

var showNextDist = function(obj){
 if (obj != null) {
 	var level = obj.data('level'); //div上存取名/值对数据
		var provincelength = obj.multiselect("getChecked").map(function(){
			return this.value;
		}).get();
		
		if(parseInt(level) == 1 &&  provincelength.length ==0){
			city="";
			district="";
			 $("#city").multiselect('uncheckAll'); //清除
			 $("#city").hide();
			 $("#district").multiselect('uncheckAll'); 
			 $("#district").hide();
		return ;
	}
	
		nextLevel = parseInt(level) + 1, nextDistNode = null, defaultText = '';
		if (parseInt(nextLevel) === 2) {
			nextDistNode = $('#city');
			defaultText = '请选择市';
			var url = '/wifiplatform/apmController!findCityByCode';
		
		}
		else if (parseInt(nextLevel) === 3) {
				if(provincelength.length == 0 ){
			 $("#district").multiselect('uncheckAll'); 
			 $("#district").hide();
		 }
				nextDistNode = $('#district');
				defaultText = '请选择区';
				var url = '/wifiplatform/apmController!findDistrictByCode';
			//nextDistNode.show();
			}else if(parseInt(nextLevel) === 4){
		 if(provincelength.length == 0 ){
			 $("#district").multiselect('uncheckAll'); 
			 $("#district").hide();
			 return;
		 }
		 return;
	 }
		var selectedArr = obj.multiselect("getChecked").map(function(){
			return this.value;
		}).get();
		var selectedVal = selectedArr.join(','); //把数组值组成以逗号的分割的字符串
		if (selectedVal !== '') {
			$.post(url, {
				code: selectedVal
			}, function(data){
				//findCityByCode
				var srcData = data;
				var obj = eval("(" + srcData + ")");
				
				if (srcData.length > 0) {
					nextDistNode.html('');
					nextDistNode.append('<option value="">---请选择---</option>');
					for (var i = 0; i < obj.length; i++) {
						var opt = obj[i];
						nextDistNode.append('<option value="' + opt.code + '">' + opt.name + '</option>');
					}
					nextDistNode.multiselect({
						selectedList: 10,
						selectedText: '选择',
						multiple: false,
						noneSelectedText: defaultText,
						close: function(event, ui){
							showNextDist($(this));
						}
					}).multiselect('refresh');
					
				}
			});
		}
	}
} //..


var province ="";
var city ="";
var district ="";
var timeM = new Array();
var timeD = new Array();
$(document).ready(function (){
	
	//判断用户level,显示高级查询省市区三级联动初始化
	
	if(parent_userid==0){ //超级管理员
		initprovince();	
	}else if(level==0){ //省管理员
    	init(); 
    }else if(level==1){//市管理员
    	$("#provinceTD").remove();
    	initcity();
    }else if(level==2){//区管理员
    	$("#provinceTD").remove();
    	$("#cityTD").remove();
    	initdistrict();
        }
		initAjax();///初始展示数据
		
});
		
	//redio 月份、日期切换显示隐藏
	$("input[name=radio]").bind("click",function(){
			var $radio = $(this).val();
			if($radio=="time_d"){
				$("input[name='time_m']").each(function(i,obj){
						$(obj).val("");
						$(obj).attr("disabled",true);
				});
				$("input[name='time_d']").each(function(i,obj){
						$(obj).attr("disabled",false);
				});
			}else if($radio=="time_m"){
				$("input[name='time_d']").each(function(i,obj){
					    $(obj).val("");
						$(obj).attr("disabled",true); 
				});
				$("input[name='time_m']").each(function(i,obj){
						$(obj).val("");
						$(obj).attr("disabled",false);
				});
				
			}
	});
	
	  selectHighcharts = function (){
	  	 if(level==1){ //市管理员
			  city = $("#city").multiselect("getChecked").map(function() { 
			         return this.value; 
			     }).get();
			  district = $("#district").multiselect("getChecked").map(function() { 
			         return this.value; 
			     }).get();
		  }else if(level==2){//区管理员
			  district = $("#district").multiselect("getChecked").map(function() { 
			         return this.value; 
			     }).get();
		  }else{
					  		province = $("#province").multiselect("getChecked").map(function() { 
					         return this.value; 
					     }).get();
					 
					 if(province.length == 1) {
						 city = $("#city").multiselect("getChecked").map(function() { 
					         return this.value; 
					     }).get();
						 if(city.length == 1){
						 	 district = $("#district").multiselect("getChecked").map(function() { 
					         return this.value; 
					     }).get();
						 }else{
						 	city="";
							district="";
						 }
					 }else{
						 	city="";
							district="";
					 }
		  }
		 
		 
		 
		  $("input[name='time_m']").each(function(i,obj){
						if($(obj).val() != "")timeM.push($(obj).val());
				});
				 $("input[name='time_d']").each(function(i,obj){
						if($(obj).val() != "")timeD.push($(obj).val());
				});
				
		   if(timeM.length >0 | timeD.length >0 && (province != "" || city != ""  || district != "" ) ){
		   		var strTimeM = timeM.join(","); 
				var strTimeD = timeD.join(",");
				  $.ajax({
				  		  type: "POST",
						   url:"/wifiplatform/countController!Highcharts2", 
						  data:"strTimeM="+strTimeM+"&strTimeD="+strTimeD+"&province="+province+"&city="+city+"&district="+district+"&timestamp=" + new Date().getTime(),
						   success: function(json){
					  			 var obj =  eval("(" + json + ")");
					  			if(json !=""){
					  					dataDispose(obj); //数据组装
					  					ap_count(searchVal_apCount,obj[0].name);//AP总数
										inconming_total(searchVal_inconming_total,obj[0].name); //上行流量
										outgoing_total(searchVal_outgoing_total,obj[0].name); //下行流量
										customer_num(searchVal_customer_num,obj[0].name); //累计客户总数
					  					province="";
					  					city="";
					  					district="";
										timeM =[];
										timeD =[];
					  					objarea=[];
					  			}else{
					  				alert("无数据!")
					  			}
				   			} 
				  	  }); //$.ajax
		   }
	  }
	  
	  var searchVal_apCount = new Array();
	  var searchVal_inconming_total = new Array();
	  var searchVal_outgoing_total  = new Array();
	  var searchVal_customer_num  = new Array();
	  var objarea = new Array();
 
	  function  dataDispose(jsonArray){
		  if(timeM.length >0 && timeD.length == 0){
		  	 for(var m = 0 ; m <jsonArray.length ; m++ ){
			 	objarea.push(jsonArray[m].stat_date);
			 }
		  }else if(timeD.length >0 && timeM.length == 0){
			    for(var d = 0 ; d <jsonArray.length ; d++ ){
			 	objarea.push(jsonArray[d].stat_date);
			 }
		  }
		  for(var a = 0 ; a<objarea.length; a++ ){
			  searchVal_apCount.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条 ---AP总数
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle'
				    		}
						}
				}});
			  searchVal_inconming_total.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---上行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});
			  searchVal_outgoing_total.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---下行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});  
			  
			  searchVal_customer_num.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---下行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});  
		  }
		  for(var i = 0; i<jsonArray.length;i++){
				var obj = jsonArray[i];
				for(var j= 0;j<searchVal_apCount.length;j++){
						if(obj['stat_date'] != undefined && obj.stat_date == searchVal_apCount[j].num ){
								searchVal_apCount[j].name = obj.stat_date;
								searchVal_inconming_total[j].name = obj.stat_date;
								searchVal_outgoing_total[j].name = obj.stat_date;
								searchVal_customer_num[j].name = obj.stat_date;
								searchVal_apCount[j].data.push({x:parseInt('1'),y:obj.ap_total});
								searchVal_inconming_total[j].data.push({x:parseInt('1'),y:obj.inconming_total});
								searchVal_outgoing_total[j].data.push({x:parseInt('1'),y:obj.outgoing_total});
								searchVal_customer_num[j].data.push({x:parseInt('1'),y:obj.customer_num});
						}
					}
					
			}
		  
	  }
	  
	  
function ap_count(searchVal_data,name){
		  chart = new Highcharts.Chart({
			  chart: {
			          renderTo: 'ap_total_div',
			          type: 'column',
		        	  marginBottom: 60,
		              marginTop: 60,
		              height : 240
	    }, 
		title: {
	    	 text:name+" AP总数对比柱状图",
	    },
//		 subtitle: { 
//            	text: name 
//                x: -20
//            },
		plotOptions:{
					  	column:{
							pointWidth: 30
						}
					  },
			 xAxis: {
        	 type: 'datetime',
             tickPixelInterval: 110, //x轴 标记之间的像素距离
             gridLineWidth : 0,
      	   labels: {
		   	style:{
				color:'white'
			},
          formatter: function() {
     	Highcharts.setOptions({global:{useUTC : false}}); 
     	 return  Highcharts.dateFormat('%m-%d',this.value);
             }
          }
    	},
			yAxis: {
			  min: 0,
			  title: {
			      text: '数量（个）'
			  }
			},
			tooltip: {
            	formatter: function() {
                return '<b>'+ this.series.name +' : '+ (this.y)+'</b>';
        		}
            },
			legend: {
				  borderWidth:0,
				  y:12
		        },
		   credits: {
		        	enabled: false //取消水印
		        	},
			series:searchVal_data
			  });
		  searchVal_apCount=[]; 
	}




function inconming_total(searchVal_data,name){
	    chart = new Highcharts.Chart({
			  chart: {
			          renderTo: 'inconming_total_div',
			          type: 'column',
		        	  marginBottom: 60,
		              marginTop: 60,
		              height : 240
	    }, title: {
	    	 text:name+" 上行流量对比柱状图",
	    },
		plotOptions:{
					  	column:{
							pointWidth: 30
						}
					  },
			 xAxis: {
        	 type: 'datetime',
      	   labels: {
		   	style:{
				color:'white'
			},
          formatter: function() {
     	Highcharts.setOptions({global:{useUTC : false}}); 
     	 return  Highcharts.dateFormat('%m-%d',this.value);
             }
          },
        gridLineWidth :0
    	},
			yAxis: {
			  min: 0,
			  title: {
			      text: 'MB'
			  }
			},
			tooltip: {
            	formatter: function() {
                return '<b>'+ this.series.name +' : '+ (this.y)+'</b>';
        		}
            },
			legend: {
				  borderWidth:0,
				  y:12
		        },
		   credits: {
		        	enabled: false //取消水印
		        	},
			series:searchVal_data
			  });
	  searchVal_inconming_total=[]
		
}

function outgoing_total(searchVal_data,name){
	   chart = new Highcharts.Chart({
			  chart: {
			          renderTo: 'outgoing_tota_div',
			          type: 'column',
		        	  marginBottom: 60,
		              marginTop: 60,
		              height : 240
	    }, title: {
	    	 text:name+" 下行流量对比柱状图",
	    },
			plotOptions:{
					  	column:{
							pointWidth: 30
						}
					  },
			 xAxis: {
        	 type: 'datetime',
      	   labels: {
		   	style:{
				color:'white'
			},
          formatter: function() {
     	Highcharts.setOptions({global:{useUTC : false}}); 
     	 return  Highcharts.dateFormat('%m-%d',this.value);
             }
          },
        gridLineWidth :0
    	},
			yAxis: {
			  min: 0,
			  title: {
			      text: 'MB'
			  }
			},
			tooltip: {
            	formatter: function() {
                return '<b>'+ this.series.name +' : '+ (this.y)+'</b>';
        		}
            },
			legend: {
				  borderWidth:0,
				  y:12
		        },
		   credits: {
		        	enabled: false //取消水印
		        	},
			series:searchVal_data
			  });
	  searchVal_outgoing_total=[];
	}


function customer_num(searchVal_data,name){
	   chart = new Highcharts.Chart({
			  chart: {
			          renderTo: 'customer_num_div',
			          type: 'column',
		        	  marginBottom: 60,
		              marginTop: 60,
		              height : 240	  
	    }, title: {
	    	 text:name+" 累计客户总数对比柱状图",
	    },
			plotOptions:{
					  	column:{
							pointWidth: 30
						}
					  },
			xAxis: {
        	 type: 'datetime',
      	   labels: {
		   	style:{
				color:'white'
			},
          formatter: function() {
     	Highcharts.setOptions({global:{useUTC : false}}); 
     	 return  Highcharts.dateFormat('%m-%d',this.value);
             }
          },
        gridLineWidth :0
    	},
			yAxis: {
			  min: 0,
			  title: {
			      text: '数量(个)'
			  }
			},
			tooltip: {
            	formatter: function() {
                return '<b>'+ this.series.name +' : '+ (this.y)+'</b>';
        		}
            },
			legend: {
				  borderWidth:0,
				  y:12
		        },
		   credits: {
		        	enabled: false //取消水印
		        	},
			series:searchVal_data
			  });
	  searchVal_customer_num=[];
	
	}
	
	



///初始展示数据 待定
var initAjax = function(){
	var province = "";
	var city = "";
	var district = "";
	if(parent_userid==0){ //超级管理员
		var province = code;
	}else if(level==0){ //省管理员
    	var province = code;
    }else if(level==1){//市管理员
    	var city = code;
    }else if(level==2){//区管理员
    var district = code;
  }
  
  
  function GetDateStr(AddDayCount) {
    var dd = new Date();
    dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期
    var y = dd.getFullYear();
    var m = dd.getMonth()+1;//获取当前月份的日期
    var d = dd.getDate();
    return y+"-"+m+"-"+d;
}
var time1 = GetDateStr(-2);
var time2 = GetDateStr(-1);   
var myDate = time1+","+time2; //默认昨天和前天数据对比

	$.ajax({
		type: "POST",
		url: "/wifiplatform/countController!Highcharts2",
		data: "strTimeM=&strTimeD="+myDate+"&province=" + province + "&city=" + city + "&district=" + district + "&timestamp=" + new Date().getTime(),
		success: function(json){
			var obj = eval("(" + json + ")");
			if(obj.length > 0){
				dataDispose_init(obj); //数据组装
				ap_count(searchVal_apCount,obj[0].name);//AP总数
				inconming_total(searchVal_inconming_total,obj[0].name); //上行流量
				outgoing_total(searchVal_outgoing_total,obj[0].name); //下行流量
				customer_num(searchVal_customer_num,obj[0].name); //累计客户总数
				province = "";
				city = "";
				district = "";
				timeM = [];
				timeD = [];
				objarea = [];
			}
		}
	}); //$.ajax
	function dataDispose_init(jsonArray){
		  	 for(var m = 0 ; m <jsonArray.length ; m++ ){
			 	objarea.push(jsonArray[m].stat_date);
			 }
		  
		  for(var a = 0 ; a<objarea.length; a++ ){
			  searchVal_apCount.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条 ---AP总数
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle'
				    		}
						}
				}});
			  searchVal_inconming_total.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---上行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});
			  searchVal_outgoing_total.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---下行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});  
			  
			  searchVal_customer_num.push({name:'',data:[],num:objarea[a],marker: { //先定义线条名称和空线条---下行流量
					enabled: false,
					radius:3,
					states: {
				    	hover: {
					 	   lineColor: '#FF0000',
					 	   fillColor:"#FF0000",
				    		enabled: true,
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
						}
				}});  
		  }
		  for(var i = 0; i<jsonArray.length;i++){
				var obj = jsonArray[i];
				for(var j= 0;j<searchVal_apCount.length;j++){
						if(obj['stat_date'] != undefined && obj.stat_date == searchVal_apCount[j].num ){
								searchVal_apCount[j].name = obj.stat_date;
								searchVal_inconming_total[j].name = obj.stat_date;
								searchVal_outgoing_total[j].name = obj.stat_date;
								searchVal_customer_num[j].name = obj.stat_date;
								searchVal_apCount[j].data.push({x:parseInt('1'),y:obj.ap_total});
								searchVal_inconming_total[j].data.push({x:parseInt('1'),y:obj.inconming_total});
								searchVal_outgoing_total[j].data.push({x:parseInt('1'),y:obj.outgoing_total});
								searchVal_customer_num[j].data.push({x:parseInt('1'),y:obj.customer_num});
						}
					}
					
			}
		  
	  }
	  
}