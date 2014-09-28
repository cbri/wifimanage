package com.sinosoft.rommanage.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sinosoft.rommanage.bean.UpgradePlanApRel;

/**
 * 升级计划日志Service
 * @author 于永波
 * @since  2014-6-27
 */
public interface UpgradeLogService {

	/**
	 * 初始化查询日志
	 * @param args
	 * @return
	 */
	public List<?> queryAllLog(HashMap<String,Object> args);
	
	/**
	 * 根据名称查询日志
	 * @param map
	 * @return
	 */
	public List<?>  queryLogByName(Map<String,Object> map);
	/**
	 * 查询AP的日志信息
	 * @param map
	 * @return
	 * */
	public List<UpgradePlanApRel> queryUpgradeApLog(Map<String,Object> map);
	/**
	 * 更新升级计划与AP的关系表
	 * @param map
	 */
	public void updateUpradePlanApRel(Map<String, Object> map);
	/**
	 * 更新升级计划日志
	 * @param map
	 */
	public void updateUpgradePlanLog(Map<String, Object> map);
}
