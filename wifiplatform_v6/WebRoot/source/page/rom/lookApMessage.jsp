<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="lookApMessage_window" class="easyui-window" title="AP信息" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:620px;height:400px;padding:10px;background-color: #F0FFF0;">
		<div data-options="region:'center',border:false" style="background-color: #F0FFF0;padding:10px;height:290px;overflow: auto;">
			<table id="lookApMessage_table" class="AP_table">
				
			</table>
		</div>
		<div data-options="region:'south',border:false" style="background-color: #F0FFF0;text-align:center;padding:5px 0 0;height: 25px;">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:$('#lookApMessage_window').window('close');" style="width:80px">关闭</a>
		</div>
</div>