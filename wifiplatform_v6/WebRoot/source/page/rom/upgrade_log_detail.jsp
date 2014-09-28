<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="upgrade_log_window" class="easyui-window" title="AP执行信息" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:680px;height:400px;padding:10px;background-color: #F0FFF0;">
		<div data-options="region:'center',border:false" style="background-color: #F0FFF0;padding:10px;height:290px;overflow: auto;">
			<table id="upgrade_ap_log_table" class="AP_table">
				<tr style="background:#d4e1ee;">
					<td width="10%"><div align="center"><input type="checkbox"/></div></td>
	                <td width="10%"><div align="center">AP名称</div></td>
	                <td width="20%"><div align="center">MAC</div></td>
	                <td width="20%"><div align="center">商家</div></td>
	                <td width="20%"><div align="center">区域</div></td>
	                <td width="10%"><div align="center">执行结果</div></td>
	                <td width="10%"><div align="center">执行状态</div></td>
	            </tr>
			</table>
		</div>
		<div data-options="region:'south',border:false" style="background-color: #F0FFF0;text-align:center;padding:5px 0 0;height: 25px;">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:rexecutePlan();" style="width:80px">重新执行</a>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:$('#upgrade_log_window').window('close');" style="width:80px">取消</a>
		</div>
		<input type="hidden" value="" id="plan_id"/>
</div>