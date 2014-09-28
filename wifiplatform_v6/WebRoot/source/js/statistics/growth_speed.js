



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
								selectedText:'全选',
								 checkAllText:'全选',
						        uncheckAllText:'全不选',
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
							pro.empty();
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								pro.append(option);
								 }
							 $("#province").multiselect({
								 	selectedList:10,
									noneSelectedText:'---请选择省---',
									selectedText:'全选',
								    checkAllText:'全选',
								    uncheckAllText:'全不选',
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
							city.empty();
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								city.append(option);
								 }
							 $("#city").multiselect({
								    selectedList:10,
									noneSelectedText:'---请选择市---',
									selectedText:'全选',
									checkAllText:'全选',
							        uncheckAllText:'全不选',
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
							district.empty();
							 for(var i =0; i<json.length ;i++){
								var option =$("<option value="+json[i].code+">"+json[i].name+"</option>");
								district.append(option);
								 }
							 $("#district").multiselect({
								 	selectedList:10, 
									noneSelectedText:'---请选择区---',
									selectedText:'全选',
									checkAllText:'全选',
							        uncheckAllText:'全不选',
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

	var level = obj.data('level'); //div上存取名/值对数据
	var provincelength = obj.multiselect("getChecked").map(function() { 
        return this.value; 
    }).get();
	
	if(parseInt(level) == 1 && (provincelength.length >1 || provincelength.length ==0)){
			city="";
			district="";
			 $("#city").multiselect('uncheckAll'); //清除
			 $("#city").hide();
			 $("#district").multiselect('uncheckAll'); 
			 $("#district").hide();
		return ;
	}
	
	 nextLevel = parseInt(level)+1, 
     nextDistNode = null,
	 defaultText = ''; 
	 if (parseInt(nextLevel) === 2 ) { 
			 if(provincelength.length == 0 ){
				 $("#city").multiselect('uncheckAll'); 
				 $("#city").hide();
			 }
		 nextDistNode = $('#city'); 
		  defaultText = '请选择市'; 
		  var url = '/wifiplatform/apmController!findCityByCode';
		
	 }else if (parseInt(nextLevel) === 3 ) {
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
	 var selectedArr = obj.multiselect("getChecked").map(function() { 
         return this.value; 
     }).get();
	 var selectedVal = selectedArr.join(',');  //把数组值组成以逗号的分割的字符串
	   if (selectedVal !== '') { 
		   $.post(url,{code:selectedVal}, function(data) { 
			   //findCityByCode
				   var srcData = data; 
				   var obj =  eval("(" + srcData + ")");
				  
				    if(srcData.length > 0){
				    	 nextDistNode.html(''); 
				    	 for (var i =0 ; i<obj.length ; i ++) { 
                             var opt = obj[i] ;
                             nextDistNode.append('<option value="' + opt.code + '">' + opt.name + '</option>'); 
                         }
				    	 nextDistNode.multiselect({ 
                         	selectedList:10, 
							selectedText:'全选',
							checkAllText:'全选',
					        uncheckAllText:'全不选',
                             noneSelectedText: defaultText, 
                             close: function(event, ui) { 
                                 showNextDist($(this)); 
                             } 
                         }).multiselect('refresh');
				    	 
				    }
		   });
	   }
} //..
	 
var province ="";
var city ="";
var district ="";
var timeM ="";
var timeY ="";
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
	//时间选择
	 $("#timeY").multiselect({
		    selectedList:10, 
			noneSelectedText:'---请选择年---',
			selectedText:'选择',
			multiple:false
			});
	 
	  $("#timeM").multiselect({
		    
		  selectedList:10, 
			noneSelectedText:'---请选择月---',
			selectedText:'选择',
			multiple:false
			});
	  
	  
	initAjax();
});		
	
	  

	  //统计
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
				 }else if(province.length > 1){
					 	city="";
						district="";
				 }
		  }
		   timeM = $("#timeM").multiselect("getChecked").map(function() { 
		         return this.value; 
		     }).get();
		   timeY = $("#timeY").multiselect("getChecked").map(function() { 
		         return this.value; 
		     }).get();
		   var timeMY = timeY+"年"+timeM;
		   if(timeY !="" &&  (province != "" || city != ""  || district != "" ) ){
				  $.ajax({
				  		  type: "POST",
						   url:"/wifiplatform/countController!selectHighcharts", 
						   data:"timeM="+timeM+"&timeY="+timeY+"&province="+province+"&city="+city+"&district="+district,
						   success: function(json){
					  			 var obj =  eval("(" + json + ")");
					  			if(json !=""){
					  					dataDispose(obj); //数据组装
					  					ap_count(searchVal_apCount,obj[0].name,timeMY);//AP总数
					  					inconming_total(searchVal_inconming_total,obj[0].name,timeMY); //上行流量
					  					outgoing_total(searchVal_outgoing_total,obj[0].name,timeMY); //下行流量
					  					customer_num(searchVal_customer_num,obj[0].name,timeMY); //累计客户总数
					  					province="";
					  					city="";
					  					district="";
					  					timeM="";
					  					timeY="";
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
		  var lengthVal = 1;
		  if(province !="" && city =="" && district ==""){
			  objarea.push(province);
		  }else if(city !="" && district ==""){
			  objarea.push(city);
		  }else if(district !=""){
			  objarea = $("#district").multiselect("getChecked").map(function() { 
			         return this.value; 
			     }).get();
			 
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
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
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
						if(obj.code == searchVal_apCount[j].num){
							searchVal_apCount[j].name = obj.name;
							searchVal_inconming_total[j].name = obj.name;
							searchVal_outgoing_total[j].name = obj.name;
							searchVal_customer_num[j].name = obj.name;
							if(obj['day_num'] == undefined){ //day_num==undefined时。查询的是年度表。显示12个月数据。表中也没有day_num该字段
								searchVal_apCount[j].data.push({x:parseInt(obj.month_num),y:obj.ap_total});
								searchVal_inconming_total[j].data.push({x:parseInt(obj.month_num),y:obj.inconming_total});
								searchVal_outgoing_total[j].data.push({x:parseInt(obj.month_num),y:obj.outgoing_total});
								searchVal_customer_num[j].data.push({x:parseInt(obj.month_num),y:obj.customer_num});
							}else{
							searchVal_apCount[j].data.push({x:parseInt(obj.day_num),y:obj.ap_total});
							searchVal_inconming_total[j].data.push({x:parseInt(obj.day_num),y:obj.inconming_total});
							searchVal_outgoing_total[j].data.push({x:parseInt(obj.day_num),y:obj.outgoing_total});
							searchVal_customer_num[j].data.push({x:parseInt(obj.day_num),y:obj.customer_num});
							}
						}
					}
					
			}
		  
	  }
	  
function ap_count(searchVal_data,name,month){
		  chart = new Highcharts.Chart({
			  chart: {
			          renderTo: 'ap_total_div',
			          type: 'line',
			          marginBottom: 60,
		              marginTop: 60,
		              height : 240
	    }, title: {
	    	 text:name+ month+"月份   AP总数曲线图",
	    },
			xAxis: {
	    		title:{
	    		text:"日期",
	    		align:"high"
	    		},
				type:'category'
			  },
			yAxis: {
			  min: 0,
			  title: {
			      text: '数量'
			  }
			},
			 tooltip: {
				formatter: function() {
                return '<b>'+  this.y  +'</b><br/>';
                		
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


function inconming_total(searchVal_data,name,month){
	  chart = new Highcharts.Chart({
		  chart: {
		          renderTo: 'inconming_total_div',
		          type: 'line',
		          marginBottom: 60,
	              marginTop: 60,
	              height : 240
  }, title: {
  	 text:name+ month+"月份  上行流量曲线图",
  },
		  xAxis: {
				title:{
				text:"日期",
				align:"high"
				},
				type:'category'
			  },
		yAxis: {
		  min: 0,
		  title: {
		      text: 'MB'
		  }
		},
		 tooltip: {
			formatter: function() {
            return '<b>'+  this.y  +'</b><br/>';
            		
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

function outgoing_total(searchVal_data,name,month){
	  chart = new Highcharts.Chart({
		  chart: {
		          renderTo: 'outgoing_tota_div',
		          type: 'line',
		          marginBottom: 60,
	              marginTop: 60,
	              height : 240
}, title: {
	text:name+ month+"月份  下行流量曲线图",
},
		xAxis: {
			title:{
			text:"日期",
			align:"high"
			},
			type:'category'
		  },
		yAxis: {
		  min: 0,
		  title: {
		      text: 'MB'
		  }
		},
		legend: {
			  borderWidth:0,
			  y:12
	        },
	        tooltip: {
				formatter: function() {
                return '<b>'+  this.y  +'</b><br/>';
                		
        		}
			},
	        credits: {
	        	enabled: false //取消水印
	        	},
		series:searchVal_data
		  });
	  searchVal_outgoing_total=[];
	}


function customer_num(searchVal_data,name,month){
	  chart = new Highcharts.Chart({
		  chart: {
		          renderTo: 'customer_num_div',
		          type: 'line',
		          marginBottom: 60,
	              marginTop: 60,
	              height : 240
}, title: {
	text:name+ month+"月份  累计客户总数曲线图",
},
		xAxis: {
			title:{
			text:"日期",
			align:"high"
			},
			type:'category'
		  },
		yAxis: {
		  min: 0,
		  title: {
		      text: 'MB'
		  }
		},
		legend: {
			  borderWidth:0,
			  y:12
	        },
	        tooltip: {
				formatter: function() {
                return '<b>'+  this.y  +'</b><br/>';
                		
        		}
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
		var province = "110000";
	}else if(level==0){ //省管理员
    	var province = code;
    }else if(level==1){//市管理员
    	var city = code;
    }else if(level==2){//区管理员
    var district = code;
  }
  
  var dd = new Date();
 
  
  var y = dd.getFullYear();//获取当前年份
  
  dd.setMonth(dd.getMonth()-1);//获取上个月份的日期
  var m = dd.getMonth()+1;
var timeYM = y+"年"+m;
	$.ajax({
		type: "POST",
		url: "/wifiplatform/countController!selectHighcharts",
		data: "timeY="+y+"&timeM="+m+"&province=" + province + "&city=" + city + "&district=" + district + "&timestamp=" + new Date().getTime(),
		success: function(json){
		var obj =  eval("(" + json + ")");
			if(obj.length > 0){
					dataDispose_init(obj); //数据组装
					ap_count(searchVal_apCount,obj[0].name,timeYM);//AP总数
					inconming_total(searchVal_inconming_total,obj[0].name,timeYM); //上行流量
					outgoing_total(searchVal_outgoing_total,obj[0].name,timeYM); //下行流量
					customer_num(searchVal_customer_num,obj[0].name,timeYM); //累计客户总数
					province="";
					city="";
					district="";
					timeM="";
					timeY="";
					objarea=[];
					
			}
		}
	}); //$.ajax
	
	function dataDispose_init(jsonArray){
		 var lengthVal = 1;
		  if(province !="" && city =="" && district ==""){
			  objarea.push(province);
		  }else if(city !="" && district ==""){
			  objarea.push(city);
		  }else if(district !=""){
			  objarea = $("#district").multiselect("getChecked").map(function() { 
			         return this.value; 
			     }).get();
			 
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
				    		symbol: 'circle',
				    		radius: 2.5,
				    		lineWidth:2.5}
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
						if(obj.code == searchVal_apCount[j].num){
							searchVal_apCount[j].name = obj.name;
							searchVal_inconming_total[j].name = obj.name;
							searchVal_outgoing_total[j].name = obj.name;
							searchVal_customer_num[j].name = obj.name;
							if(obj['day_num'] == undefined){ //day_num==undefined时。查询的是年度表。显示12个月数据。表中也没有day_num该字段
								searchVal_apCount[j].data.push({x:parseInt(obj.month_num),y:obj.ap_total});
								searchVal_inconming_total[j].data.push({x:parseInt(obj.month_num),y:obj.inconming_total});
								searchVal_outgoing_total[j].data.push({x:parseInt(obj.month_num),y:obj.outgoing_total});
								searchVal_customer_num[j].data.push({x:parseInt(obj.month_num),y:obj.customer_num});
							}else{
							searchVal_apCount[j].data.push({x:parseInt(obj.day_num),y:obj.ap_total});
							searchVal_inconming_total[j].data.push({x:parseInt(obj.day_num),y:obj.inconming_total});
							searchVal_outgoing_total[j].data.push({x:parseInt(obj.day_num),y:obj.outgoing_total});
							searchVal_customer_num[j].data.push({x:parseInt(obj.day_num),y:obj.customer_num});
							}
						}
					}
					
			}
	}
}
 