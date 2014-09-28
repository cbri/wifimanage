$(document).ready(function() {
	$("#up_div").scroll(function() {
		var scrollTop = parseInt($("#scroll_top").val());
		var stop = $("#up_div").scrollTop();
		var sheight = document.getElementById("up_div").scrollHeight;
		var height = $("#up_div").height();
		var num = parseInt($("#scroll_num").val());
		//当最大高度小于滚动的高度，重新赋值
		if(scrollTop < stop){
			$("#scroll_top").val(stop);
		}else{
			//大于的时候，说明已经完成加载过，直接返回
			return;
		}
		if ((stop + height) / (sheight - (stop + height)) >= 5) {
//			加载数据
			jinduopen();
			num++;
			$("#scroll_num").val(num);
			var data = "pagenum="+num+"&code="+pcode;
			var url = "onclien!querybylimit";
			if(query_content != ""){
				data +=("&"+query_content);
				url = "apmController!highranksearch";
			}
			$.post(url,data,function(res){
			var json = eval(res);
			if(json.length == 0){
				jinduclose();
				return;
			}
			
			var htmlStr = "";
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
		});
	}
	});
});
