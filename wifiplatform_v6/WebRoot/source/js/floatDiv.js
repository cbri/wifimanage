window.onload=function(){
	var floatDiv = document.getElementById("floatDiv");
	var wh = document.body.offsetHeight;;
	var ww = document.body.offsetWidth;
	var fh = floatDiv.style['height'];
	var fw = floatDiv.style.width;
	fh = fh.substr(0,fh.lastIndexOf('px'));
	fw = fw.substr(0,fw.lastIndexOf('px'));
	floatDiv.style.top = (wh-fh)/2+"px";
	floatDiv.style.left = (ww-fw)/2+"px";
	document.getElementById("close_tab").onclick=function(){
		floatDiv.style.visibility = "hidden";
	};
};