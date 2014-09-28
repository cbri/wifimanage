package com.sinosoft.app.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.app.bean.Router;
import com.sinosoft.app.bean.Plugins;
import com.sinosoft.app.dao.AppDao;
import com.sinosoft.app.service.AppService;
@Component
@Transactional
@Service(value="appService")
public class AppServiceImpl implements AppService{
	@Autowired
	private AppDao appDao;
	
	public List<Router> getRouter(Map<String, Object> args) {
		return appDao.getRouter(args);
	}
	
	public List<Plugins> getPlugin(Map<String, Object> args) {
		return appDao.getPlugin(args);
	}
	
	public List<Plugins> getPluginByRouter(Map<String, Object> args) {
		return appDao.getPluginByRouter(args);
	}
}
