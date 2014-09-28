package com.sinosoft.rommanage.service;

import java.util.List;
import java.util.Map;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
/**
 * 升级计划Service
 * @author 于永波
 * @since  2014-6-12
 */
public interface UpgradePlanService {

	/**
	 * 插入升级计划
	 * @param args 
	 * 			参数
	 * @return
	 * 			主键ID
	 */
	public Integer insertUpGradePlan(Map<String, Object> args);
	/**
	 * 插入升级计划与AP关系表
	 * @param args 
	 * 			参数
	 * @return
	 * 			主键ID
	 */
	public Integer insertUpGradePlanApRel(Map<String, Object> args);
	/**
	 * 删除升级计划与AP关系表
	 * @param args 
	 * 			参数
	 * @return
	 * 			主键ID
	 */
	public Integer deleteUpGradePlanApRel(Map<String, Object> args);
	/**
	 * 删除升级计划表数据
	 * @param args 
	 * 			参数
	 * @return
	 * 			主键ID
	 */
	public Integer deleteUpGradePlan(Map<String, Object> args);
	/**
	 * 保存编辑的内容
	 * @param args 
	 * 			参数
	 * @return
	 * 			主键ID
	 */
	public void updateEditUpGradePlan(Map<String, Object> args);
	/**
	 * 查询升级计划与AP的关系表
	 * @param args 
	 * 			参数
	 * @return
	 * 			查询到的升级计划
	 */
	public List<UpgradePlanApRel> queryUpGradePlanApRel(Map<String, Object> args);
	/**
	 * 根据Ap信息
	 * @param args 
	 * 			参数
	 * @return
	 * 			查询到的Ap
	 */
	public List<ApMessage> queryApMessage(Map<String, Object> args);
	
	/**
	 * 查询非超级管理员的计划的计划
	 * @param args 
	 * 			参数
	 * @return
	 * 			查询到的升级计划
	 */
	public List<UpgradePlan> queryUnAdminUpgrade(Map<String, Object> args);
	
	/**
	 * 查询超级管理员的计划的计划
	 * @param args 
	 * 			参数
	 * @return
	 * 			查询到的升级计划
	 */
	public List<UpgradePlan> queryAdminUpgrade(Map<String, Object> args);
	/**
	 * 查询AP商户信息的所有值
	 * @param args 
	 * 			参数
	 * @return
	 */
	public List<Map<String, Object>> queryApContacts(Map<String, Object> args);
}
