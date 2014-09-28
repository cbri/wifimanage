package com.sinosoft.system.service;

import com.sinosoft.system.bean.User;
/**
 * 
 * @author zhaolj
 *
 */
public interface LoginService {

	/**
	 * 根据用户名和密码验证用户信息
	 * @param userName    用户名
	 * @param pwd         密码
	 * @return
	 */
	public User verificationUserInfo(String userName, String pwd);
}
