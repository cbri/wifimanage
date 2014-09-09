package com.sinosoft.rommanage.dao.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.base.dao.impl.BaseDaoImpl;
import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.dao.UpgradePlanDao;

/**
 * 升级计划Dao实现类
 * @author 于永波
 * @since  2014-6-12
 */
@Repository(value="upgradePlanDao")
public class UpgradePlanDaoImpl extends BaseDaoImpl implements UpgradePlanDao{

	public Integer insertUpGradePlan(Map<String, Object> args) {
		return (Integer) getSqlMapClientTemplate().insert("upGradePlan.insertUpGradePlan", args);
	}

	public Integer insertUpGradePlanApRel(Map<String, Object> args) {
		return (Integer) getSqlMapClientTemplate().insert("upGradePlan.insertUpGradePlanApRel", args);
	}

	public List<UpgradePlanApRel> queryUpGradePlanApRel(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("upGradePlan.queryUpGradePlanApRel", args);
	}

	public void updateEditUpGradePlan(Map<String, Object> args) {
		getSqlMapClientTemplate().update("upGradePlan.saveEditUpGradePlan",args);
	}

	public Integer deleteUpGradePlanApRel(Map<String, Object> args) {
		return getSqlMapClientTemplate().delete("upGradePlan.deleteUpGradePlanApRel", args);
	}

	public Integer deleteUpGradePlan(Map<String, Object> args) {
		return getSqlMapClientTemplate().delete("upGradePlan.deleteUpGradePlan", args);
	}

	public void updateEditUpGradePlanApRel(Map<String, Object> args) {
		getSqlMapClientTemplate().update("upGradePlan.updateEditUpGradePlanApRel",args);
	}

	public List<ApMessage> queryApMessage(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("upGradePlan.queryApMessage", args);
	}

	public List<UpgradePlan> queryUnAdminUpgrade(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("upgrade!!queryUnAdminUpgrade", args);
	}

	public List<UpgradePlan> queryAdminUpgrade(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("upgrade!!queryAdminUpgrade", args);
	}

	public List<Map<String, Object>> queryApContacts(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("upgrade!!queryApContacts", args);
	}

}
