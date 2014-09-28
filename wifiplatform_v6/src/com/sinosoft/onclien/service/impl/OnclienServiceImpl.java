package com.sinosoft.onclien.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.onclien.bean.Connections;
import com.sinosoft.onclien.dao.OnclienDao;
import com.sinosoft.onclien.service.OnclienService;
/**
 * 业务层实现
 * @author 李洪因
 * @since   2014-6-13
 */
@Component
@Transactional
@Service(value="onclienService")
public class OnclienServiceImpl implements OnclienService {
	@Autowired
	private OnclienDao onclienDao;

	public List<Connections> getConnections(Map map) {
		return onclienDao.getConnections(map);
	}

	public List findbyCode(String code) {
		return onclienDao.findbyCode(code);
	}

	public List queryApCusCount(HashMap params) {
		return onclienDao.queryApCusCount(params);
	}

	public List<HashMap> queryApCusCountByMac(String mac) {
		return onclienDao.queryApCusCountByMac(mac);
	}

	public List<Connections> findcusByid(Map map) {
		return onclienDao.findcusByid(map);
	}


}
