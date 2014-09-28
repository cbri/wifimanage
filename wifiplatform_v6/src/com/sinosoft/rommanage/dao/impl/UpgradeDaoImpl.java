package com.sinosoft.rommanage.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;

/**
 * 调度调用的DAO
 * @author 于永波
 */
public class UpgradeDaoImpl  extends SqlMapClientDaoSupport{
	@Resource(name="sqlMapClient")
	private SqlMapClient sqlMapClient;

	public List<UpgradePlan> queryUpGradePlan(Map<String, Object> args) {
		try {
			return getSqlMapClient().queryForList("upGradePlan.queryUpGradePlan", args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<UpgradePlan> queryParentUpGradePlan(Map<String, Object> args) {
		try {
			return getSqlMapClient().queryForList("upGradePlan.queryPUserUpGradePlan", args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<UpgradePlanApRel> queryUpGradePlanApRel(Map<String, Object> args) {
		try {
			return getSqlMapClient().queryForList("upGradePlan.queryUpGradePlanApRel", args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void updateEditUpGradePlan(Map<String, Object> args) {
		try {
			getSqlMapClient().update("upGradePlan.saveEditUpGradePlan",args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public Integer deleteUpGradePlanApRel(Map<String, Object> args) {
		try {
			return getSqlMapClient().delete("upGradePlan.deleteUpGradePlanApRel", args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public Integer deleteUpGradePlan(Map<String, Object> args) {
		try {
			return getSqlMapClient().delete("upGradePlan.deleteUpGradePlan", args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void updateEditUpGradePlanApRel(Map<String, Object> args) {
		try {
			getSqlMapClient().update("upGradePlan.updateEditUpGradePlanApRel",args);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	public void saveUpgradePlanLog(Map<String, Object> map){
		try {
			getSqlMapClientTemplate().insert("upgradeLog.saveUpgradePlanLog", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
