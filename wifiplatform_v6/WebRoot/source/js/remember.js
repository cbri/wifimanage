window.onload = function()
{
	setUrlParams();
	setActive();       
}

     


/*ѭ�����ӣ������е����Ӽ������*/
function setUrlParams()
{
	var links = document.getElementById("nav").getElementsByTagName("a");

	for(var i = 0, j = links.length; i < j; i++)
	{
		links[i].href = links[i].href + "?type=" + i;
	}
}

/*���ü�����ʽ*/
function setActive()
{
	var num = getQueryString("type");
	
	document.getElementById("nav").getElementsByTagName("a")[num].className = "active";//���url����������type����ôgetQueryString()�������صľ���0��Ĭ�Ͻ���һ������(�ĸ���Ԫ��li)����Ϊclass="active"ѡ�м�����ʽ


}

/*��ȡurl����*/
function getQueryString(name) 
{
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); 
	var r = window.location.search.substr(1).match(reg); 
	if (r!=null){return unescape(r[2]);}
	else{return 0;}//�����ȡ�������򷵻�0
}

