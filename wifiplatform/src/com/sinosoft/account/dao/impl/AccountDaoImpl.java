package com.sinosoft.account.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.sinosoft.account.bean.Account;
import com.sinosoft.account.bean.AccountDistrictRel;
import com.sinosoft.account.dao.AccountDao;
import com.sinosoft.base.dao.impl.BaseDaoImpl;

/**
 * DAO层实现代码
 * @author 于永波
 * @since  2014-5-29
 */
@Repository(value="accountDao")
public class AccountDaoImpl extends BaseDaoImpl implements AccountDao{

	public List<Account> getAccount(Map<String, Object> args){
		return getSqlMapClientTemplate().queryForList("getAccount",args);
	}
	public List<AccountDistrictRel> queryAccountDistrictRel(Account account) {
		return getSqlMapClientTemplate().queryForList("queryAccountDistrictRel",account);
	}
	public List<AccountDistrictRel> queryAccountDistrict(
			AccountDistrictRel accRel) {
		return getSqlMapClientTemplate().queryForList("queryAccountDistrict",accRel);
	}
	public Account saveAccount(Account account) {
		return (Account) getSqlMapClientTemplate().insert("saveAccount",account);
	}

	public AccountDistrictRel saveAccountDistrict(AccountDistrictRel account) {
		return (AccountDistrictRel) getSqlMapClientTemplate().insert("saveAccountDistrict",account);
	}

	public void updateAccount(Map<String, Object> values) {
		getSqlMapClientTemplate().update("account.updateAccount", values);
	}

	public void deleteAccountDistrict(Map<String, Object> values) {
		getSqlMapClientTemplate().delete("account.deleteAccountDistrict", values);
	}

}
