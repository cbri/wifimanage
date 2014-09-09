package com.sinosoft.rommanage.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.base.dao.impl.BaseDaoImpl;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.dao.UpgradeLogDao;
@Repository("upgradeDao")
public class UpgradeLogDaoImpl extends BaseDaoImpl implements UpgradeLogDao {

	public List<?> queryAllLog(HashMap<String,Object> args) {
		return getSqlMapClientTemplate().queryForList("queryAllLog",args);
	}

	public List<?> queryLogByName(Map<String,Object> map) {
		return getSqlMapClientTemplate().queryForList("queryLogByName",map);
	}

	public List<UpgradePlanApRel> queryUpgradeApLog(Map<String, Object> map) {
		return getSqlMapClientTemplate().queryForList("upGradePlan.queryUpGradePlanApRel",map);
	}

	public void updateUpradePlanApRel(Map<String, Object> map) {
		getSqlMapClientTemplate().update("upGradePlan.updateEditUpGradePlanApRel", map);
	}

	public void updateUpgradePlanLog(Map<String, Object> map) {
		getSqlMapClientTemplate().update("upGradePlan.updateUpgradePlanLog", map);
	}
}
