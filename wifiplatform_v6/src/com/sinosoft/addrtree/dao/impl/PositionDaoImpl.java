package com.sinosoft.addrtree.dao.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.dao.PositionDao;
import com.sinosoft.base.dao.impl.BaseDaoImpl;
/**
 * 位置信息DAO层实现类
 * @author 于永波
 * @since  2014-5-27
 */
@Repository("position")
public class PositionDaoImpl  extends BaseDaoImpl  implements PositionDao{

	public List<Position> getPositionByUserid(String userid) {
		return (List<Position>)getSqlMapClientTemplate().queryForList("getPositionByUserid",userid);
	}
	public List<Position> getAddrTree(Map<String, String> map) {
		return (List<Position>)getSqlMapClientTemplate().queryForList("getAddrTree",map);
	}
	public List<Position> getProvince(Map<String, Object> map) {
		return (List<Position>)getSqlMapClientTemplate().queryForList("getProvince",map);
	}
}
