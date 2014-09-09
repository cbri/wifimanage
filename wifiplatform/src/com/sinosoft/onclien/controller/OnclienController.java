package com.sinosoft.onclien.controller;

import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.count.service.CountService;
import com.sinosoft.dataSource.DbContextHolder;
import com.sinosoft.onclien.bean.Connections;
import com.sinosoft.onclien.service.OnclienService;
import com.sinosoft.util.WebContextArguments;

/**
 * 客户设置管理控制层
 * @author 李洪因
 * @since  2014-6-13
 */
@Controller
public class OnclienController extends BaseController{
	@Autowired
	private OnclienService onclienService;
	@Autowired
	private CountService countService;
	/**
	 * 客户管理页面初始化
	 * @throws ParseException 
	 *
	 * */
	@RequestMapping(value="onclien!initAccountManage.do")
	public ModelAndView initAccountManage(HttpServletRequest req, HttpServletResponse rep) throws ParseException{
		DbContextHolder.clearDbType();
		ModelAndView mv = new ModelAndView("/source/page/onclien/business.jsp");
		//从session中获取省code
		Object pcode = ((Account)req.getSession().getAttribute("user")).getPcode();
		String mac=req.getParameter("mac");
		if(pcode!=null){
			String dataSourceName = DbContextHolder.getDataSourceName(pcode.toString());
			DbContextHolder.setDbType(dataSourceName);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("code", pcode);
			if(mac!=null){
				map.put("mac", mac);
				map.put("code", req.getParameter("pcode"));
			}
			List<Connections> connList = onclienService.getConnections(map);
			dispose(connList);
			mv.addObject("connList",connList);
			DbContextHolder.clearDbType();
			return mv;
		}else{
			return mv;
		}
	}
	
	@RequestMapping(value="onclien!querybyid")
	public String querybyid(HttpServletRequest req, HttpServletResponse rep) throws ParseException{
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		// 获取切库code
		Object pcodeobj = ((Account)req.getSession().getAttribute("user")).getPcode();
		String pcode = pcodeobj.toString();
		String id = req.getParameter("id");
	
		// 根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
		String dataSourceName = DbContextHolder.getDataSourceName(pcode);
		req.getSession().setAttribute("dataSourceName", dataSourceName);
		// 切换连接库（必须）
		DbContextHolder.setDbType(dataSourceName);
		// 获取连接的数据库名称----仅当需要数据库名称是打开此方法（可选）
		String dbType = DbContextHolder.getDbType();
		System.out.println("切换至" + dbType+ "数据库");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<Connections> connList = onclienService.findcusByid(map);
		String json = JSONArray.fromObject(connList).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(json);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != out) {
				out.close();
			}
		}
		DbContextHolder.clearDbType();
		return null;
	}
	
	
	/**
	 * 根据省代码切库查当前省全部商家信息
	 * @throws ParseException 
	 * */
	@RequestMapping(value="/onclien!querybycode",method=RequestMethod.POST)
	@ResponseBody
	public String searchbycode (HttpServletRequest req, HttpServletResponse rep) throws ParseException{
		String mac = req.getParameter("mac");
		//点击树获取省市区代码
		String pcode = req.getParameter("code");
		//点击市地区时切库
		String code = pcode.substring(0, 2);
				code+="0000";
		
		//根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
		String dataSourceName = DbContextHolder.getDataSourceName(code); 
		req.getSession().setAttribute("dataSourceName", dataSourceName);
		//切换连接库（必须）
		DbContextHolder.setDbType(dataSourceName); 
		
		//获取连接的数据库名称----仅当需要数据库名称是打开此方法（可选）
		String dbType = DbContextHolder.getDbType();
		System.out.println("----程序猿你好：您切换至->>---《"+dbType+"》数据库成功------------");  
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", pcode);
		map.put("mac", mac);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		List<Connections> connList = onclienService.getConnections(map);
		dispose(connList);
		//转成json格式
		String json = JSONArray.fromObject(connList).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(json);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		DbContextHolder.clearDbType(); 
		return null;
		//线程使用完成需清理连接集合，不会清理默认连接（必须）
	}
	/**
	 * 跳转客户分析
	 * @throws ParseException 
	 * */
	@RequestMapping(value="/onclien!initAccountAnalysis.do")
	public ModelAndView initAccountAnalysis(HttpServletRequest req, HttpServletResponse rep) throws ParseException{
		ModelAndView mv = new ModelAndView("/source/page/onclien/accountAnalysis.jsp");
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		// 从Session中获取userid
		Account user = (Account) req.getSession().getAttribute("user");
		List<String> codelist = new ArrayList<String>();
		HashMap params=new HashMap();
		List<HashMap> countList=new ArrayList<HashMap>();
		params.put("rank", 5);
		params.put("timeInterval",24);
		if (user.getId()==1) {
			// 如果是管理员直接查询全国level=0
			countList=onclienService.queryApCusCount(params);
		} else {
			// 获取用户管辖的最高级区域code
			codelist = countService.findTopCodeByid(user.getId());
			String code=codelist.get(0);
			if(code.endsWith("0000")){
				params.put("province", code);
			}else if(code.endsWith("00")){
				params.put("city", code);
			}else{
				params.put("district", code);
			}
			countList=onclienService.queryApCusCount(params);	
		}
		//将json数据传回
		for (HashMap hashMap : countList) {
			if(hashMap!=null){
				java.sql.Date d = (java.sql.Date)hashMap.get("date");
				d.toString();
				if(d!=null){
					hashMap.put("date", d.toString());
				}
				String province=WebContextArguments.codeToName.get(hashMap.get("province"));
				String city=WebContextArguments.codeToName.get(hashMap.get("city"));
				String district=WebContextArguments.codeToName.get(hashMap.get("district"));
				if(Arrays.asList(WebContextArguments.Directly_Province).contains(hashMap.get("province"))){
					hashMap.put("area", city+district);
				}else{
					hashMap.put("area", province+city+district);
				}
			}
		}
		req.setAttribute("countList", countList);
		return mv;
	}
	
	/**
	 * 查询ap客户统计
	 * @param req
	 * @param rep
	 */
	@ResponseBody
	@RequestMapping(value = "/onclien!queryApCusCount.do")
	public void queryApCusCount(HttpServletRequest req, HttpServletResponse rep) {
		rep.setContentType("text/html;charset=utf-8");
		//接收type和区域code
		String code=req.getParameter("code");
		String type=req.getParameter("type");
		String rank=req.getParameter("rank");
		String timeInterval=req.getParameter("timeInterval");
		List<HashMap> countList=new ArrayList<HashMap>();
		HashMap params=new HashMap();
		if(rank!=null){
			params.put("rank", Integer.parseInt(rank));
		}
		String hour=timeInterval.substring(0, 2);
		String minute=timeInterval.substring(3);
		params.put("timeInterval", Integer.parseInt(hour)*2+Integer.parseInt(minute)/30+1);
		//根据type拼装params
		if("0".equals(type)){
			params.put("province", code);
		}else if("1".equals(type)){
			params.put("city", code);
		}else{
			params.put("district", code);
		}
		countList=onclienService.queryApCusCount(params);
		//将json数据传回
		for (HashMap hashMap : countList) {
			if(hashMap!=null){
				java.sql.Date d = (java.sql.Date)hashMap.get("date");
				d.toString();
				if(d!=null){
					hashMap.put("date", d.toString());
				}
				String province=WebContextArguments.codeToName.get(hashMap.get("province"));
				String city=WebContextArguments.codeToName.get(hashMap.get("city"));
				String district=WebContextArguments.codeToName.get(hashMap.get("district"));
				if(Arrays.asList(WebContextArguments.Directly_Province).contains(hashMap.get("province"))){
					hashMap.put("area", city+district);
				}else{
					hashMap.put("area", province+city+district);
				}
			}
		}
		String json = JSONArray.fromObject(countList).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(json);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != out) {
				out.close();
			}
		}
	}
	/**
	 * 图表ap客户在线
	 * @param req
	 * @param rep
	 */
	@ResponseBody
	@RequestMapping(value = "/onclien!initAPCustomerChart.do")
	public void initAPCustomerChart(HttpServletRequest req, HttpServletResponse rep) {
		rep.setContentType("text/html;charset=utf-8");
		List<HashMap> resultList = new ArrayList<HashMap>();
		//查询该mac前一天的在线客户数曲线
		String mac=req.getParameter("mac");
		resultList=onclienService.queryApCusCountByMac(mac);
		//将json数据传回
		for (HashMap hashMap : resultList) {
			if(hashMap!=null){
				java.sql.Date d = (java.sql.Date)hashMap.get("date");
				if(d!=null){
					hashMap.put("date", d.toString());
				}
			}
		}
		//将json数据传回
		String json = JSONArray.fromObject(resultList).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(json);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != out) {
				out.close();
			}
		}
	}
	//
	private void dispose(List<Connections> cList) throws ParseException {		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for (Connections con : cList) {
				String p = con.getProvince();
				String ccode = con.getCity();
				String dcode = con.getDistrict();
				Position province1 = WebContextArguments.codeToObject.get(p);
				Position city1 = WebContextArguments.codeToObject.get(ccode);
				Position district1 = WebContextArguments.codeToObject.get(dcode);
				
				
				java.text.DecimalFormat   df=new   java.text.DecimalFormat("#.#");   
				//上行流量
				String num,outgoing;
				int n = con.getOutgoing();
				if(n%Math.pow(1024, 3) != n){
					double d = n/Math.pow(1024, 3);
					num = df.format(d);
					outgoing = num+"GB";
				}else if(n%Math.pow(1024, 2) != n){
					double d = n/Math.pow(1024, 2);
					num = df.format(d);
					outgoing = num+"MB";
				}else if(n%Math.pow(1024, 1) != n){
					double d = n/1024;
					num = df.format(d);
					outgoing = num+"KB";
				}else{
					outgoing = n+"KB";
				}
				con.setOut(outgoing);
				//下行流量
				String num1,incoming;
				int m = con.getIncoming();
				if(m%Math.pow(1024, 3) != m){
					double d = m/Math.pow(1024, 3);
					num = df.format(d);
					incoming = num+"GB";
				}else if(m%Math.pow(1024, 2) != m){
					double d = m/Math.pow(1024, 2);
					num = df.format(d);
					incoming = num+"MB";
				}else if(m%Math.pow(1024, 1) != m){
					double d = m/1024;
					num = df.format(d);
					incoming = num+"KB";
				}else{
					incoming = m+"KB";
				}
				con.setIn(incoming);
				
				
				//终端类型
				String s = "";
				if(con.getDevice().toUpperCase().indexOf("ANDROID") != -1){
					s = "android";
				}else if(con.getDevice().toUpperCase().indexOf("IPHONE") != -1){
						s = "iphone";
				}else if(con.getDevice().toUpperCase().indexOf("WINDOWS") != -1){ 
						s =  "pc";
				}else if(con.getDevice().toUpperCase().indexOf("MAC OS") != -1){
						s =  "pc";
				}else if(con.getDevice().toUpperCase().indexOf("IPAD") != -1){
						s = "ipad";
				}else {
						s = con.getDevice();
				}
				con.setDevice(s);
				//商户名称
				if(con.getMerchant()==null || con.getMerchant()==""){
					con.setMerchant(con.getMerchant().substring(0,8)+"......");
				}
				
				//区域				
				if(province1!=null){
					con.setPname(province1.getName());
				}
				if(city1!=null){
					con.setCname(city1.getName());
				} 
				if(province1.getName().equals(city1.getName())){
					con.setCname("");
				}
				if(district1!=null){
					con.setDname(district1.getName());
				} 			
				//将dataTime类型的时间转换成String类型
				String time = sdf.format(con.getUsed_on());
				con.setTime(time);
		}
	}
}
