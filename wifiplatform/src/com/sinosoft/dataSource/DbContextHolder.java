package com.sinosoft.dataSource;


import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

public class DbContextHolder {
	
	public static Map<String, String> codeToDataSourceName = null;
	
	private static final ThreadLocal<String> contextHolder = new ThreadLocal<String>();  
	  
	//设置要切换的数据库DatasourceBean
	//dbType ：applicationContext.xml中数据库连接bean的唯一id
    public static void setDbType(String dbType) {  
        contextHolder.set(dbType);  
    }  
  
    //获取数据库连接名
    public static String getDbType() {  
        return ((String) contextHolder.get());  
    }  
  
    //清楚数据连接集合，除了默认连接
    public static void clearDbType() {  
        contextHolder.remove();  
    }
    
    //读取配置文件，根据指定pcode获取数据库连接名
    public static String getDataSourceName(String pcode){
    	if(codeToDataSourceName != null){
    		return codeToDataSourceName.get("code_"+pcode);
    	}
    	 ResourceBundle bundle = ResourceBundle.getBundle("com.sinosoft.dataSource.code_database");  
		 Set<String> set = bundle.keySet();
		 Iterator<String> it = set.iterator();
		 codeToDataSourceName = new HashMap<String, String>();
		 while(it.hasNext()){
			 String next = it.next();
			 if(next != null){
				 codeToDataSourceName.put(next, bundle.getString(next));
			 }
		 }
		return codeToDataSourceName.get("code_"+pcode);
    	
    }
}
