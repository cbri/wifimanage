package com.sinosoft.system.dao.impl;

import org.springframework.stereotype.Repository;

import com.sinosoft.base.dao.impl.BaseDaoImpl;
import com.sinosoft.system.bean.User;
import com.sinosoft.system.dao.LoginDAO;
import com.sinosoft.util.CipherUtil;
/**
 * 用户登录DAO实现类
 * @author zhaolj
 *
 */
@Repository("loginDAO")
public class LoginDAOImpl extends BaseDaoImpl implements LoginDAO {

	/**
	 * 根据用户名和密码查询用户
	 */
	public User getUserByNameAndPwd(String userName, String pwd) {
		// 设置查询参数
		User user = new User();
		user.setName(userName);
		user.setPwd(CipherUtil.generatePassword(pwd));
		// 获得查询结果
		return (User)getSqlMapClientTemplate().queryForObject("getUserByNameAndPwd", user);
		//return result == null ? false : true;
	}

}
