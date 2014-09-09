package com.sinosoft.count.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.base.dao.impl.BaseDaoImpl;
import com.sinosoft.count.service.CountService;

@Component
@Transactional
@Service(value="countService")
public class CountServiceImpl extends BaseDaoImpl implements CountService{

	/**
	 * 查询用户最高级区域 
	 * @param id
	 * @return
	 */
	public List<String> findTopCodeByid(Long id) {
		return getSqlMapClientTemplate().queryForList("findTopCodeByid", id);
	}

	/**
	 * 查询全国各省统计
	 * @return
	 */
	public List<HashMap> queryAllProvinceCount() {
		return getSqlMapClientTemplate().queryForList("queryAllProvinceCount");
	}

	/**
	 * 查询区域统计
	 * @param code
	 * @return
	 */
	public HashMap queryCountByCode(String code) {
		return (HashMap) getSqlMapClientTemplate().queryForObject("queryCountByCode",code);
	}

	/**
	 * 查询子集
	 * @param code
	 * @return
	 */
	public List queryCountSubset(String code) {
		return getSqlMapClientTemplate().queryForList("queryCountSubset",code);
	}

	/**
	 * 管理员初始省份
	 * @return
	 */
	public List initProvince() {
		return getSqlMapClientTemplate().queryForList("queryProvince");
	}

	/**
	 * 查询全国AP在线
	 * @return
	 */
	public List<HashMap> queryAllCount() {
		return getSqlMapClientTemplate().queryForList("queryAllCount");
	}

	/**
	 * 查询区域AP在线
	 * @param code
	 * @return
	 */
	public HashMap queryCount(String code) {
		return (HashMap) getSqlMapClientTemplate().queryForObject("queryCount",code);
	}

	public List selectHighcharts(Map map) {
		return (List) getSqlMapClientTemplate().queryForList((String) map.get("table"),map);
	}


}
