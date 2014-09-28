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
				},
				// 回调方法处理
				callback: {
					//onNodeCreated: this.onNodeCreated,
					//beforeClick: this.beforeClick,
					beforeClick:beforeClick,
					onClick: onClickLoad,
					//onCollapse: onCollapse,
					//onExpand: onExpand
					// 异步加载树节点
					onAsyncSuccess: onAsyncSuccess,
					onAsyncError: onAsyncError
				}
			};
			function ajaxDataFilter(treeId, parentNode, responseData) {
			    return responseData;
			};
			function onAsyncSuccess(event, treeId, treeNode, msg){//alert(treeNode);
			}
			function onAsyncError(event, treeId, treeNode, msg){//alert("fail");
			}
			/**节点关闭*/
			function onCollapse(event, treeId, treeNode) {
//				alert("onCollapse" + treeNode.name);
			}		
			/**节点展开*/
			function onExpand(event, treeId, treeNode) {
//				alert("onExpand" + treeNode.name);
			}
			/**点击加载*/
			function onClickLoad(event, treeId, treeNode){
				var code= treeNode.id;
				$.get("upgrade!getApMessage.do","id="+code,function(data){
					var json = $.parseJSON(data.toString());
					var tab = $("#ap_table_1");
					tab.empty();
					tab.append("<tr  style='background:#d4e2ef'>" +
							   "<td><input type='checkbox' id='check_input_all' onclick='checkAll("+json.length+")'/></td>" +
							   "<td>MAC</td>" +
							   "<td>区域</td>" +
				            	"</tr>");
					//检查右边是否有
					var checkedAll = true;
					for ( var i = 0; i < json.length; i++) {
						var pcode = json[i].district;
						if(pcode == ""){
							pcode = json[i].city;
							if(pcode == ""){
								pcode = json[i].province;
							}
						}
						if(document.getElementById(pcode+"_"+json[i].id)){
							tab.append("<tr id='upgrade_window_tb_1_"+i+"'>" +
									   "<td><div align='center'><input type='checkbox' checked='checked' id='check_input_"+i+"'  onclick='checkRow("+i+",event)'/>" +
									   "<input type='hidden' id='upgrade_window_hidden_1_"+i+"' value='"+json[i].id+"'/>" +
									   "<input type='hidden' id='province_code"+i+"' value='"+pcode+"'/></td>" +
									   "<td align='center'>"+json[i].mac+"</td>" +
									   "<td align='center'>"+json[i].cname+json[i].dname+"</td>" +
						            	"</tr>");
						}else{
							tab.append("<tr id='upgrade_window_tb_1_"+i+"'>" +
									   "<td><div align='center'><input type='checkbox' id='check_input_"+i+"'  onclick='checkRow("+i+",event)'/>" +
									   "<input type='hidden' id='upgrade_window_hidden_1_"+i+"' value='"+json[i].id+"'/>" +
									   "<input type='hidden' id='province_code"+i+"' value='"+pcode+"'/></td>" +
									   "<td align='center'>"+json[i].mac+"</td>" +
									   "<td align='center'>"+json[i].cname+json[i].dname+"</td>" +
						            	"</tr>");
							checkedAll = false;
						}
					}
					//所有的都被选了
					if(checkedAll && json.length != 0){
						document.getElementById("check_input_all").checked = true;
					}
				},"json");
			}
			
			function beforeClick(treeId, treeNode) {
			    return true;
			}
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
			
			function initTree() {
				// 初始化菜单树
				$.getJSON("PositionController!getTreeData", null, function(data){
					zNodes = $.parseJSON(data.toString());
					// 测试
					$.fn.zTree.init($("#menuTree"), setting, zNodes);
					
				});
			}
			$(function(){
				// 初始化应用树
				initTree();
				// 模型库和应用菜单切换效果 from ui desiger
			});