package com.sinosoft.count.quartz;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sinosoft.count.dao.CountQuartzDao;
import com.sinosoft.dataSource.DbContextHolder;

@Service(value = "apCustomerQuartz")
public class ApCustomerQuartz {
	
	@Autowired
	private CountQuartzDao countQuartzDao;
	
	public CountQuartzDao getCountQuartzDao() {
		return countQuartzDao;
	}

	public void setCountQuartzDao(CountQuartzDao countQuartzDao) {
		this.countQuartzDao = countQuartzDao;
	}

	/**
	 * 定时统计
	 */
	public void executeInternal(){
		System.out.println("这是第3个调度器");
		/**
		 * 查询省表每一个省创建一个线程
		 */
		List provinceList=countQuartzDao.queryProvince();
		for(int i=0;i<1;i++){
			final HashMap province=(HashMap) provinceList.get(i);
			new Thread(){
				public void run() {
					//获得当前系统时间
					Date now=new Date();
					int hour=now.getHours();
					int minute=now.getMinutes();
					int timeInterval=hour*2+minute/30+1;
					//当时段为1的时候即0:00-0:30这个时间段的调度将昨天的数据清除
					if(timeInterval==1){
						countQuartzDao.deleteApCustomerCount();
					}
					//根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
					String dataSourceName = DbContextHolder.getDataSourceName((String) province.get("code")); 
					//切换连接库（必须）
					DbContextHolder.setDbType(dataSourceName); 
					//切换数据库
					String dbType = DbContextHolder.getDbType();
					System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");  
					System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");  
					System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");
					//查询该省当时所有ap
					List<HashMap> apList=countQuartzDao.queryProvinceAp();
					List apCusCountList=new ArrayList();
					for(int i=0;i<apList.size();i++){
						HashMap ap=apList.get(i);
						//计算AP的在线客户数
						int online_num=(Integer)countQuartzDao.queryApCustomerOnline((String)ap.get("mac"));
						//查询ap对应的地址
						HashMap apAddress=countQuartzDao.queryApAddress((Integer)ap.get("id"));
						//查询ap对应的商户
						HashMap apMerchant=countQuartzDao.queryApMerchant((Integer)ap.get("id"));
						//拼装一条记录插入ap_customer_count
						HashMap apCustomerCount=new HashMap();
						apCustomerCount.put("apid", ap.get("id"));
						apCustomerCount.put("apmac", ap.get("mac"));
						apCustomerCount.put("province", apAddress.get("province"));
						apCustomerCount.put("city", apAddress.get("city"));
						apCustomerCount.put("district", apAddress.get("district"));
						apCustomerCount.put("detail", apAddress.get("detail"));
						apCustomerCount.put("merchant", apMerchant.get("merchant"));
						apCustomerCount.put("timeinterval", timeInterval);
						apCustomerCount.put("date",	now);
						apCustomerCount.put("online_num", online_num);
						apCusCountList.add(apCustomerCount);
						
					}
					DbContextHolder.clearDbType(); //线程使用完成需清理连接集合，不会清理默认连接（必须）
					//将所有的ap记录插入表
					for(int i=0;i<apCusCountList.size();i++){
						countQuartzDao.insertApCustomerCount((HashMap) apCusCountList.get(i));
					}
				}
			}.start();
		}
	}
	
}
