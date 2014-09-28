package com.sinosoft.account.dao;

import java.util.List;
import java.util.Map;

import com.sinosoft.account.bean.GrowthTotal;


/**
 * 主页显示统计的DAO
 * @author 于永波
 * @since  2014-6-17
 */
public interface GrowthTotalDao{
	/**
	 * AP总数
	 * @return
	 */
	public List<GrowthTotal> queryGrowthTotal(Map<String, Object> args);
}
