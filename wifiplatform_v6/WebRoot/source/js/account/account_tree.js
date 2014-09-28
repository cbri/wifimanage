//---------------- 应用树 -----------------------/
var zNodes ;
var currMune = null, zTreeMune = null;
// 初始化参数
var setting = {
	// 异步获取数据
	async: {
		enable: true,
		url: "PositionController!getTreeDataById",
		autoParam: ["id","pid"],
		dataType:"json",
		type: "get",
		dataFilter:ajaxDataFilter
	},
	// 显示设置
	view : {
		showLine: true,
		selectedMulti: false,
		dblClickExpand: false,
		fontCss: setFont
	},
	// 数据设置
	data : {
		simpleData : {
			enable: true,
			idKey : "id",
			pIdKey : "pId",
			rootPId : "0"
		}
	}
};
// 设置字体
function setFont(treeId, node){
	var font = {};
	if(node.levels == 0) {
		 return font = {
			'font-family': '微软雅黑',
			'font-size': '16px',
			'color': '#303030',
			'height':'16px',
			'line-height':'26px'
		};
	} else if(node.levels == 1) {
		 return font = {
			'font-family': '微软雅黑',
			'font-size': '16px',
			'color': '#303030',
			'height':'16px',
			'line-height':'26px'
		};
	} else if(node.levels == 2){
		 return font = {
			'font-family': '微软雅黑',
			'font-size': '15px',
			'color': '#303030',
			'height':'16px',
			'line-height':'22px'
		};
	}
}
function ajaxDataFilter(treeId, parentNode, responseData) {
    return responseData;
};