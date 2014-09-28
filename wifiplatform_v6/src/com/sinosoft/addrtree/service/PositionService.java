package com.sinosoft.addrtree.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sinosoft.addrtree.bean.City;
import com.sinosoft.addrtree.bean.District;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.bean.Province;


/**
 * 位置信息的业务接口
 * @author 于永波
 * @since  2014-5-27
 */
public interface PositionService {
	public List<Position> getPositionByUserid(String userid);
	/**获取区域树*/
	public List<Position> getAddrTree(Map<String,String> map);
	/**获取省份内容*/
	public List<Position> getProvince(Map<String,Object> map);
}
