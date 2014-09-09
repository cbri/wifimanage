package com.sinosoft.apmessage.dao;

import java.util.HashMap;
import java.util.List;

public interface DelayExecuteDao {

	/**
	 * 查询待办任务
	 * @param type 
	 * @param time
	 * @return
	 */
	List queryUnExcuteTask(String type);

	/**
	 * 将执行次数+1
	 * @param javabean
	 */
	void updateDalayExecute(HashMap javabean);

	/**
	 * 删除延迟任务
	 * @param javabean
	 */
	void deleteDelayExecute(HashMap javabean);

	/**
	 * 保存日志
	 * @param javabean
	 */
	void saveLog(HashMap javabean);

	/**
	 * 查询保存日志所需要的portal信息
	 * @param javabean
	 */
	HashMap queryPortalSet(HashMap javabean);

	/**
	 * 查询保存日志所需要的ap信息
	 * @param javabean
	 */
	HashMap queryAp(HashMap javabean);

}
