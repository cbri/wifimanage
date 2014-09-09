package com.sinosoft.addrtree.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.addrtree.bean.Position;

/**
 * 查询区域树关系表，用于缓存
 * @author 于永波
 */
public class AddrTreeDaoImpl {
	private SqlMapClient sqlMapClient;
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	/**
	 * 查询所有区域
	 * @return
	 */
	public List<Position> getAddrTree() {
		try {
			return (List<Position>)getSqlMapClient().queryForList("getAddrTree",new HashMap<String, Object>());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
}
