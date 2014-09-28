package com.sinosoft.count.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.count.bean.Count;
import com.sinosoft.count.dao.CountQuartzDao;

public class CountQuartzDaoImpl implements CountQuartzDao {

	@Autowired
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/**
	 * 查询所有省份
	 */
	public List queryProvince() {
		try {
			return sqlMapClient.queryForList("queryProvince");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 查询所有AP
	 */
	public List queryAllAP() {
		try {
			return sqlMapClient.queryForList("queryAllAP");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}


	/**
	 * 查询apid
	 * @param districtid
	 * @return
	 */
	public List queryApId(Map map) {
		try {
			return sqlMapClient.queryForList("queryApid",map);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询ap
	 * @param districtid
	 * @return
	 */
	public HashMap queryAp(String apid) {
		try {
			return (HashMap) sqlMapClient.queryForObject("queryApInformation",apid);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询ap在线数
	 * @param districtid
	 * @return
	 */
	public Integer queryApOnline(Map map) {
		try {
			return (Integer) sqlMapClient.queryForObject("queryApOnline",map);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询连接信息
	 * @param mac
	 * @return
	 */
	public HashMap queryConnections(String mac) {
		try {
			return (HashMap) sqlMapClient.queryForObject("queryConnections",mac);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询统计原始记录
	 * @param districtid
	 * @return
	 */
	public Count queryLastCount(String districtid) {
		try {
			return (Count) sqlMapClient.queryForObject("queryLastCount",districtid);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 更新统计数据
	 * @param count
	 */
	public void updateCount(Count count) {
		try {
			sqlMapClient.update("updateCount", count);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 插入统计数据
	 * @param count
	 */
	public void insertCount(Count count) {
		try {
			sqlMapClient.insert("insertCount", count);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 插入增加表
	 * @param count
	 */
	public void insertGrowthSpeedDay(Count count) {
		try {
			sqlMapClient.insert("insertGrowthDay", count);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询省所有AP
	 * @return
	 */
	public List<HashMap> queryProvinceAp() {
		try {
			return sqlMapClient.queryForList("queryProvinceAp");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询ap在线客户数
	 * @return
	 */
	public Integer queryApCustomerOnline(String mac) {
		try {
			return (Integer) sqlMapClient.queryForObject("queryApCustomerOnline",mac);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询ap地址
	 * @param string
	 * @return
	 */
	public HashMap queryApAddress(Integer id) {
		try {
			return (HashMap) sqlMapClient.queryForObject("queryApAddress",id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询ap商户
	 * @param string
	 * @return
	 */
	public HashMap queryApMerchant(Integer id) {
		try {
			return (HashMap) sqlMapClient.queryForObject("queryApMerchant",id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 删除前天信息
	 * @param now
	 */
	public void deleteApCustomerCount() {
		try {
			sqlMapClient.delete("deleteApCustomerCount");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 插入ap在线客户统计
	 * @param apCustomerCount
	 */
	public void insertApCustomerCount(HashMap apCustomerCount) {
		try {
			sqlMapClient.insert("insertApCustomerCount", apCustomerCount);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
