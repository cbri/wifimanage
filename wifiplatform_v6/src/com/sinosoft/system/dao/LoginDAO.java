package com.sinosoft.system.dao;

import com.sinosoft.base.dao.BaseDAO;
import com.sinosoft.system.bean.User;
/**
 * 用户登录DAO
 * @author zhaolj
 *
 */
public interface LoginDAO extends BaseDAO{

	/**
	 * 根据用户名和密码查询用户
	 * @param userName  用户名
	 * @param pwd       密码
	 * @return
	 */
	public User getUserByNameAndPwd(String userName, String pwd);
}
