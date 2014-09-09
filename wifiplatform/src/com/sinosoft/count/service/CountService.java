package com.sinosoft.count.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CountService {

	/**
	 * 查询用户最高级区域 
	 * @param id
	 * @return
	 */
	List<String> findTopCodeByid(Long id);

	/**
	 * 查询全国各省统计
	 * @return
	 */
	List<HashMap> queryAllProvinceCount();

	/**
	 * 查询区域统计
	 * @param code
	 * @return
	 */
	HashMap queryCountByCode(String code);

	/**
	 * 查询子集
	 * @param code
	 * @return
	 */
	List queryCountSubset(String code);

	/**
	 * 管理员初始省份
	 * @return
	 */
	List initProvince();

	/**
	 * 查询全国AP在线
	 * @return
	 */
	List<HashMap> queryAllCount();

	/**
	 * 查询区域AP在线
	 * @param code
	 * @return
	 */
	HashMap queryCount(String code);

	List selectHighcharts(Map map);
	

}
