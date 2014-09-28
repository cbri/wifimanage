package com.sinosoft.app.service;

import java.util.List;
import java.util.Map;

import com.sinosoft.app.bean.Router;
import com.sinosoft.app.bean.Plugins;

public interface AppService {
	public List<Router> getRouter(Map<String, Object> args);
	public List<Plugins> getPlugin(Map<String, Object> args);
	public List<Plugins> getPluginByRouter(Map<String, Object> args);
}
