package com.sinosoft.rommanage.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.dao.UpgradeLogDao;
import com.sinosoft.rommanage.service.UpgradeLogService;
@Component
@Transactional
@Service(value="upgradeLogService")
public class UpgradeLogServiceImpl implements UpgradeLogService {
	
	@Autowired
	private UpgradeLogDao upgradeLogDao;
	
	public List<?> queryAllLog(HashMap<String,Object> args) {
		return upgradeLogDao.queryAllLog(args);
	}
	public List<?> queryLogByName(Map<String,Object> map) {
		return upgradeLogDao.queryLogByName(map);
	}
	public List<UpgradePlanApRel> queryUpgradeApLog(Map<String,Object> map){
		return upgradeLogDao.queryUpgradeApLog(map);
	}
	public void updateUpradePlanApRel(Map<String, Object> map) {
		upgradeLogDao.updateUpradePlanApRel(map);		
	}
	public void updateUpgradePlanLog(Map<String, Object> map) {
		upgradeLogDao.updateUpgradePlanLog(map);
	}
}
