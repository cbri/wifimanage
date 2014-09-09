package com.sinosoft.account.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sinosoft.account.bean.Account;
import com.sinosoft.account.bean.AccountDistrictRel;
import com.sinosoft.account.dao.AccountDao;
import com.sinosoft.account.service.AccountService;
import com.sinosoft.addrtree.bean.Position;

/**
 * 业务层实现
 * @author 于永波
 * @since   2014-5-29
 */
@Component
@Transactional
@Service(value="accountService")
public class AccountServiceImpl implements AccountService{
	@Autowired
	private AccountDao accountDao;
	
	public List<Account> getAccount(Map<String, Object> args) {
		return accountDao.getAccount(args);
	}
	
	public List<AccountDistrictRel> queryAccountDistrictRel(Account account) {
		return accountDao.queryAccountDistrictRel(account);
	}

	public List<AccountDistrictRel> queryAccountDistrict(AccountDistrictRel rel) {
		return null;
	}
	public Account saveAccount(Account account) {
		return accountDao.saveAccount(account);
	}

	public AccountDistrictRel saveAccountDistrict(AccountDistrictRel account) {
		return accountDao.saveAccountDistrict(account);
	}

	public void updateAccount(Map<String, Object> values) {
		accountDao.updateAccount(values);
	}

	public void deleteAccountDistrict(Map<String, Object> values) {
		accountDao.deleteAccountDistrict(values);
	}

}
