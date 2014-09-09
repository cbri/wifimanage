//4种div设置关闭功能
$(document).ready(function () {

	$('.close').click(function () {
		$(this).parent().hide();
	});
	
	$("#buttonAdd").click(function(){
		var ip=$("#whitelist_ip_yz").val();
		var a =/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
		if(a.test(ip)){
		$("#whitelist_ip").val(function(){
			return this.value+$("#whitelist_ip_yz").val()+";\n"
		});
		$("#whitelist_ip_yz").val("");
		}else{
			$(this).val('');
		}
	});
	
	$("#buttonAdd_mac").click(function(){
		var ip=$("#whitelist_ip_yz_mac").val();
		var a = /[A-F\d]{2}:[A-F\d]{2}:[A-F\d]{2}:[A-F\d]{2}:[A-F\d]{2}:[A-F\d]{2}/;
		if(a.test(ip)){
		$("#whitelist_ip_mac").val(function(){
			return this.value+$("#whitelist_ip_yz_mac").val()+";\n"
		});
		$("#whitelist_ip_yz_mac").val("");
		}else{
			$(this).val('');
		}
	});
	
});

//切换下拉控制
ap_setTab = function (i){
	switch (i) {
	  case '1': 
		  	  $("#ap_xieyi").show();$("#ap_whitelist").hide();$("#ap_portal").hide();$("#ap_ycsj").hide();$("#ap_yckz").hide(); $("#ap_whitelist_mac").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	    break;
	  case '2': $("#ap_portal").show();$("#ap_xieyi").hide();$("#ap_whitelist").hide();$("#ap_ycsj").hide();$("#ap_yckz").hide(); $("#ap_whitelist_mac").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	    break;
	  case '3': $("#ap_whitelist").show();$("#ap_xieyi").hide();$("#ap_portal").hide();$("#ap_ycsj").hide();$("#ap_yckz").hide(); $("#ap_whitelist_mac").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	    break;
	  case '4': $("#ap_ycsj").show(); $("#ap_xieyi").hide();$("#ap_portal").hide();$("#ap_whitelist").hide();$("#ap_yckz").hide(); $("#ap_whitelist_mac").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	  break;
	  case '5': $("#ap_yckz").show(); $("#ap_xieyi").hide();$("#ap_portal").hide();$("#ap_ycsj").hide();$("#ap_whitelist").hide(); $("#ap_whitelist_mac").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	  break;
	  case '6': $("#ap_whitelist_mac").show(); $("#ap_xieyi").hide();$("#ap_whitelist").hide();$("#ap_portal").hide();$("#ap_ycsj").hide(); $("#ap_yckz").hide();$("#ap_rzsz").hide();$("#ap_authinterval").hide();
	  break;
	  case '7': $("#ap_rzsz").show();$("#ap_whitelist_mac").hide(); $("#ap_xieyi").hide();$("#ap_whitelist").hide();$("#ap_portal").hide();$("#ap_ycsj").hide(); $("#ap_yckz").hide();$("#ap_authinterval").hide();
	  break;
	  case '8': $("#ap_authinterval").show();$("#ap_whitelist_mac").hide(); $("#ap_xieyi").hide();$("#ap_whitelist").hide();$("#ap_portal").hide();$("#ap_ycsj").hide(); $("#ap_yckz").hide();$("#ap_rzsz").hide();
	  break;
	}
	
}

var Pdata ="";
onPortalidName = function (obj){
		for(var i =0; i<Pdata.length ;i++){
			var data = Pdata[i].id+","+Pdata[i].portal_name;
			 if(obj==data){
				 $("#redirect_url").val(Pdata[i].redirect_url);
				 $("#portal_url").val(Pdata[i].portal_url);
			 }
		}
	}



//打开窗口
var flg =false;
ap_setAll = function(id,mac,merchant_id){ 
	
	 //回显
	$.ajax({
   		type: "POST",
   	 	dataType:"json",   
   	 	cache:false,
	   url:"apmController!ap_TabShow", 
	   data:"&$id="+id+"&timestamp=" + new Date().getTime(),
	   success: function(data){
			
		for(var x = 0 ; x<data.length ; x ++){
			 var obj = data[x];
			 if(obj.setProtocolList.length >0){
				    $("#heartbeat").val(obj.setProtocolList[0].checkinterval);
			 		$("#authenticate").val(obj.setProtocolList[0].authinterval);
			 		$("#offline_judge").val(obj.setProtocolList[0].httpmaxconn);
			 		$("#visitor_num").val(obj.setProtocolList[0].clienttimeout);
			 }if(obj.whitelistList.length >0){
						 var ip = obj.whitelistList[0].publicip;
					 		var array= ip.split(";");
					 		var allIp = "";
					 		for(var x = 0 ; x<array.length ; x++){
					 				allIp +=array[x]+";\n"
					 		}
					 		$("#whitelist_ip").val(allIp);
			 }if(obj.whitelistList_mac.length >0){
				 var ip = obj.whitelistList_mac[0].publicip;
			 		var array= ip.split(";");
			 		var allIp = "";
			 		for(var x = 0 ; x<array.length ; x++){
			 				allIp +=array[x]+";\n"
			 		}
			 		$("#whitelist_ip_mac").val(allIp);
			 } if(obj.portalList.length >0){
							//当前认证页面和当前欢迎页面有值的情况下，下拉菜单不可选择，无法进行Portal设置
							 if(obj.portalList[0].redirect_url!="" && obj.portalList[0].portal_url!=""){
								 $("#redirect_url").val(data[0].portalList[0].redirect_url);
						 			$("#portal_url").val(data[0].portalList[0].portal_url);
						 			$("#redirect_url").attr("disabled","disabled");
						 			$("#portal_url").attr("disabled","disabled");
						 			$("#portalidName").attr("disabled","disabled");
						 			$("#set_time").attr("disabled","disabled");
						 			$("#save_portal").hide();
							 }if(obj.portalList[0].redirect_url =="" && obj.portalList[0].portal_url ==""){
								 $("#redirect_url").attr("readonly","readonly"); 
						 			$("#portal_url").attr("readonly","readonly");
						 			$.ajax({
						 		   		type: "POST",
						 		   	 	dataType:"json",   
						 		   	 	cache:false,
						 		   	 	url:"apmController!portal_TF", 
						 			   data:"timestamp=" + new Date().getTime(),
						 			   success: function(data){
						 				alert(data =="");
						 				if(data !=""){
						 					Pdata = data;
						 						var portalidName =$("#portalidName");
						 						portalidName.empty();
						 						portalidName.append("<option>---请选择---</option>");
						 						 for(var i =0; i<data.length ;i++){
						 							var option =$("<option value="+data[i].id+","+data[i].portal_name+">"+data[i].portal_name+"</option>"); 
						 							portalidName.append(option);
						 						 }
						 					}else{
						 						$("#save_portal").hide();
						 					}
						 				}
						 			});
							 }
							//当前认证页面和当前欢迎页面为空的情况下，显示当前登录用户管辖区域内的Portal名称。
			 		}
			
		}
		}
	});	
	

	
	$("#ap_TabDiv").window('open');
	 if(flg){
		 return;
	 }
	 flg = true;
	 

	//协议保存
		$.ajaxSetup({cache:false});
		 $("#save_xieyi").click(function(){
			 $("#set_xieyiForm input").each(function(i){
				  if(this.value==""){
					  return false;
				  }else{
					  $.ajax({
		  			   		type: "POST",
		  			   	 	dataType:"json",   
		  			   	 	cache:false,
		  				   url:"apmController!saveSetProtocol", 
		  				   data:$('#set_xieyiForm').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
		  				   success: function(data){
		  				 alert(data[0].code);
		  				 		$("#ap_TabDiv").window('close');
		  					}
		  			});
				  }
				  return false;
			 });
  			
  		});
		 
		 //白名单
		 $("#save_whitelist").click(function(){
			 $.ajax({
			   		type: "POST",
			   	 	dataType:"json",   
				   url:"apmController!saveWhitelist", 
				   data:$('#whitelist_Form').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
				   success: function(data){
						 alert(data[0].code);
						 $("#ap_TabDiv").window('close');
					}
			});
			 
		 });
		 
		 //白名单
		 $("#save_whitelist_mac").click(function(){
			 $.ajax({
			   		type: "POST",
			   	 	dataType:"json",   
				   url:"apmController!saveWhitelist", 
				   data:$('#whitelist_Form_mac').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
				   success: function(data){
						 alert(data[0].code);
						 $("#ap_TabDiv").window('close');
					}
			});
		 });
		 
		 //远程升级保存
		 $("#save_ycsj").click(function(){
			 $("#UpgradeForm input").each(function(i){
				  if(this.value==""){
					  return false;
				  }else{ 
					  $.ajax({
					   		type: "POST",
					   	 	dataType:"json",   
						   url:"apmController!saveUpgrade", 
						   data:$('#UpgradeForm').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
						   success: function(data){
						 alert(data[0].code);
						 $("#ap_TabDiv").window('close');
							}
					  });
					  return false;
				  }
			 });
		 });
		 
		 //远程控制保存
		 $("#save_yckz").click(function(){
			 $("#set_yckz_Form input").each(function(i){
				  if(this.checked==true){
					  $.ajax({
					   		type: "POST",
					   	 	dataType:"json",   
						   url:"apmController!saveUpgrade", 
						   data:$('#set_yckz_Form').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
						   success: function(data){
						 alert(data[0].code);
						 $("#ap_TabDiv").window('close');
							}
					});
				  }
			 });
			 
		 });
		 
		 //认证设置 
		 $("#save_rzsz").click(function(){
			 $("#set_rzsz_Form input").each(function(i){
				  if(this.checked==true){
					  $.ajax({
					   		type: "POST",
					   	 	dataType:"json",   
						   url:"apmController!saveUpgrade", 
						   data:$('#set_rzsz_Form').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
						   success: function(data){
						 alert(data[0].code);
						 $("#ap_TabDiv").window('close');
							}
					});
				  }
			 });
			 
		 });
		 
		 $("#save_authinterval").click(function(){
			 $("#set_authintervalForm input").each(function(i){
				  if(this.value==""){
					  return false;
				  }else{
					  $.ajax({
		  			   		type: "POST",
		  			   	 	dataType:"json",   
		  			   	 	cache:false,
		  				   url:"apmController!saveAuthInterval", 
		  				   data:$('#set_authintervalForm').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
		  				   success: function(data){
		  				 alert(data[0].code);
		  				 		$("#ap_TabDiv").window('close');
		  					}
		  			});
				  }
				  return false;
			 });
  			
  		});
		 
		 //portal设置保存
		 $("#save_portal").click(function(){
			 $.ajax({
			   		type: "POST",
			   	 	dataType:"json",   
				   url:"apmController!savePortal", 
				   data:$('#set_portalForm').serialize()+"&$id="+id+"&$mac="+mac+"&timestamp=" + new Date().getTime(),
				   success: function(data){
				 alert(data[0].code);
				 $("#ap_TabDiv").window('close');
					}
			});
			 
		 });
		 
		 
};
