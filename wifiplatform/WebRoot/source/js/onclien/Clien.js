//搜索			
function querybymac(pcode){
	if(pcode==null){
		alert("请先选择要搜索的地区");
	}else{
var mac = $("#searchbymac").val();
$.ajax({     
			type : "POST",
			dataType : "json",
			url : "onclien!querybycode",
			data : "mac="+ mac+"&code="+pcode,
			success : function(json) {
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
							if(n%Math.pow(1024,2)!=n){
								n = n / Math.pow(1024,2);
								var num = Math.round(n * 10) / 10;
								var outgoing = num+"GB"
							}
							else{
								if(n%1024!=n){
									n = n/1024;
									var num = Math.round(n * 10) / 10;
									var outgoing = num+"MB"
								}else{
									var outgoing = n+"KB"
								}
							}
							htmlStr += "<td width='10%'><div align='center'>"
									+ outgoing
									+ "</div></td>";	
									
							var n = json[i].incoming;
							if(n%Math.pow(1024,2)!=n){
								n = n / Math.pow(1024,2);
								var num = Math.round(n * 10) / 10;
								var incoming = num+"GB"
							}
							else{
								if(n%1024!=n){
									n = n/1024;
									var num = Math.round(n * 10) / 10;
									var incoming = num+"MB"
								}else{
									var incoming = n+"KB"
								}
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
};

