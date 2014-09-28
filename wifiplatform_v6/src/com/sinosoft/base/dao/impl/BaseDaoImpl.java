package com.sinosoft.base.dao.impl;

import java.io.Serializable;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sinosoft.base.dao.BaseDAO;
/**
 * DAO接口的实现类， 继承 SqlMapClientDaoSupport并初始化setSqlMapClient
 * @author zhaolj
 *
 * @param <T>
 * @param <PK>
 */
@Transactional
public class BaseDaoImpl<T, PK extends Serializable> extends SqlMapClientDaoSupport implements BaseDAO<T, PK> {
	
	private SqlMapClientTemplate sqlMapClientTemplate;
	
	@Resource(name="sqlMapClient")
	private SqlMapClient sqlMapClient;
	
	@PostConstruct
	public void initSqlMapClient() {
		super.setSqlMapClient(sqlMapClient);
	}
	
	
	
}
