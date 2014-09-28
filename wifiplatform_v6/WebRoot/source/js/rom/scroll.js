$(document).ready(function() {
	//记录滚动的最大高度
	$("#up_div").scroll(function() {
		var stop = $("#up_div").scrollTop();
		var search_text = $("#search_text").val();
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
		//(stop + height) / (sheight - (stop + height)) >= 5
		if (sheight == (stop + height)) {
			$("#up_div").scrollTop(stop);
			//打开加载动画
			openLoadDataGif();
			//页码加1
			pageNum++;
			//加载数据
			$.post("upgrade!searchUpgradePlan.do","pageNum="+pageNum+"" +
					"&start_time="+start_time+
					"&end_time="+end_time+
					"&search_text="+search_text,function (res){
				var json = eval(res);
				if(json.length == 0){
					closeLoadDataGif();
					return;
				}
				for ( var i = 0; i < json.length; i++) {
					var addrs = "";
					var macs = "";
					for ( var j = 0; j < json[i].planApRels.length; j++) {
						if(macs == ""){
							macs = json[i].planApRels[j].mac;
						}else{
							macs = macs+":"+json[i].planApRels[j].mac;
						}
						if(addrs == ""){
							addrs = json[i].planApRels[j].pname+json[i].planApRels[j].cname+json[i].planApRels[j].dname;
						}else{
							addrs = addrs+":"+json[i].planApRels[j].pname+json[i].planApRels[j].cname+json[i].planApRels[j].dname;
						}
					}
					var hml = "<input type='checkbox' />";
					var spa = "<a href='#'>审核</a>(未审核)";
					if(json[i].isSelfCreate == '1'&&json[i].check_state != '1'){
						spa = "<a href='#' onclick='verify("+json[i].id+",event,1)'>审核</a>(未审核)";
					}else if(json[i].isSelfCreate != '1'&&json[i].check_state != '1'){
						hml = "<input type='checkbox'  disabled='disabled'/>";
						spa = "<span style='color: gray;'>未审核</span>";
					}else if(json[i].isSelfCreate == '1'&&json[i].check_state == '1'){
						//已执行的计划无法取消审核
						if(json[i].isexecute=='1'){
							spa = "<span style='color: gray;'>已审核</span>";
						}else{
							var d = json[i].id;
							spa = "<span style='color: gray;'>已审核</span>(<a href='#' onclick='verify("+d+",event,0)'>取消审核</a>)";
						}
					}else if(json[i].isSelfCreate != '1'&& json[i].check_state == '1'){
						hml = "<input type='checkbox'  disabled='disabled'/>";
						spa = "<span style='color: gray;'>已审核</span>";
					}
					//已执行的计划不能删除
					if(json[i].isexecute == '1'){
						hml = "<input type='checkbox'  disabled='disabled'/>";
					}
					var plname = json[i].plan_name == null ? "" :(json[i].plan_name.length > 10 ?
							(json[i].plan_name.substring(0,10)+"..."):json[i].plan_name);
					$("#upgrade_table").append("<tr ondblclick='editUpGradePlans("+json[i].id+","+json[i].isSelfCreate+",event)' id='editUpGradePlans_"+json[i].id+"'>" +
												"<td align='center'>"+hml+
												"<input type='hidden' value='"+json[i].id+"'/>" +
												"<input type='hidden' value='"+json[i].isSelfCreate+"'/>" +
												"<input type='hidden' value='"+json[i].check_state+"'/></td>" +
												"<td align='center'  title='"+json[i].plan_name+"'>"+json[i].plan_name+"</td>" +
												"<td align='center'><a href='javascript:lookApMessage("+json[i].id+");'>查看</a></td>" +
												"<td align='center'>"+json[i].create_time+"</td>" +
												"<td align='center'>"+json[i].real_time+"</td>" +
												"<td align='center'>"+spa+"</td>" +
												"<td align='center'>"+json[i].create_user+"</td>" +
												"</tr>");
				}
				//关闭加载动画
				closeLoadDataGif();
			},"json");
		}
	});
});