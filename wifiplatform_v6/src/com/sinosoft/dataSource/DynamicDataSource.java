package com.sinosoft.dataSource;


import java.sql.SQLFeatureNotSupportedException;
import java.util.Map;
import java.util.logging.Logger;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

public class DynamicDataSource extends AbstractRoutingDataSource {
	
	//查找当前用户上下文变量中设置的数据源.
	@Override
	protected Object determineCurrentLookupKey() {
		// TODO Auto-generated method stub
		return DbContextHolder.getDbType();
	}
	
	//设置默认的数据源
    @Override
    public void setDefaultTargetDataSource(Object defaultTargetDataSource) {
        super.setDefaultTargetDataSource(defaultTargetDataSource);
    }
    
    //设置数据源集合.
    public void setTargetDataSources(Map targetDataSources) {
        super.setTargetDataSources(targetDataSources);
    }

	
	

    

}
