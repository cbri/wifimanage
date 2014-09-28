package com.sinosoft.account.dao.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.account.bean.GrowthTotal;
import com.sinosoft.account.dao.GrowthTotalDao;
import com.sinosoft.base.dao.impl.BaseDaoImpl;
@Repository
public class GrowthTotalDaoImpl  extends BaseDaoImpl implements GrowthTotalDao{

	public List<GrowthTotal> queryGrowthTotal(Map<String, Object> args) {
		return getSqlMapClientTemplate().queryForList("growth_total!queryGrowthTotal",args);
	}
	
}
