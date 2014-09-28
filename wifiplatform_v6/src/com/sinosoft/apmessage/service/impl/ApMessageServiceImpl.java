package com.sinosoft.apmessage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.apmessage.dao.ApMessageDao;
import com.sinosoft.apmessage.service.ApMessageService;



@Component
@Transactional
@Service(value="apMessageService")
public  class ApMessageServiceImpl implements ApMessageService {
	
	
	
	@Autowired
	private ApMessageDao apMessageDao;
	
	
	public List<ApMessage> searchApbyid(Map<String, Object> map) {
		
		
		return apMessageDao.searchApbyid(map);
	}
	public List<ApMessage> searchbyname(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.searchbyname(map);
	}
	public List<ApMessage> highranksearch(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.highranksearch(map);
	}
	public List findCtiyByCode(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.findCtiyByCode(map);
	}
	public List findDistrictByCode(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.findDistrictByCode(map);
	}
	public List initProvince(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.initProvince(map);
	}
	public List init(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.init(map);
	}
	public List findNameByCode(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.findNameByCode(map);
		
	}
	
	//根据商户ID查询商户名称用于在AP配置页面展示
	/*public Map queryById(Map<String, String> map) {
		String merchant_id = (String) map.get("merchant_id");
		List list = apMessageDao.queryById(merchant_id); //根据商户ID查询商户名称用于在AP配置页面展示
		Map merchantMap = (Map) list.get(0);
		String merchant_name = (String) merchantMap.get("merchant_name");
		map.putAll(merchantMap);
		return map;
		
	}*/
	
	
	public void insertProtocol_set_log(Map map) {
			//Map mapAll = queryById(map);
		 apMessageDao.insertProtocol_set_log(map);
	}
	
	public void insertInternet_limit_log(Map<String, Object> map) {
		//Map mapAll = queryById(map);
		 apMessageDao.insertInternet_limit_log(map);
	}
	
	public void insertUpgrade_ctrl_log(Map<String, Object> map) {
		//Map mapAll = queryById(map);
		 apMessageDao.insertUpgrade_ctrl_log(map);
	}
	
	public void insertUpgrade_ctrl(Map<String, Object> map) {
		 apMessageDao.insertUpgrade_ctrl(map);
	}
	
	public void insertPortal_set_log(Map<String, String> map) {
		 apMessageDao.insertPortal_set_log(map);
	}
	
	public void insertPortal_set(Map<String, Object> map) {
		apMessageDao.insertPortal_set(map);
	}
	
	public List findCodeByid(Long id) {
		// TODO Auto-generated method stub
		return apMessageDao.findCodeByid(id);
	}
	public List<ApMessage> searchbyCode(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return apMessageDao.searchbyCode(map);
	}
	public List queryAllApconfig(Map params) {
		return apMessageDao.queryAllApconfig(params);
	}
	
	public List setProtocolShow(Map<String, String> map) {
		// TODO Auto-generated method stub
		return apMessageDao.setProtocolShow(map);
	}
	public List<String> whitelistShow(Map<String, String> map) {
		// TODO Auto-generated method stub
		return apMessageDao.whitelistShow(map);
	}
	public List<String> portalShow(Map<String, String> map) {
		// TODO Auto-generated method stub
		return apMessageDao.portalShow(map);
	}
	public List<String> portal_TF(Map<String, String> map) {
		// TODO Auto-generated method stub
		return apMessageDao.portal_TF(map);
	}

	public void updateProtocol_set_log(Map<String, Object> map) {
		apMessageDao.updateProtocol_set_log(map);
	}
	public void updatePortal_set_log(Map<String, Object> map) {
		apMessageDao.updatePortal_set_log(map);
	}
	public void updateInternet_limit_log(Map<String, Object> map) {
		apMessageDao.updateInternet_limit_log(map);
	}
	public void updateUpgrade(Map<String, Object> map) {
		apMessageDao.updateUpgrade(map);
	}
	public List queryNameByCode(Map map) {
		// TODO Auto-generated method stub
		return apMessageDao.queryNameByCode(map);
	}
	public Map<String, Object> queryApFlow(Map<String, Object> args) {
		return apMessageDao.queryApFlow(args);
	}
	public String queryApAddress(Map<String, Object> map) {
		return apMessageDao.queryApAddress(map);
	}
	public String queryApMerchant(Map<String, Object> map) {
		return apMessageDao.queryApMerchant(map);
	}

	
	
	
}
