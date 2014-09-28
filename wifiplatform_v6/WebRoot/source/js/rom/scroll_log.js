$(document).ready(function() {
	//记录滚动的最大高度
	$("#up_div").scroll(function() {
		var stop = $("#up_div").scrollTop();
		var search_text = $("#searchbyname").val();
		var start_time = $("#start_time").val();
		var end_time = $("#end_time").val();
		var sheight = document.getElementById("up_div").scrollHeight;
		var height = $("#up_div").height();
		//当最大高度小于滚动的高度，重新赋值
		if(scrollTop < stop){
			scrollTop = stop;
		}else{
			//大于的时候，说明已经完成加载过，直接返回
			return;
		}
		if (sheight == (stop + height)) {
			$("#up_div").scrollTop(stop);
			//打开加载动画
			openLoadDataGif();
			//页码加1
			pageNum++;
			//加载数据
			$.post("upGrade!queryByName","planname=" + search_text+"&start_time="+start_time+"&end_time="+end_time+"&pageNum="+pageNum
					,function (res){
				var json = eval(res);
				if(json.length == 0){
					closeLoadDataGif();
					return;
				}
				for ( var i = 0; i < json.length; i++) {
					var htmlStr = "<tr>";
					htmlStr += "<td width='11%'><div align='center' title='"+json[i].planname+"'>"
							+ (json[i].planname == null ? "" :(json[i].planname.length > 10 ?
									(json[i].planname.substring(0,10)+"..."):json[i].planname))
							+ "</div></td>";
					htmlStr += "<td width='20%'><div align='center'>"
							+ json[i].realtime
							+ "</div></td>";
					htmlStr += "<td width='5%'><div align='center'><span id='span_01_"+json[i].planid+"'>"
							+ (json[i].success_time == null?"":json[i].success_time)
							+ "</span></div></td>";
					htmlStr += "<td width='5%'><div align='center'><span id='span_02_"+json[i].planid+"'>"
							+ json[i].fail_time
							+ "</span>" +
							"<a href='javascript:open_upgrade_log_window("+json[i].planid+");'>【查看详细】</a></div></td>";
					htmlStr += "</tr>";
					$("#data_table").append(htmlStr);
				}
				//关闭加载动画
				closeLoadDataGif();
			},"json");
		}
	});
});
