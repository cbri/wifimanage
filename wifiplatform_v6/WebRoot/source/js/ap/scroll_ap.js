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
			openLoadDataGif();
			num++;
			$("#scroll_num").val(num);
			var data = "pagenum="+num;
			var url = "apmController!querybylimit";
			if(query_content != ""){
				data +=("&"+query_content);
				url = "apmController!highranksearch";
			}
			$.post(url,data,function(res){
			var json = eval(res);
			if(json.length == 0){
				closeLoadDataGif();
				return;
			}
			
			var htmlStr = "";
			for ( var i = 0; i < json.length; i++) {
				if(json[i].onLine){
					htmlStr += "<tr style='background:#d5e8e2' ondblclick=attrLook("+json[i].id+");>"
				}else{
					htmlStr += "<tr style='background:#ded8df' ondblclick=attrLook("+json[i].id+");>"
				}
				htmlStr += "<td width='12%'><div align='center'>"
						+ json[i].name
						+ "</div></td>";
				htmlStr += "<td width='10%'><div align='center'>"
						+ json[i].ipaddr
						+ "</div></td>";
				htmlStr += "<td width='10%' ><div align='center'>"
						+ json[i].mac
						+ "</div></td>";
				htmlStr += "<td width='18%'><div align='center' >"
					+ "<a href='javascript:merchantlook("+json[i].id+");'>"
					+ ((json[i].merchant==null || json[i].merchant=='')?'':(json[i].merchant.length>10?json[i].merchant.substring(0,10)+"...":json[i].merchant))+ "</a>"
					+ "</div></td>";
				htmlStr += "<td width='18%'><div align='center'>"
						+ ((json[i].province=='北京市')?'':json[i].province)+""+json[i].city+""+json[i].district+""
						+ "</div></td>";
				htmlStr += "<td width='15%'><div align='left'   title='"+json[i].detail+"'>"
						+ ((json[i].detail==null)?'':(json[i].detail.length>10?json[i].detail.substring(0,10)+"...":json[i].detail))
						+ "</div></td>";
				htmlStr += "<td width='10%'><div align='center'>"
						+ ((json[i].ssid==null)?'':json[i].ssid)
						+ "</div></td>";
				if(json[i].onLine){
				htmlStr += "<td width='5%'><div align='center'>"
						+ " <a href=\"javascript:ap_setAll('"+json[i].id+"','"+json[i].mac+"','"+json[i].merchant_id+"');\">设置</a>"
						+ "</div></td>";
				}else{
					htmlStr += "<td width='5%'><div align='center'>"
						+ "--"
						+ "</div></td>";
					}
				htmlStr += "</tr>";
			}
			htmlStr += "</table>";
			$("#data_table").append(htmlStr);
			},"json");
			closeLoadDataGif();
		}
	});
});
