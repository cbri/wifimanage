package com.sinosoft.count.quartz;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.count.bean.Count;
import com.sinosoft.count.dao.CountQuartzDao;
import com.sinosoft.dataSource.DbContextHolder;
import com.sinosoft.util.WebContextArguments;

@Service(value="countQuartz")
public class CountQuartz {

	public CountQuartzDao getCountQuartzDao() {
		return countQuartzDao;
	}

	public void setCountQuartzDao(CountQuartzDao countQuartzDao) {
		this.countQuartzDao = countQuartzDao;
	}

	@Autowired
	private CountQuartzDao countQuartzDao;
	
	/**
	 * 定时统计
	 */
	public void executeInternal(){
		/**
		 * 查询省表每一个省创建一个线程
		 */
		List provinceList=countQuartzDao.queryProvince();
		for(int i=0;i<1;i++){
			final HashMap province=(HashMap) provinceList.get(i);
			//每一个省都自动启动一个线程
			new Thread(){
				@Override
				public void run() {
					//当前日期
					Date date=new Date();
					DecimalFormat df=new DecimalFormat("#.00%");
					//遍历map获得所有省下面的市
					Map<String, Position> position=WebContextArguments.codeToObject;
					List cityList=new ArrayList();
					for(String key:position.keySet()){
						if(position.get(key).getpId().equals(province.get("code"))){
							cityList.add(position.get(key));
						}
					}
					Count provinceCount=new Count();
					//省id
					provinceCount.setCode((String) province.get("code"));
					//父区域编码
					provinceCount.setParent_code(null);
					//省名称
					provinceCount.setName(WebContextArguments.codeToName.get(province.get("code")));
					//区域级别
					provinceCount.setLevel(0);
					//省AP总数
					int provinceCountAPCount=0;
					//在线数
					int provinceOnlineCount=0;
					//在线率
					String provinceRate="";
					//上行流量
					BigDecimal provinceIncoming=new BigDecimal(0);
					//下行流量
					BigDecimal provinceOutgoing=new BigDecimal(0);
					//客户数
					long provinceCustomerNum = 0;
					System.out.println("省份名称--------------->"+province.get("name"));
					for(int j=0;j<cityList.size();j++){
						//获取当前城市
						Position city=(Position) cityList.get(j);
						//每个城市的记录
						System.out.println("城市名称--------------->"+city.getName());
						Count cityCount=new Count();
						//城市id
						cityCount.setCode(city.getId());
						//父区域编码
						cityCount.setParent_code(city.getpId());
						//城市名称
						cityCount.setName(WebContextArguments.codeToName.get(city.getId()));
						//区域级别
						cityCount.setLevel(1);
						//城市AP总数
						int cityCountAPCount=0;
						//在线数
						int cityOnlineCount=0;
						//在线率
						String cityRate="";
						//上行流量
						BigDecimal cityIncoming=new BigDecimal(0);
						//下行流量
						BigDecimal cityOutgoing=new BigDecimal(0);
						//客户数
						long cityCustomerNum = 0;
						//2.查询市下所有的区域
						List districtList=new ArrayList();
						for(String key:position.keySet()){
							if(position.get(key).getpId().equals(city.getId())){
								districtList.add(position.get(key));
							}
						}
						//遍历城市每个区
						for(int m=0;m<districtList.size();m++){
							//根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
							String dataSourceName = DbContextHolder.getDataSourceName((String) province.get("code")); 
							//切换连接库（必须）
							DbContextHolder.setDbType(dataSourceName); 
							//切换数据库
							String dbType = DbContextHolder.getDbType();
							System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");  
							System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");  
							System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");
							//获取连接的数据库名称----仅当需要数据库名称是打开此方法（可选）
							//获取当前区域
							Position district=(Position) districtList.get(m);
							//根据区域id查询apid得到该区域所有apid.
							String districtid=(String) district.getId();
							List apidList=countQuartzDao.queryApId(districtid);
							//apidList的长度为AP总数
							int apCount=apidList.size();
							//查询在线数
							int onlineCount=countQuartzDao.queryApOnline(districtid);
							//计算在线率
							String rate="";
							if(apCount!=0){
								rate=df.format(onlineCount/(double)apCount);
							}
							//遍历该区域下所有apid查询ap信息apmac
							BigDecimal incoming = new BigDecimal(0);
							BigDecimal outgoing = new BigDecimal(0);
							long customer_num = 0;
							for(int n=0;n<apCount;n++){
								String apid=(String) apidList.get(n);
								HashMap ap=countQuartzDao.queryAp(apid);
								//根据apmac查询统计数据等等
								String mac=(String) ap.get("mac");
								HashMap connections=countQuartzDao.queryConnections(mac);
								
								incoming=incoming.add((BigDecimal)connections.get("incoming"));
								outgoing=outgoing.add((BigDecimal)connections.get("outgoing"));
								customer_num+=(Long)connections.get("customer_num");
							}
							DbContextHolder.clearDbType(); //线程使用完成需清理连接集合，不会清理默认连接（必须）
							//拼装一条统计信息
							Count count=new Count();
							//区域编码
							count.setCode(districtid);
							//父区域编码
							count.setParent_code(city.getId());
							//区域名称
							count.setName(WebContextArguments.codeToName.get(districtid));
							//区域级别
							count.setLevel(2);
							//AP总数
							count.setAp_total(apCount);
							//在线数
							count.setOnline_num(onlineCount);
							//在线率
							count.setOnline_rate(rate);
							//上行流量
							count.setInconming_total(incoming);
							//下行流量
							count.setOutgoing_total(outgoing);
							//客户数
							count.setCustomer_num(customer_num);
							//将区域统计信息求和变为城市统计信息
							cityCountAPCount+=apCount;
							cityOnlineCount+=onlineCount;
							cityIncoming=cityIncoming.add(incoming);
							cityOutgoing=cityOutgoing.add(outgoing);
							cityCustomerNum+=customer_num;
							//区域级别取出上次的统计信息为空则执行插入不为空进行计算并将结果记录在发展表里更新本次统计信息
							Count lastCount=countQuartzDao.queryLastCount(districtid);
							count.setDate(date);
							count.setYearNum(date.getYear()+1900);
							count.setMonthNum(date.getMonth()+1);
							count.setDay(date.getDate());
							if(lastCount!=null){
								//更新统计信息
								countQuartzDao.updateCount(count);
								//计算差值
								//AP总数
								count.setAp_total(apCount-(Integer)lastCount.getAp_total());
								//上行流量
								count.setInconming_total(incoming.subtract((BigDecimal)lastCount.getInconming_total()));
								//下行流量
								count.setOutgoing_total(outgoing.subtract((BigDecimal)lastCount.getOutgoing_total()));
								//客户数
								count.setCustomer_num(customer_num-lastCount.getCustomer_num());
								countQuartzDao.insertGrowthSpeedDay(count);
							}else{
								//直接插入统计信息
								countQuartzDao.insertCount(count);
								//发展表就是本次统计
								countQuartzDao.insertGrowthSpeedDay(count);
							}
							
						}
						//拼装城市数据
						cityRate=df.format(cityOnlineCount/(double)cityCountAPCount);
						cityCount.setDate(date);
						cityCount.setYearNum(date.getYear()+1900);
						cityCount.setMonthNum(date.getMonth()+1);
						cityCount.setDay(date.getDate());
						cityCount.setAp_total(cityCountAPCount);
						cityCount.setCustomer_num(cityCustomerNum);
						cityCount.setInconming_total(cityIncoming);
						cityCount.setOutgoing_total(cityOutgoing);
						cityCount.setOnline_num(cityOnlineCount);
						cityCount.setOnline_rate(cityRate);
						//将城市信息统计求和变为省统计信息
						provinceCountAPCount+=cityCountAPCount;
						provinceOnlineCount+=cityOnlineCount;
						provinceIncoming=provinceIncoming.add(cityIncoming);
						provinceOutgoing=provinceOutgoing.add(cityOutgoing);
						provinceCustomerNum += cityCustomerNum;
						//城市级别取出上次的统计信息为空则执行插入不为空进行计算并将结果记录在发展表里更新本次统计信息
						Count lastCityCount=countQuartzDao.queryLastCount(city.getId());
						if(lastCityCount!=null){
							//更新统计信息
							countQuartzDao.updateCount(cityCount);
							//计算差值
							//AP总数
							cityCount.setAp_total(cityCountAPCount-(Integer)lastCityCount.getAp_total());
							//上行流量
							cityCount.setInconming_total(cityIncoming.subtract((BigDecimal)lastCityCount.getInconming_total()));
							//下行流量
							cityCount.setOutgoing_total(cityOutgoing.subtract((BigDecimal)lastCityCount.getOutgoing_total()));
							//客户数
							cityCount.setCustomer_num(cityCustomerNum-lastCityCount.getCustomer_num());
							countQuartzDao.insertGrowthSpeedDay(cityCount);
						}else{
							//直接插入城市统计
							countQuartzDao.insertCount(cityCount);
							//发展表就是本次统计
							countQuartzDao.insertGrowthSpeedDay(cityCount);
						}
					}
					//拼装省数据
					provinceRate=df.format(provinceOnlineCount/(double)provinceCountAPCount);
					provinceCount.setDate(date);
					provinceCount.setYearNum(date.getYear()+1900);
					provinceCount.setMonthNum(date.getMonth()+1);
					provinceCount.setDay(date.getDate());
					provinceCount.setAp_total(provinceCountAPCount);
					provinceCount.setCustomer_num(provinceCustomerNum);
					provinceCount.setInconming_total(provinceIncoming);
					provinceCount.setOutgoing_total(provinceOutgoing);
					provinceCount.setOnline_num(provinceOnlineCount);
					provinceCount.setOnline_rate(provinceRate);
					//省级别取出上次的统计信息为空则执行插入不为空进行计算并将结果记录在发展表里更新本次统计信息
					Count lastProvinceCount=countQuartzDao.queryLastCount((String) province.get("code"));
					if(lastProvinceCount!=null){
						//更新统计信息
						countQuartzDao.updateCount(provinceCount);
						//计算差值
						//AP总数
						provinceCount.setAp_total(provinceCountAPCount-(Integer)lastProvinceCount.getAp_total());
						//上行流量
						provinceCount.setInconming_total(provinceIncoming.subtract((BigDecimal)lastProvinceCount.getInconming_total()));
						//下行流量
						provinceCount.setOutgoing_total(provinceOutgoing.subtract((BigDecimal)lastProvinceCount.getOutgoing_total()));
						//客户数
						provinceCount.setCustomer_num(provinceCustomerNum-lastProvinceCount.getCustomer_num());
						countQuartzDao.insertGrowthSpeedDay(provinceCount);
					}else{
						//直接插入省统计
						countQuartzDao.insertCount(provinceCount);
						//发展表就是本次统计
						countQuartzDao.insertGrowthSpeedDay(provinceCount);
					}
				}
			}.start();
		}
	}
}
