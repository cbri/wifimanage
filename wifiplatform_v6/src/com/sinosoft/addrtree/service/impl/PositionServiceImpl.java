package com.sinosoft.addrtree.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.dao.PositionDao;
import com.sinosoft.addrtree.service.PositionService;

@Component
@Transactional
@Service(value="positionService")
public class PositionServiceImpl implements PositionService{
	@Autowired
	public PositionDao positionDao;

	public List<Position> getPositionByUserid(String userid) {
		return positionDao.getPositionByUserid(userid);
	}

	public List<Position> getAddrTree(Map<String, String> map) {
		return positionDao.getAddrTree(map);
	}

	public List<Position> getProvince(Map<String, Object> map) {
		return positionDao.getProvince(map);
	}

}
