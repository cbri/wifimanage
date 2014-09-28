package com.sinosoft.addrtree.dao;

import java.util.List;
import java.util.Map;

import com.sinosoft.addrtree.bean.Position;
/**
 * 位置信息DAO
 * @author 于永波
 * @since  2014年5月26日16:56:18
 */
public interface PositionDao{
	
	public List<Position> getPositionByUserid(String userid);
	
	/**获取区域树*/
	public List<Position> getAddrTree(Map<String,String> map);
	/**获取省份内容*/
	public List<Position> getProvince(Map<String,Object> map);
	
}
