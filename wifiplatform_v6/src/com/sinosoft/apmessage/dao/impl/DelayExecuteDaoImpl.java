package com.sinosoft.apmessage.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.apmessage.dao.DelayExecuteDao;


public class DelayExecuteDaoImpl implements DelayExecuteDao {
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/**
	 * 查询待办任务
	 * @param time
	 * @return
	 */
	public List queryUnExcuteTask(String type) {
		try {
			return sqlMapClient.queryForList("queryUnExecuteTask",type);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 将执行次数+1
	 */
	public void updateDalayExecute(HashMap javabean) {
		try {
			sqlMapClient.update("updateDelayExecute",javabean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 删除延迟任务
	 */
	public void deleteDelayExecute(HashMap javabean) {
		try {
			sqlMapClient.delete("deleteDelayExecute", javabean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 保存日志
	 */
	public void saveLog(HashMap javabean) {
		try {
			String type=(String) javabean.get("type");
			if("portal_set".equals(type))
				sqlMapClient.insert("insertPortal_set_log",javabean);
			else
				sqlMapClient.insert("insertUpgrade_ctrl_log",javabean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 查询保存日志所需要的portal信息
	 * @param javabean
	 */
	public HashMap queryPortalSet(HashMap javabean) {
		try {
			return (HashMap)sqlMapClient.queryForObject("queryPortalInfo",javabean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 查询保存日志所需要的ap信息
	 * @param javabean
	 */
	public HashMap queryAp(HashMap javabean) {
		try {
			return (HashMap) sqlMapClient.queryForObject("queryAp",javabean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
}
