package com.sinosoft.count.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.sinosoft.count.bean.Count;

public interface CountQuartzDao {
	
	/**
	 * 查询所有省份
	 */
	List queryProvince();



	/**
	 * 查询apid
	 * @param districtid
	 * @return
	 */
	List queryApId(String districtid);

	/**
	 * 查询ap
	 * @param districtid
	 * @return
	 */
	HashMap queryAp(String apid);

	/**
	 * 查询ap在线数
	 * @param districtid 
	 * @param districtid
	 * @return
	 */
	Integer queryApOnline(String districtid);


	/**
	 * 查询连接信息
	 * @param mac
	 * @return
	 */
	HashMap queryConnections(String mac);

	/**
	 * 查询统计原始记录
	 * @param districtid
	 * @return
	 */
	Count queryLastCount(String districtid);

	/**
	 * 更新统计数据
	 * @param count
	 */
	void updateCount(Count count);

	/**
	 * 插入统计数据
	 * @param count
	 */
	void insertCount(Count count);

	/**
	 * 插入增加表
	 * @param count
	 */
	void insertGrowthSpeedDay(Count count);

	/**
	 * 查询省所有AP
	 * @return
	 */
	List<HashMap> queryProvinceAp();

	/**
	 * 查询ap在线客户数
	 * @param id 
	 * @return
	 */
	Integer queryApCustomerOnline(String mac);

	/**
	 * 查询ap地址
	 * @param string
	 * @return
	 */
	HashMap queryApAddress(Integer id);

	/**
	 * 查询ap商户
	 * @param string
	 * @return
	 */
	HashMap queryApMerchant(Integer id);

	/**
	 * 删除前天信息
	 * @param now
	 */
	void deleteApCustomerCount();

	/**
	 * 插入ap在线客户统计
	 * @param apCustomerCount
	 */
	void insertApCustomerCount(HashMap apCustomerCount);


	
}
