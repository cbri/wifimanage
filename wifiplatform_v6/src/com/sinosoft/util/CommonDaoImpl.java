package com.sinosoft.util;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.base.dao.impl.BaseDaoImpl;
@Repository(value="commonDao")
public class CommonDaoImpl extends BaseDaoImpl{
	@Resource(name="sqlMapClient")
	private SqlMapClient sqlMapClient;
	
	/**
	 * 根据MAC或者APID获取对应的IP
	 * @param args
	 * @return
	 */
	public String queryIpByMac(Map<String, Object> args){
		Object queryForObject = getSqlMapClientTemplate().queryForObject("commonDaoImpl!queryIpByMac", args);
		if(queryForObject == null){
			return "";
		}
		return queryForObject.toString();
	}
	
	/**
	 * 根据MAC集合获取对应的IP的MAP
	 * @param args
	 * @return Key是MAC,VALUE是IP
	 */
	public Map<Object,Object> queryIpByMacs(List<Object> args){
		List<Map<String,Object>> v = getSqlMapClientTemplate().queryForList("commonDaoImpl!queryIpByMacs", args);
		Map<Object, Object> result = new HashMap<Object, Object>();
		for (Map<String, Object> map : v) {
			if(map != null){
				result.put(map.get("node_mac"), map.get("ipaddr"));
			}
		}
		return result;
	}
}
