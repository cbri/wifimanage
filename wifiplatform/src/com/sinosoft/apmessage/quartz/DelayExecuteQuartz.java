package com.sinosoft.apmessage.quartz;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

import com.sinosoft.apmessage.dao.DelayExecuteDao;
import com.sinosoft.util.CommonDaoImpl;
import com.sinosoft.util.RemoteCallUtil;

@Service
public class DelayExecuteQuartz {

	private DelayExecuteDao delayExcutedao;
	private CommonDaoImpl commonDao;

	public CommonDaoImpl getCommonDao() {
		return commonDao;
	}

	public void setCommonDao(CommonDaoImpl commonDao) {
		this.commonDao = commonDao;
	}

	/**
	 * 定时调度
	 */
	public void executeInternal() {
		// 1.查询当前时间待执行的任务
		System.out.println("测试远程调用只有指令");
		// 查询在当前时间之前的执行次数小于3的任务
		List portalSetTask = delayExcutedao.queryUnExcuteTask("portal_set");
		List upgradeControlTask = delayExcutedao
				.queryUnExcuteTask("upgrade_ctrl");
		// 根据任务调用接口
		remoteCall(portalSetTask, "portal_set");
		remoteCall(upgradeControlTask, "upgrade_ctrl");
	}

	public DelayExecuteDao getDelayExcutedao() {
		return delayExcutedao;
	}

	public void setDelayExcutedao(DelayExecuteDao delayExcutedao) {
		this.delayExcutedao = delayExcutedao;
	}

	/**
	 * 日志方法
	 */
	public void saveLog(HashMap javabean) {
		System.out.println("日志结果---------------->" + javabean.get("tips"));
		// 日志所需要的参数由javabean传递
		// 执行次数为1
		javabean.put("runtime", 1);
		//日志保存
		delayExcutedao.saveLog(javabean);
	}

	/**
	 * 调用接口
	 */
	public void remoteCall(List task, String type) {
		// 判断任务是否为空不为空则调用接口并记录日志
		if (task != null && task.size() > 0) {
			for (int i = 0; i < task.size(); i++) {
				// 得到每一个待执行的任务
				HashMap javabean = (HashMap) task.get(i);
//				javabean.put("type", "whitelist");
				// 将mac信息存入javabean
				HashMap ap=delayExcutedao.queryAp(javabean);
				javabean.put("mac", ap.get("mac"));
				javabean.put("type", type);
				//查询该次需要访问的ip
				String ip=commonDao.queryIpByMac(javabean);
				javabean.put("ip", ip);
				//javabean中含有的参数不足根据ip查询
				if("portal_set".equals(type)){
					HashMap portal=(HashMap) delayExcutedao.queryPortalSet(javabean);
					javabean.put("portalname", portal.get("portalname"));
					javabean.put("redirect_url", portal.get("redirect_url"));
					javabean.put("portal_url", portal.get("portal_url"));
				}else{
					javabean.put("cmd_flag", "5");
				}
				// 远程调用接口接收回归代码
				String callback=RemoteCallUtil.remoteCall(javabean);
				//portal调用带参数方法远程升级调用指令方法
				String code = callback.substring(19, 22);
				javabean.put("set_result", code + ":"
						+ callback.substring(35, callback.length() - 30));
				// 如果回馈信息为空,则将执行次数+1,不为空不论失败成功都保存日志
				if (callback == null) {
					int runtime = (Integer) javabean.get("runtime") + 1;
					javabean.put("runtime", runtime);
					delayExcutedao.updateDalayExecute(javabean);
				} else {
					// 将回馈信息保存日志
					saveLog(javabean);
					// 无论成功失败都将该次任务删除
					delayExcutedao.deleteDelayExecute(javabean);
				}
			}
		}
	}

	
}