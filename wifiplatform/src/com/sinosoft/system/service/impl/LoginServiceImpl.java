package com.sinosoft.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.system.bean.User;
import com.sinosoft.system.dao.LoginDAO;
import com.sinosoft.system.service.LoginService;
/**
 * 用户登录业务接口实现类
 * @author zhaolj
 *
 */
@Component
@Transactional
@Service(value="loginService")
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginDAO loginDAO;
	
	/**
	 * 根据用户名称和密码验证用户信息
	 */
	public User verificationUserInfo(String userName, String pwd) {
		return loginDAO.getUserByNameAndPwd(userName, pwd);
	}

}
