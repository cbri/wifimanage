package com.sinosoft.app.dao.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.app.bean.Router;
import com.sinosoft.app.bean.Plugins;
import com.sinosoft.app.dao.AppDao;
import com.sinosoft.base.dao.impl.BaseDaoImpl;
@Repository(value="appDao")
public class AppDaoImpl extends BaseDaoImpl implements AppDao{

	public List<Router> getRouter(Map<String, Object> args){
		return getSqlMapClientTemplate().queryForList("getRouter",args);
	}
	public List<Plugins> getPlugin(Map<String, Object> args){
		return getSqlMapClientTemplate().queryForList("getPlugin",args);
	}
	
	public List<Plugins> getPluginByRouter(Map<String, Object> args){
		return getSqlMapClientTemplate().queryForList("getPluginByRouter",args);
	}

}
