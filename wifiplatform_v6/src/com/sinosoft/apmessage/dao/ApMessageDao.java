package com.sinosoft.apmessage.dao;

import java.util.List;
import java.util.Map;

import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.base.dao.BaseDAO;

public interface ApMessageDao extends BaseDAO {
	
	/**
	 * 查询所有AP信息
	 * 
	 * 
	 */

	
public List<ApMessage> searchApbyid(Map<String, Object> map);

public List<ApMessage> searchbyname(Map map);

public List<ApMessage> highranksearch(Map map);

public List findCtiyByCode(Map map);

public List findDistrictByCode(Map map);

public List init(Map map);

public List initProvince(Map map);

public List findNameByCode(Map map);


public List queryById(String apid);

public void insertProtocol_set_log(Map map);

public void insertInternet_limit_log(Map<String, Object> map);

public void insertUpgrade_ctrl_log(Map map);

public void insertUpgrade_ctrl(Map<String, Object> map);

public void insertPortal_set(Map<String, Object> map);

public void insertPortal_set_log(Map<String, String> map);

public List findCodeByid(Long id);

public List<ApMessage> searchbyCode(Map<String, Object> map);

public List queryAllApconfig(Map params);

public List setProtocolShow(Map<String, String> map);

public List<String> whitelistShow(Map<String, String> map);

public List<String> portalShow(Map<String, String> map);

public List<String> portal_TF(Map<String, String> map);

public void updateProtocol_set_log(Map<String, Object> map);

public void updatePortal_set_log(Map<String, Object> map);

public void updateInternet_limit_log(Map<String, Object> map);

public void updateUpgrade(Map<String, Object> map);

public List queryNameByCode(Map map);

public String queryApAddress(Map<String, Object> map);

public String queryApMerchant(Map<String, Object> map);
/**
 * 查询流量信息
 * @param args
 * @return
 */
public Map<String, Object> queryApFlow(Map<String, Object> args);












}
