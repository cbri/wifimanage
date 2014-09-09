package com.sinosoft.rommanage.task;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.dao.impl.UpgradeDaoImpl;
import com.sinosoft.util.CommonDaoImpl;
import com.sinosoft.util.RemoteCallUtil;
/**
 * 升级计划任务
 * @author 于永波
 * @since  2014-6-13
 */
public class UpgradePlanTask {
	private UpgradeDaoImpl upgradeDao;
	private CommonDaoImpl commonDaoImpl;
	private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private Logger logger = Logger.getLogger(UpgradePlanTask.class);
	/**已执行计划*/
	public static List<Integer> alreadyExecutePlan = new ArrayList<Integer>();
	/**路径
	 * @throws ParseException */
	public void task() throws Exception {
		System.err.println("调度执行..............................");
		Map<String, Object> arguments = new HashMap<String, Object>();
		arguments.put("execute_time_l", new Date());
		arguments.put("check_state", 1);
		//查询已有计划放到页中
		List<UpgradePlan> queryUpGradePlan = upgradeDao.queryUpGradePlan(arguments);
		for (UpgradePlan upgradePlan : queryUpGradePlan) {
			execute(upgradePlan, format.parse(upgradePlan.getExecute_time()));
		}
	}
	/**
	 * 执行计划
	 * @param list
	 * @param d 
	 */
	private void execute(final UpgradePlan plan, Date d) {
		long time = (d.getTime()-System.currentTimeMillis())/1000;
		if(((d.getTime()-new Date().getTime())/1000) <= 60){
			if(!alreadyExecutePlan.contains(plan.getId())){
				alreadyExecutePlan.add(plan.getId());
				if(alreadyExecutePlan.size()>1000){
					for (int i = 0; i < 800; i++) {
						alreadyExecutePlan.remove(i);
					}
				}
			}else{
				return;
			}
			TimerTask t = new TimerTask() {
				public void run() {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("id", plan.getId());
					List<UpgradePlanApRel> aprel = upgradeDao.queryUpGradePlanApRel(map);
					int successTime = 0;
					String reason = "";
					for (UpgradePlanApRel ap : aprel) {
						String mac = ap.getMac();
						map = new HashMap<String, Object>();
						map.put("cmd_flag", 5);
						map.put("mac", mac);
						String ip = commonDaoImpl.queryIpByMac(map);
						map.put("ip", ip);
						String result = RemoteCallUtil.remoteCall(map);
						//解析是否执行成功
						String code = result.substring(19, 22);
						map = new HashMap<String, Object>();
						map.put("id", ap.getId());
						map.put("mac", mac);
						map.put("apid", ap.getApid());
						map.put("isexecute", 1);
						map.put("execute_result",code);
						if("200".equals(code)){
							//成功
							map.put("issuccess", 1);
							upgradeDao.updateEditUpGradePlanApRel(map);
							logger.debug("计划执行成功!!!!!--------："+code);
							successTime++;
						}else{
							map.put("issuccess", 0);
							upgradeDao.updateEditUpGradePlanApRel(map);
							logger.debug("计划执行失败!!!!!--------："+code);
							reason+="[mac:"+mac+":"+code+"]\n"+reason;
						}
					}
					//保存日志
					map = new HashMap<String, Object>();
					map.put("planid", plan.getId());
					map.put("real_time", new Date());
					map.put("success_time", successTime);
					map.put("fail_time", aprel.size()-successTime);
					upgradeDao.saveUpgradePlanLog(map);
					map = new HashMap<String, Object>();
					map.put("id", plan.getId());
					map.put("isexecute", 1);
					map.put("real_time", plan.getExecute_time());
					upgradeDao.updateEditUpGradePlan(map);
				}
			};
			new Timer().schedule(t, time);
		}
	}
	public UpgradeDaoImpl getUpgradeDao() {
		return upgradeDao;
	}
	public void setUpgradeDao(UpgradeDaoImpl upgradeDao) {
		this.upgradeDao = upgradeDao;
	}
	public CommonDaoImpl getCommonDaoImpl() {
		return commonDaoImpl;
	}
	public void setCommonDaoImpl(CommonDaoImpl commonDaoImpl) {
		this.commonDaoImpl = commonDaoImpl;
	}
}
