function merchantlook(id){
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "onclien!querybyid",
		data : "id="+id,
		success : function(json) {
	    var htmlStr = "";
      	for ( var i = 0; i < json.length; i++) {
			htmlStr +="<li><label>商户名称</label><input name='' type='text' value='"+((json[i].merchant=='')?'暂无':json[i].merchant)+"' Readonly/></li>";
			htmlStr +="<li><label>联系人</label><input name='' type='text' value="+((json[i].mname=='')?'暂无':json[i].mname)+" Readonly/></li>";
			htmlStr +="<li><label>手机</label><input name='' type='text' value="+((json[i].phone=='')?'暂无':json[i].phone)+" Readonly/></li>";
			htmlStr +="<li><label>电话</label><input name='' type='text' value="+((json[i].telephonenum=='')?'暂无':json[i].telephonenum)+" Readonly/></li>";
			htmlStr +="<li><label>邮箱</label><input name='' type='text' value="+((json[i].email=='')?'暂无':json[i].email)+" Readonly/></li>";
			htmlStr +="<li><label>微信</label><input name='' type='text' value="+((json[i].weixin=='')?'暂无':json[i].weixin)+" Readonly/></li>";
	  }
		$("#merchantlook").html(htmlStr);
		$("#ap_merchantlook").window('open');
	},
	error : function() {
		if (!confirm('该商户没有详细信息'))
			return;
	}
});
}