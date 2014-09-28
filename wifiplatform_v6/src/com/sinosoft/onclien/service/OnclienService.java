package com.sinosoft.onclien.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sinosoft.onclien.bean.Connections;

public interface OnclienService {
	/**
	 * 查询在线客户
	 * @param map
	 * @return
	 */
	public List<Connections> getConnections(Map map);
	
	/**
	 * 查询APID
	 * @param account
	 * @return
	 */	
	public List findbyCode(String code);

	/**
	 * 查询ap客户统计
	 * @param params
	 * @return
	 */
	public List queryApCusCount(HashMap params);

	/**
	 * 查询AP的一天在线客户
	 * @param mac
	 * @return
	 */
	public List<HashMap> queryApCusCountByMac(String mac);
	
	public List<Connections> findcusByid(Map map);
}
