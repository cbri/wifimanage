package com.sinosoft.apmessage.controller;

import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.account.bean.AccountDistrictRel;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.apmessage.bean.ApMessage;
import com.sinosoft.apmessage.service.ApMessageService;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.dataSource.DbContextHolder;
import com.sinosoft.util.CommonDaoImpl;
import com.sinosoft.util.DateComparator;
import com.sinosoft.util.NowStringUtil;
import com.sinosoft.util.RemoteCallUtil;
import com.sinosoft.util.WebContextArguments;

/**
 * apM控制层
 * @author dyf
 *
 */

@Controller
public class ApMessageController extends BaseController{
	
	
	private static final String Account = null;
	@Autowired
	private ApMessageService apMessageService;
	@Autowired
	private CommonDaoImpl commonDao;
	
	
	/**
	 * AP信息初始页面
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!queryap")
	public ModelAndView queryallap(HttpServletRequest req, ApMessage apMessage)
			throws ParseException {
		DbContextHolder.clearDbType();
		ModelAndView mv1 = new ModelAndView("/source/page/ap/ap.jsp");
		//从session中获取省code
		Account user = (Account)req.getSession().getAttribute("user");
		Object pcode = user.getPcode();
		String mac=req.getParameter("mac");
		if(pcode!=null){
			String dataSourceName = DbContextHolder.getDataSourceName(pcode.toString());
			DbContextHolder.setDbType(dataSourceName);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("pcode", pcode);
			if(mac!=null){
				map.put("mac", mac);
				map.put("pcode", req.getParameter("pcode"));
			}
			userPermissionDistrictCodes(user, map);
			map.put("pagenum", WebContextArguments.ZERO);
			map.put("pagesize", WebContextArguments.PAGE_SIZE);
			List<ApMessage> apMessageList = apMessageService.searchbyCode(map);
			dispose(apMessageList);
			mv1.addObject(apMessageList);
			DbContextHolder.clearDbType();
			return mv1;
		}else{
			return mv1;
	}
	}
	/**
	 * AP监控初始页面
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!queryapMonitor")
	public ModelAndView queryapMonitor(HttpServletRequest req,
			ApMessage apMessage) throws ParseException {
		DbContextHolder.clearDbType();
		ModelAndView mv = new ModelAndView("/source/page/ap/apmonitor.jsp");
		Account user = (com.sinosoft.account.bean.Account) req.getSession().getAttribute("user");
		Object pcode = user.getPcode();
		if(pcode!=null){
			String dataSourceName = DbContextHolder.getDataSourceName(pcode.toString());
			DbContextHolder.setDbType(dataSourceName);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("pcode", pcode);
			map.put("pagenum", WebContextArguments.ZERO);
			userPermissionDistrictCodes(user, map);
			map.put("pagesize", WebContextArguments.PAGE_SIZE);
			List<ApMessage> apMessageList = apMessageService.searchbyCode(map);
			dispose(apMessageList);
			mv.addObject(apMessageList);
			DbContextHolder.clearDbType();
			return mv;
		}else{
			return mv;
	}
	}
	
	/**
	 * 用户的权限区域
	 * @param user
	 * @param map
	 */
	private void userPermissionDistrictCodes(Account user,
			Map<String, Object> map) {
		//市级用户的权限区域Code
		List<String> cityCodes = null;
		//县级用户的权限区域
		List<String> districtCodes = null;
		//判断用户级别
		if(user.getLevel() == 1){
			cityCodes = new ArrayList<String>();
			//市级用户
			List<AccountDistrictRel> positions = user.getPositions();
			for (AccountDistrictRel p : positions) {
				if(p != null){
					cityCodes.add(p.getCode());
				}
			}
		}else if(user.getLevel() == 2){
			//区级用户
			districtCodes = new ArrayList<String>();
			List<AccountDistrictRel> positions = user.getPositions();
			for (AccountDistrictRel p : positions) {
				if(p != null){
					districtCodes.add(p.getCode());
				}
			}
		}
		map.put("cityCodes", cityCodes);
		map.put("districtCodes",districtCodes);
	}
	@RequestMapping(value = "/apmController!lookApFlow.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject lookApFlow(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
		DbContextHolder.clearDbType();
		Account user = (Account) req.getSession().getAttribute("user");
		String pcode = user.getPcode();
		//清除上次选择地区数据库
		String dataSourceName = DbContextHolder.getDataSourceName(pcode);
		DbContextHolder.setDbType(dataSourceName);
		String mac = req.getParameter("mac");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("mac", mac);
		Map<String, Object> queryApFlow = apMessageService.queryApFlow(args);
		JSONObject object = new JSONObject();
		if(queryApFlow == null){
			object.element("incoming", 0);
			object.element("outgoing", 0);
			return object;
		}else{
			long a1 = (Long.parseLong((queryApFlow.get("incoming")==null?"0":queryApFlow.get("incoming").toString()))/1024);
			long a2 = (Long.parseLong(queryApFlow.get("outgoing")==null?"0":queryApFlow.get("outgoing").toString()))/1024;
			object.element("incoming", a1);
			object.element("outgoing", a2);
		}
		DbContextHolder.clearDbType();
		return object;
		// 线程使用完成需清理连接集合，不会清理默认连接（必须）
	}
	

	/**
	 * 根据省代码切库查当前省全部AP信息
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!querybycode", method = RequestMethod.POST)
	@ResponseBody
	public String searchbycode(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		// 获取切库code
		String pcode = req.getParameter("code");
		// 点击的是市或区，切成省code
		String code = pcode.substring(0, 2);
		code += "0000";
		Account user = (Account)req.getSession().getAttribute("user");
		user.setPcode(code);
		// 根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
		String dataSourceName = DbContextHolder.getDataSourceName(code);
		req.getSession().setAttribute("dataSourceName", dataSourceName);
		// 切换连接库（必须）
		DbContextHolder.setDbType(dataSourceName);
		// 获取连接的数据库名称----仅当需要数据库名称是打开此方法（可选）
		String dbType = DbContextHolder.getDbType();
		System.out.println("切换至" + dbType+ "数据库");
		// 根据点击树code查询AP信息
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pcode", pcode);
		map.put("pagenum", 0);
		map.put("pagesize", 15);
		userPermissionDistrictCodes(user, map);
		List<ApMessage> apMessageList = apMessageService.searchbyCode(map);
		// 处理日期、在线离线
		dispose(apMessageList);
		String json = JSONArray.fromObject(apMessageList).toString();
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
		// 线程使用完成需清理连接集合，不会清理默认连接（必须）
	}

	private void dispose(List<ApMessage> apMessageList) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		for (int i = 0; i < apMessageList.size(); i++) {
			String province = apMessageList.get(i).getProvince();
			String city = apMessageList.get(i).getCity();
			String district = apMessageList.get(i).getDistrict();
			Position province1 = WebContextArguments.codeToObject.get(province);
			Position city1 = WebContextArguments.codeToObject.get(city);
			Position district1 = WebContextArguments.codeToObject.get(district);
			if (province1 != null) {
				apMessageList.get(i).setProvince(province1.getName());
			}
			if (city1 != null) {
				apMessageList.get(i).setCity(city1.getName());
			}
			if (district1 != null) {
				apMessageList.get(i).setDistrict(district1.getName());
			}
			// 处理在线离线显示
			String tempdate = apMessageList.get(i).getLast_seen();
			if (tempdate == null) {
				continue;
			}
			// 处理在线离线显示
			long platform = apMessageList.get(i).getBelong_type();
			if (platform== 1) {
				apMessageList.get(i).setPlatform("浙江");;
			}else{
				apMessageList.get(i).setPlatform("北研");
			}
			java.util.Date d = sdf.parse(tempdate);
			long t = ((new java.util.Date()).getTime() - (d.getTime())) / (1000);
			if (t < 70) {
				// 在线
				apMessageList.get(i).setOnLine(true);
			} else {
				// 不在线
				apMessageList.get(i).setOnLine(false);
			}
		}
	}
	/**
	 * AP信息滚动加载
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!querybylimit", method = RequestMethod.POST)
	@ResponseBody
	public String querybylimit(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		// 获取切库code
		Account user = ((Account)req.getSession().getAttribute("user"));
		Object pcodeobj =  user.getPcode();
		String pcode = pcodeobj.toString();
		// 根据当前用户code（省，例：110000、130000）获取数据库连接（必须）
		String dataSourceName = DbContextHolder.getDataSourceName(pcode);
		req.getSession().setAttribute("dataSourceName", dataSourceName);
		// 切换连接库（必须）
		DbContextHolder.setDbType(dataSourceName);
		// 获取连接的数据库名称----仅当需要数据库名称是打开此方法（可选）
		String pagenum = req.getParameter("pagenum");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pcode", pcode);
		if(pagenum != null && !"".equals(pagenum)){
			map.put("pagenum", Integer.parseInt(pagenum)*WebContextArguments.PAGE_SIZE);
			map.put("pagesize", WebContextArguments.PAGE_SIZE);
		}
		userPermissionDistrictCodes(user, map);
		List<ApMessage> apMessageList = apMessageService.searchbyCode(map);
		dispose(apMessageList);
		String json = JSONArray.fromObject(apMessageList).toString();
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
		// 线程使用完成需清理连接集合，不会清理默认连接（必须）
	}
	/**
	 * 根据id查询商户详细信息
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!querybyid", method = RequestMethod.POST)
	@ResponseBody
	public String searchbyid(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
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
		List<ApMessage> apMessageList = apMessageService.searchbyname(map);
		String json = JSONArray.fromObject(apMessageList).toString();
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
	 * 根据id查询ＡＰ详细信息
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!searchApbyid", method = RequestMethod.POST)
	@ResponseBody
	public String searchApbyid(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		// 获取切库code
		Object pcodeobj = ((Account)req.getSession().getAttribute("user")).getPcode();
		String pcode = pcodeobj.toString();
		String id = req.getParameter("id");
		// 点击的是市或区，切成省code
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
		List<ApMessage> apMessageList = apMessageService.searchApbyid(map);
		dispose(apMessageList);
		String json = JSONArray.fromObject(apMessageList).toString();
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
	 * 根据用户选择的条件高级搜索，MAC地址搜索
	 * 
	 * @throws ParseException
	 * */
	@ResponseBody
	@RequestMapping(value = "/apmController!highranksearch")
	public String highranksearch(HttpServletRequest req, HttpServletResponse rep)
			throws ParseException {
		Object pcodeobj = ((Account)req.getSession().getAttribute("user")).getPcode();
		String pcode = pcodeobj.toString();
		String name = req.getParameter("name");
		String mac = req.getParameter("mac");
		String hardware_ver = req.getParameter("hardware_ver");
		String software_ver = req.getParameter("software_ver");
		String ssid = req.getParameter("ssid");
		String ipaddr = req.getParameter("ipaddr");
		String province_code = req.getParameter("province");
		province_code = (province_code == null||"".equals(province_code)) ? pcode : province_code;
		String city_code = req.getParameter("city");
		String district_code = req.getParameter("district");
		String starttime = req.getParameter("starttime");
		String endtime = req.getParameter("endtime");
		String merchant = req.getParameter("merchant");
		String timeType = req.getParameter("time");
		String pagenum = req.getParameter("pagenum");
		
		//判断时间0为在线 1为离线
		// 切库
		String dataSourceName = DbContextHolder.getDataSourceName(pcode);
		req.getSession().setAttribute("dataSourceName", dataSourceName);
		DbContextHolder.setDbType(dataSourceName);
		String dbType = DbContextHolder.getDbType();
		System.out.println("----程序猿你好：您切换至->>---《" + dbType+ "》数据库成功------------");
		// 查询
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", name);
		map.put("mac",mac);
		map.put("hardware_ver", hardware_ver);
		map.put("software_ver", software_ver);
		map.put("ssid", ssid);
		map.put("ipaddr", ipaddr);
		map.put("merchant", merchant);
		map.put("province_code", province_code);
		map.put("city_code", city_code);
		map.put("district_code", district_code);
		map.put("starttime", starttime);
		map.put("endtime", endtime);
		Date online = new Date();
		Date outline = new Date();
		if(timeType != null && "0".equals(timeType)){
			//在线
			map.put("online", sdf.format(online));
		}else if(timeType != null && "1".equals(timeType)){
			//离线
			map.put("outline", sdf.format(outline));
		}
		if(pagenum != null && !"".equals(pagenum)){
			map.put("pagenum", Integer.parseInt(pagenum)*WebContextArguments.PAGE_SIZE);
			map.put("pagesize", WebContextArguments.PAGE_SIZE);
		}else{
			map.put("pagenum", WebContextArguments.ZERO);
			map.put("pagesize", WebContextArguments.PAGE_SIZE);
		}
		List<ApMessage> apMessageList = apMessageService.highranksearch(map);
		dispose(apMessageList);
		String json = JSONArray.fromObject(apMessageList).toString();
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
	//用户登陆省市地区初始化
	@ResponseBody
	@RequestMapping(value="/apmController!init")
	public List init(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Object pcodeobj = ((Account)req.getSession().getAttribute("user")).getPcode();
		List codeList = new ArrayList();
		String pcode = pcodeobj.toString();
		Map map = new HashMap();
		codeList.add(pcode);
		map.put("codeList",codeList);
		List list = apMessageService.initProvince(map);
		String json = JSONArray.fromObject(list).toString();
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
		
		return null;
	
	
	}
	//管理员登陆省初始化(只查询默认管理省)
	@ResponseBody
	@RequestMapping(value="/apmController!initProvince")
	public List initProvince(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Object pcodeobj = ((Account)req.getSession().getAttribute("user")).getPcode();
		List codeList = new ArrayList();
		String pcode = pcodeobj.toString();
		Map map = new HashMap();
		codeList.add(pcode);
		map.put("codeList",codeList);
		List list = apMessageService.initProvince(map);
		String json = JSONArray.fromObject(list).toString();
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
		return null;
	}
	
	//管理员登陆省初始化(只查询查询他管辖的所有省)
	@ResponseBody
	@RequestMapping(value="/apmController!initProvince2")
	public List initProvince2(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		List<AccountDistrictRel> positions = ((Account)req.getSession().getAttribute("user")).getPositions();
		Map map = new HashMap();
		List codeList = new ArrayList();
		Iterator<AccountDistrictRel> it = positions.iterator();
		while(it.hasNext()){
			AccountDistrictRel obj = it.next();
			String code = obj.getCode();
			codeList.add(code);
		}
		map.put("codeList", codeList);
		List list = apMessageService.initProvince(map);
		String json = JSONArray.fromObject(list).toString();
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
		return null;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/apmController!findCityByCode")
	public List findCtiyByCode(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		 Map map = new HashMap();
		 List codelist = new ArrayList();
		 String code = req.getParameter("code"); //130000,140000
		 String[] split = code.split(",");
		 for(String a : split){
			 codelist.add(a);
		 }
		 map.put("codelist", codelist);
		List list = apMessageService.findCtiyByCode(map);
		
		String json = JSONArray.fromObject(list).toString();
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
		
		return null;
	
	
	}
	@ResponseBody
	@RequestMapping(value="/apmController!findDistrictByCode")
	public List findDistrictByCode(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		 Map map = new HashMap();
		 List codelist = new ArrayList();
		 String code = req.getParameter("code"); //130000,140000
		 String[] split = code.split(",");
		 for(String a : split){
			 codelist.add(a);
		 }
		 map.put("codelist", codelist);
		List list = apMessageService.findDistrictByCode(map);
		
		String json = JSONArray.fromObject(list).toString();
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
		
		return null;
	}
	
	
	
	/**
	 * 远程控制数据回显
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!ap_TabShow")
	public List<String> ap_TabShow(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		//清除上次选择地区数据库
		DbContextHolder.clearDbType();
		
		Map<String,String> map = new HashMap<String,String>();
		String apid = req.getParameter("$id");
		map.put("apid", apid); //APID
		
		List<String> portalList = apMessageService.portalShow(map);
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		map.put("table", "public_ips"); //ip白名单
		map.put("str", "publicip"); //ip白名单
		List<String> whitelistList = apMessageService.whitelistShow(map); //ip白名单
		
		map.put("table", "trusted_macs"); //mac白名单
		map.put("str", "mac"); //ip白名单
		List<String> whitelistList_mac = apMessageService.whitelistShow(map); //mac白名单
		
		List<String> setProtocolList = apMessageService.setProtocolShow(map);
		
		
		
		Map<String,List<String>> resultMap = new HashMap<String,List<String>>();
		resultMap.put("setProtocolList", setProtocolList);
		resultMap.put("whitelistList", whitelistList);
		resultMap.put("whitelistList_mac", whitelistList_mac);
		resultMap.put("portalList", portalList);
		
		String msg = JSONArray.fromObject(resultMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DbContextHolder.clearDbType(); //线程使用完成需清理连接集合
			if(null != out){
				out.close();
			}
		}
		return null;
	}
	
	
	/**
	 * 当前认证页面和当前欢迎页面为空的情况下，显示当前登录用户管辖区域内的Portal名称
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!portal_TF")
	public List<String> portal_TF(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		Map<String,String> map = new HashMap<String,String>();
		Account account = (Account) req.getSession().getAttribute("user");
		map.put("userid",account.getId()+""); //配置创建人
		
		List<String> portal_TFList = apMessageService.portal_TF(map);
		String msg = JSONArray.fromObject(portal_TFList).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		return null;
	}
	
	
	/**
	 * 协议设置
	 * @param req
	 * @param rep
	 *  wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!saveSetProtocol")
	public List saveSetProtocol(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		Map<String,Object> map = new HashMap<String,Object>();
		String heartbeat = req.getParameter("heartbeat");
		String authenticate = req.getParameter("authenticate");
		String offline_judge = req.getParameter("offline_judge");
		String visitor_num = req.getParameter("visitor_num");
		String apid = req.getParameter("$id");
		String mac = req.getParameter("$mac");
		
		//map.put("uuid", uuid); //主键已经设置自动增长
		map.put("authenticate", authenticate);
		map.put("offline_judge", offline_judge);
		map.put("heartbeat", heartbeat);
		map.put("visitor_num", visitor_num);
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		
		map.put("apid", apid); //APID
		map.put("mac", mac); //APID
		Account account = (Account) req.getSession().getAttribute("user");
		map.put("userid",account.getId()+""); //配置创建人
		
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		String address = apMessageService.queryApAddress(map);
		map.put("code", address); //区域code
		
		String apMerchant = apMessageService.queryApMerchant(map);
		map.put("merchant_name", apMerchant); //商户名称
		
		map.put("type", "agreement");
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		
		map.put("runtime","1");  //执行次数
		
		DbContextHolder.clearDbType(); //连接清除
		
		apMessageService.insertProtocol_set_log(map);
		Map<String,String>codeMap = new HashMap<String,String>();
		if("200".endsWith(code)){
			codeMap.put("code", "执行成功!");
		}else {
			codeMap.put("code", "执行失败!");
		}
		String msg = JSONArray.fromObject(codeMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		return null;
	}
	
	/**
	 * 协议设置
	 * @param req
	 * @param rep
	 *  wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!saveAuthInterval")
	public List saveAuthInterval(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		String authInterval = req.getParameter("authinterval");

		String apid = req.getParameter("$id");
		String mac = req.getParameter("$mac");
		
		//map.put("uuid", uuid); //主键已经设置自动增长
		map.put("authinterval", authInterval);

		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		
		map.put("apid", apid); //APID
		map.put("mac", mac); //APID
		Account account = (Account) req.getSession().getAttribute("user");
		map.put("userid",account.getId()+""); //配置创建人
		
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		String address = apMessageService.queryApAddress(map);
		map.put("code", address); //区域code
		
		String apMerchant = apMessageService.queryApMerchant(map);
		map.put("merchant_name", apMerchant); //商户名称
		
		map.put("type", "authInterval");
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		
		map.put("runtime","1");  //执行次数
		
		DbContextHolder.clearDbType(); //连接清除
		
		apMessageService.insertProtocol_set_log(map);
		Map<String,String>codeMap = new HashMap<String,String>();
		if("200".endsWith(code)){
			codeMap.put("code", "执行成功!");
		}else {
			codeMap.put("code", "执行失败!");
		}
		String msg = JSONArray.fromObject(codeMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		return null;
	}
	/**
	 * 白名单
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!saveWhitelist")
	public List saveInternetLimit(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		
		Map<String,Object> map = new HashMap<String,Object>();
		String whitelist_ip = req.getParameter("whitelist_ip");
		whitelist_ip.trim();
		String replaceAll = whitelist_ip.replaceAll("\n","");
		String replaceAll2 = replaceAll.replaceAll("\r","");
		String apid = req.getParameter("$id");
		String mac = req.getParameter("$mac");
		map.put("whitelist_ip", replaceAll2);
		map.put("apid", apid); //APID
		map.put("mac", mac); //APID
		Account account = (Account) req.getSession().getAttribute("user");
		map.put("userid",account.getId()+""); //配置创建人
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		String flag = req.getParameter("flag");
		if("MAC".equals(flag)){
			map.put("type", "whitemaclist"); //mac白名单 ,存日志表
		}else if("IP".equals(flag)){
			map.put("type", "whitelist"); //ip白名单,存日志表
		}
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		String address = apMessageService.queryApAddress(map);
		map.put("code", address); //区域code
		
		String apMerchant = apMessageService.queryApMerchant(map);
		map.put("merchant_name", apMerchant); //商户名称

		
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		map.put("runtime","1");  //执行次数
		
		DbContextHolder.clearDbType(); //连接清除
		apMessageService.insertInternet_limit_log(map);
		
		Map<String,String>codeMap = new HashMap<String,String>();
		if("200".endsWith(code)){
			codeMap.put("code", "执行成功!");
		}else {
			codeMap.put("code", "执行失败!");
		}
		String msg = JSONArray.fromObject(codeMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		
		
		return null;
	}
	
	
	
	/**
	 * 远程升级、远程控制
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!saveUpgrade")
	public List saveUpgrade(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Map<String,Object> map = new HashMap<String,Object>();
		Account account = (Account) req.getSession().getAttribute("user");
		Map<String,String>codeMap = new HashMap<String,String>();
		String cmd_flag = req.getParameter("cmd_flag");
		//远程升级
 if(cmd_flag==null){
		String taskname = req.getParameter("taskname");
		String execute_time = req.getParameter("execute_time");
		String apid = req.getParameter("$id");
		String mac = req.getParameter("$mac");
		map.put("taskname", taskname);
		map.put("execute_time",execute_time); //计划执行时间
		map.put("set_time", NowStringUtil.getDate());
		map.put("apid", apid); //APID
		map.put("mac", mac); //APID
		map.put("userid",account.getId()+""); //配置创建人
		map.put("runtime","0");
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		String address = apMessageService.queryApAddress(map);
		map.put("code", address); //区域code
		
		String apMerchant = apMessageService.queryApMerchant(map);
		map.put("merchant_name", apMerchant); //商户名称
		
		DbContextHolder.clearDbType(); //连接清除
		apMessageService.insertUpgrade_ctrl(map);
		codeMap.put("code", "执行成功!");
		}else{
  //远程控制.认证设置 
			map.put("taskname", req.getParameter("taskname"));
			map.put("cmd_flag",cmd_flag);
			map.put("set_time",NowStringUtil.getDate()); 
			map.put("execute_time",NowStringUtil.getDate()); 
			map.put("apid", req.getParameter("$id")); //APID
			map.put("mac", req.getParameter("$mac")); //APmac
			map.put("userid",account.getId()+""); //配置创建人
			String ip=commonDao.queryIpByMac(map);
			map.put("ip", ip);
			if("7".endsWith(cmd_flag) || "8".endsWith(cmd_flag)){
				map.put("type", "auth_type");
			}
			Account acco = (Account) req.getSession().getAttribute("user");
			String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
			DbContextHolder.setDbType(dataSourceName); //切库
			
			String address = apMessageService.queryApAddress(map);
			map.put("code", address); //区域code
			
			String apMerchant = apMessageService.queryApMerchant(map);
			map.put("merchant_name", apMerchant); //商户名称
			
		
			String callback = RemoteCallUtil.remoteCall(map);
			//调用接口，返回结果成功或者失败
			String code = callback.substring(19, 22);
			map.put("set_result",code + ":"
					+ callback.substring(35, callback.length() - 30)); //返回结果
			map.put("runtime","1");  //执行次数
			
			DbContextHolder.clearDbType(); //连接清除
			  apMessageService.insertUpgrade_ctrl_log(map);
			  if("200".endsWith(code)){
					codeMap.put("code", "执行成功!");
				}else {
					codeMap.put("code", "执行失败!");
				}
		}
		String msg = JSONArray.fromObject(codeMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		
		return null;
	}
	
	
	
	/**
	 * Portal设置
	 * @param req
	 * wanghp
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!savePortal")
	public List savePortal(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		Map<String,Object> map = new HashMap<String,Object>();
		String portalidName = req.getParameter("portalidName");
		String redirect_url = req.getParameter("redirect_url");
		String set_time = req.getParameter("set_time");
		String portal_url = req.getParameter("portal_url");
		String apid = req.getParameter("$id");
		String mac = req.getParameter("$mac");
		String[] split = portalidName.split(",");
		map.put("portalid", split[0]);
		map.put("portalname", split[1]);
		map.put("redirect_url", redirect_url);
		map.put("portal_url", portal_url);
		map.put("execute_time",set_time); 
		map.put("apid", apid); //APID
		map.put("mac", mac); //APID
		map.put("runtime","0");
		Account account = (Account) req.getSession().getAttribute("user");
		map.put("userid",account.getId()+""); //配置创建人
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		
		Account acco = (Account) req.getSession().getAttribute("user");
		String dataSourceName = DbContextHolder.getDataSourceName(acco.getPcode());
		DbContextHolder.setDbType(dataSourceName); //切库
		
		String address = apMessageService.queryApAddress(map);
		map.put("code", address); //区域code
		
		String apMerchant = apMessageService.queryApMerchant(map);
		map.put("merchant_name", apMerchant); //商户名称

		
		DbContextHolder.clearDbType(); //连接清除
		apMessageService.insertPortal_set(map);
       	Map<String,String>codeMap = new HashMap<String,String>();
       	codeMap.put("code", "执行成功!");
		String msg = JSONArray.fromObject(codeMap).toString();
		PrintWriter out = null;
		try {
			out = rep.getWriter();
			out.write(msg);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(null != out){
				out.close();
			}
		}
		DbContextHolder.clearDbType(); //连接清除
		
		return null;
	}
	
	/**
	 * 查询AP配置信息
	 * 
	 * @throws ParseException
	 * */
	@RequestMapping(value = "/apmController!queryApConfig")
	public ModelAndView queryAllApConfig(HttpServletRequest req,HttpServletResponse rep,
			ApMessage apMessage) throws ParseException {
		// 从Session中获取userid
		Account user = (Account) req.getSession().getAttribute("user");
		// 每个创建人只能看到自己设置的日志信息管理员可浏览全部
		Map params = new HashMap();
		if(!(user.getId()==1))
			params.put("userid", user.getId());
		// 获取mac是否为空用于简单mac搜索
		String mac = req.getParameter("mac");
		if (!"".equals(mac) && mac	 != null) {
			params.put("mac", mac);
		}
		boolean bcodefind=false;
		String code=req.getParameter("code");
		if ("".equals(code) || code == null){
			Object pcode = user.getPcode();
			if(pcode!=null){
				code = pcode.toString().substring(0, 2);
			}
		}
		else{
			bcodefind=true;
		}
		
		if (!"".equals(code) && code != null) {
			params.put("code", code.substring(0, 2));
		}
		// 查询portal
		params.put("tablename", "portal_set_log");
		List portalList = apMessageService.queryAllApconfig(params);
		// 查询protocol
		params.put("tablename", "protocol_set_log");
		List portocolList = apMessageService.queryAllApconfig(params);
		// 查询internet_limit_log
		params.put("tablename", "internet_limit_log");
		List internetLimitList = apMessageService.queryAllApconfig(params);
		// 查询upgrade_ctrl_log
		params.put("tablename", "upgrade_ctrl_log");
		List upgradeCtrlLogList = apMessageService.queryAllApconfig(params);
		// 将各日志表信息存储到logList
		List logList = new ArrayList();
		logList = getLogList(portalList, logList, "Portal设置");
		logList = getLogList(portocolList, logList, "协议设置");
		logList = getLogList(internetLimitList, logList, "白名单");
		logList = getLogList(upgradeCtrlLogList, logList, "cmd_flag");
		// 利用集合工具类自己编写一个比较器将loglist中按设置时间排序
		Collections.sort(logList, new DateComparator());
		//如果是code查询则返回json
		if (bcodefind) {
			String json = JSONArray.fromObject(logList).toString();
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
			return null;
		}
		ModelAndView mv = new ModelAndView("/source/page/ap/ap_config.jsp");
		mv.addObject("logList", logList);
		return mv;
	}

	/**查询唯一日志*/
	@RequestMapping(value="/apmController!queryApConfig.do",method=RequestMethod.POST)
	@ResponseBody
	public String queryApConfig(HttpServletRequest req){
		//获取类别和id
		String type=req.getParameter("type");
		String id=req.getParameter("id");
		List resultList=new ArrayList();
		Map params=new HashMap();
		params.put("id", id);
		params.put("type", type);
		Account user = (Account) req.getSession().getAttribute("user");
		String code=req.getParameter("code");
		if ("".equals(code) || code == null){
			Object pcode = user.getPcode();
			if(pcode!=null){
				code = pcode.toString().substring(0, 2);
			}
		}
		
		if (!"".equals(code) && code != null) {
			params.put("code", code.substring(0, 2));
		}
		//查询4种
		if("Portal设置".equals(type)){
			params.put("tablename", "portal_set_log");
			resultList=apMessageService.queryAllApconfig(params);
			resultList.add("portal_set_log");
		}else if("协议设置".equals(type)){
			params.put("tablename", "protocol_set_log");
			resultList=apMessageService.queryAllApconfig(params);
			resultList.add("protocol_set_log");
		}else if(type.endsWith("白名单")){
			params.put("tablename", "internet_limit_log");
			resultList=apMessageService.queryAllApconfig(params);
			resultList.add("internet_limit_log");
		}else{
			params.put("tablename","upgrade_ctrl_log");
			resultList=apMessageService.queryAllApconfig(params);
			resultList.add("upgrade_ctrl_log");
		}
		JSONArray arr = new JSONArray();
		arr.addAll(resultList);
		return arr.toString();
	}
	/**
	 * 拼装日志list
	 * 
	 * @param list
	 * @param logList
	 * @return
	 */
	public List getLogList(List list, List logList, String type) {
		for (int i = 0; i < list.size(); i++) {
			HashMap javabean = (HashMap) list.get(i);
			if (javabean.get(type) != null) {
				int cmd = (Integer) javabean.get(type);
				String cmdFlag = "";
				switch (cmd) {
				case 1:
					cmdFlag = "重启设备";
					break;
				case 2:
					cmdFlag = "免认证";
					break;
				case 3:
					cmdFlag = "关闭进程";
					break;
				case 4:
					cmdFlag = "进程重启";
					break;
				case 5:
					cmdFlag = "远程升级";
					break;
				case 6:
					cmdFlag = "文件更新";
					break;
				case 7:
					cmdFlag = "一次一密";
					break;
				case 8:
					cmdFlag = "一键登录";
					break;
				}
				javabean.put("type", cmdFlag);
			} else {
				javabean.put("type", type);
			}
			if("白名单".equals(type)){
				if("whitemaclist".equals(javabean.get("flag"))){
					javabean.put("type", "mac"+type);
				}
			}
			logList.add(javabean);
		}
		return logList;
	}
	/**
	 * 重新执行协议设置
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!reExcuteProtocal")
	public String reExecuteProtocal(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Map<String,Object> map = new HashMap<String,Object>();
		//获取页面数据
		String heartbeat = req.getParameter("heartbeat");
		String authenticate = req.getParameter("authenticate");
		String offline_judge = req.getParameter("offline_judge");
		String visitor_num = req.getParameter("visitor_num");
		String taskid = req.getParameter("taskid");
		map.put("authenticate", authenticate);
		map.put("offline_judge", offline_judge);
		map.put("heartbeat", heartbeat);
		map.put("visitor_num", visitor_num);
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		map.put("taskid",taskid); 
		map.put("type","agreement");
		String mac=req.getParameter("$mac");
		map.put("mac", mac);
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		apMessageService.updateProtocol_set_log(map);
		return "已提交";
	}
	/**
	 * 重新执行Portal
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!reExcutePortal")
	public String reExecutePortal(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Map<String,Object> map = new HashMap<String,Object>();
		//获取页面数据
		String portalname = req.getParameter("portal_name");
		String taskid = req.getParameter("taskid");
		map.put("type","portal_set");
		map.put("portalname", portalname);
		map.put("taskid",taskid); 
		map.put("execute_time",NowStringUtil.getDate()); 
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		String mac=req.getParameter("$mac");
		map.put("mac", mac);
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		apMessageService.updatePortal_set_log(map);
		return "已提交";
	}
	
	/**
	 * 重新执行白名单
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!reExecuteInternetLimit")
	public String reExecuteInternetLimit(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Map<String,Object> map = new HashMap<String,Object>();
		//名单IP处理
		String whitelist_ip = req.getParameter("whitelist_ip");
		whitelist_ip.trim();
		String replaceAll = whitelist_ip.replaceAll("\n","");
		String replaceAll2 = replaceAll.replaceAll("\r","");
		String taskid = req.getParameter("taskid");
		String mac=req.getParameter("$mac");
		map.put("mac", mac);
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		map.put("type","whitelist");
		map.put("whitelist_ip", replaceAll2);
		map.put("taskid",taskid); 
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		apMessageService.updateInternet_limit_log(map);
		return "已提交";
	}
	
	/**
	 * 重新执行mac白名单
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!reExecuteInternetLimitMac")
	public String reExecuteInternetLimitMac(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		Map<String,Object> map = new HashMap<String,Object>();
		//名单IP处理
		String whitelist_ip = req.getParameter("whitelist_ip");
		whitelist_ip.trim();
		String replaceAll = whitelist_ip.replaceAll("\n","");
		String replaceAll2 = replaceAll.replaceAll("\r","");
		String taskid = req.getParameter("taskid");
		String mac=req.getParameter("$mac");
		map.put("mac", mac);
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		map.put("type","whitemaclist");
		map.put("whitelist_ip", replaceAll2);
		map.put("taskid",taskid); 
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		apMessageService.updateInternet_limit_log(map);
		return "已提交";
	}
	/**
	 * 重新执行远程控制
	 * */
	@ResponseBody
	@RequestMapping(value="/apmController!reExecuteUpgrade")
	public String reExecuteUpgrade(HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("text/html;charset=utf-8");
		
		Map<String,Object> map = new HashMap<String,Object>();
		String taskid = req.getParameter("taskid");
		String cmd_flag = req.getParameter("cmd_flag");
		if("278".contains(cmd_flag)){
			map.put("type", "auth_type");
		}
		String mac=req.getParameter("$mac");
		map.put("mac", mac);
		String ip=commonDao.queryIpByMac(map);
		map.put("ip", ip);
		map.put("cmd_flag", cmd_flag);
		map.put("taskid",taskid); 
		map.put("set_time",NowStringUtil.getDate()); //系统当前时间
		map.put("execute_time",NowStringUtil.getDate()); 
		//接口调度
		String callback = RemoteCallUtil.remoteCall(map);
		//调用接口，返回结果成功或者失败
		String code = callback.substring(19, 22);
		map.put("set_result",code + ":"
				+ callback.substring(35, callback.length() - 30)); //返回结果
		
		apMessageService.updateUpgrade(map);
		return "已提交";
	}
	
}
