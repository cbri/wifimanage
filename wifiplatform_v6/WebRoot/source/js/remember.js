window.onload = function()
{
	setUrlParams();
	setActive();       
}

     


/*循环链接，给所有的链接加入参数*/
function setUrlParams()
{
	var links = document.getElementById("nav").getElementsByTagName("a");

	for(var i = 0, j = links.length; i < j; i++)
	{
		links[i].href = links[i].href + "?type=" + i;
	}
}

/*设置激活样式*/
function setActive()
{
	var num = getQueryString("type");
	
	document.getElementById("nav").getElementsByTagName("a")[num].className = "active";//如果url参数不带有type，那么getQueryString()方法返回的就是0，默认将第一个链接(的父级元素li)设置为class="active"选中激活样式


}

/*获取url参数*/
function getQueryString(name) 
{
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); 
	var r = window.location.search.substr(1).match(reg); 
	if (r!=null){return unescape(r[2]);}
	else{return 0;}//如果获取不到，则返回0
}

