package com.sinosoft.onclien.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.base.dao.impl.BaseDaoImpl;
import com.sinosoft.onclien.bean.Connections;
import com.sinosoft.onclien.dao.OnclienDao;
/**
 * DAO层实现代码
 * @author 李洪因
 * @since  2014-6-13
 */
@Repository(value="onclienDao")
public class OnclienDaoImpl extends BaseDaoImpl implements OnclienDao {

	public List<Connections> getConnections(Map map) {
		return getSqlMapClientTemplate().queryForList("getConnections",map);
	}

	public List findbyCode(String code) {
		return getSqlMapClientTemplate().queryForList("findbyCode",code);
	}

	public List queryApCusCount(HashMap params) {
		return getSqlMapClientTemplate().queryForList("queryApCusCount",params);
	}

	public List<HashMap> queryApCusCountByMac(String mac) {
		return getSqlMapClientTemplate().queryForList("queryApCusCountByMac",mac);
	}

	public List<Connections> findcusByid(Map map) {
		
		return getSqlMapClientTemplate().queryForList("findcusByid",map);
	}

}
