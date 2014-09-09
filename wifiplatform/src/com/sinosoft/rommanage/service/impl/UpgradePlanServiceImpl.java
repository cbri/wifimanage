package com.sinosoft.rommanage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.dao.UpgradePlanDao;
import com.sinosoft.rommanage.service.UpgradePlanService;
/**
 * 升级计划Service实现类
 * @author 于永波
 * @since  2014-6-12
 */
@Component
@Transactional
@Service(value="upgradePlanService")
public class UpgradePlanServiceImpl implements UpgradePlanService{
	
	@Autowired
	private UpgradePlanDao planDao;
	
	public Integer insertUpGradePlan(Map<String, Object> args) {
		return planDao.insertUpGradePlan(args);
	}

	public Integer insertUpGradePlanApRel(Map<String, Object> args) {
		return planDao.insertUpGradePlanApRel(args);
	}

	public List<UpgradePlanApRel> queryUpGradePlanApRel(Map<String, Object> args) {
		return planDao.queryUpGradePlanApRel(args);
	}

	public void updateEditUpGradePlan(Map<String, Object> args) {
		planDao.updateEditUpGradePlan(args);
	}

	public Integer deleteUpGradePlanApRel(Map<String, Object> args) {
		return planDao.deleteUpGradePlanApRel(args);
	}

	public Integer deleteUpGradePlan(Map<String, Object> args) {
		return planDao.deleteUpGradePlan(args);
	}

	public List<ApMessage> queryApMessage(Map<String, Object> args) {
		return planDao.queryApMessage(args);
	}

	public List<UpgradePlan> queryUnAdminUpgrade(Map<String, Object> args) {
		return planDao.queryUnAdminUpgrade(args);
	}

	public List<UpgradePlan> queryAdminUpgrade(Map<String, Object> args) {
		return planDao.queryAdminUpgrade(args);
	}

	public List<Map<String, Object>> queryApContacts(Map<String, Object> args) {
		return planDao.queryApContacts(args);
	}

}
