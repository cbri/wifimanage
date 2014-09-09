package com.sinosoft.apmessage.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.apmessage.dao.ApMessageDao;
import com.sinosoft.base.dao.impl.BaseDaoImpl;


/**
 * apDAO实现类
 * @author dyf
 *
 */
@Repository("apMessageDao")
public class ApMessageDaoImpl extends BaseDaoImpl implements ApMessageDao{


	public List<ApMessage> searchApbyid(Map<String, Object> map) {
		
		return  getSqlMapClientTemplate().queryForList("searchApbyid",map);
	}

	public List<ApMessage> searchbyname(Map map) {
		
		return getSqlMapClientTemplate().queryForList("findMerchantByid",map);
	}

	public List<ApMessage> highranksearch(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("highranksearch",map);
	}

	public List findCtiyByCode(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("findCitybycode",map);
	}

	public List findDistrictByCode(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("findDistrictByCode",map);
	}


	public List init(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("init",map);
	}

	public List initProvince(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("initProvince",map);
	}

	public List findNameByCode(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("findNameByCode",map);
	}

	//根据商户ID查询商户名称
	public List queryById(String id) {
		return getSqlMapClientTemplate().queryForList("queryById",id);
	}

	public void insertProtocol_set_log(Map map) {
		 getSqlMapClientTemplate().insert("insertProtocol_set_log", map);
	}

	public void insertInternet_limit_log(Map<String, Object> map) {
		 getSqlMapClientTemplate().insert("insertInternet_limit_log", map);
		
	}

	public void insertUpgrade_ctrl_log(Map map) {
		 getSqlMapClientTemplate().insert("insertUpgrade_ctrl_log", map);
	}
	
	public void insertUpgrade_ctrl(Map<String, Object> map) {
		 getSqlMapClientTemplate().insert("insertUpgrade_ctrl", map);
	}

	public void insertPortal_set_log(Map<String, String> map) {
		 getSqlMapClientTemplate().insert("insertPortal_set_log", map);
	}
	
	public void insertPortal_set(Map<String, Object> map) {
		 getSqlMapClientTemplate().insert("insertPortal_set", map);
	}

	public List findCodeByid(Long id) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("findCodeByid",id);
	}

	public List<ApMessage> searchbyCode(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("searchbyCode",map);
	}

	public List queryAllApconfig(Map params) {
		return getSqlMapClientTemplate().queryForList("query"+params.get("tablename"),params);
	}
	
	public List setProtocolShow(Map<String, String> map) {
		return getSqlMapClientTemplate().queryForList("setProtocolShow",map);
	}

	public List<String> whitelistShow(Map<String, String> map) {
		return getSqlMapClientTemplate().queryForList("whitelistShow",map);
	}

	public List<String> portalShow(Map<String, String> map) {
		return getSqlMapClientTemplate().queryForList("portalShow",map);
	}

	public List<String> portal_TF(Map<String, String> map) {
		return getSqlMapClientTemplate().queryForList("portal_TF",map);
	}


	public void updateProtocol_set_log(Map<String, Object> map) {
		getSqlMapClientTemplate().update("updateProtocol_set_log", map);
	}

	public void updatePortal_set_log(Map<String, Object> map) {
		getSqlMapClientTemplate().update("updatePortal_set_log", map);
	}

	public void updateInternet_limit_log(Map<String, Object> map) {
		getSqlMapClientTemplate().update("updateInternet_limit_log", map);
	}

	public void updateUpgrade(Map<String, Object> map) {
		getSqlMapClientTemplate().update("updateUpgrade", map);
	}

	public List queryNameByCode(Map map) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("queryNameByCode",map);
	}
	public Map<String, Object> queryApFlow(Map<String, Object> args) {
		HashMap<String, Object> result = (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("queryFlowMessage",args);
		return result;
	}
	public String queryApAddress(Map<String, Object> map) {
		return (String) getSqlMapClientTemplate().queryForObject("ApMessageDaoImpl!queryApAddress",map);
	}

	public String queryApMerchant(Map<String, Object> map) {
		return (String) getSqlMapClientTemplate().queryForObject("ApMessageDaoImpl!queryApMerchant",map);
	}
	
}
