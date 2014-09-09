package com.sinosoft.account.controller;

import java.io.UnsupportedEncodingException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.account.bean.AccountDistrictRel;
import com.sinosoft.account.bean.GrowthTotal;
import com.sinosoft.account.dao.GrowthTotalDao;
import com.sinosoft.account.service.AccountService;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.service.PositionService;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.dataSource.DbContextHolder;
import com.sinosoft.util.WebContextArguments;
/**
 * 用户账户设置管理控制层
 * @author 于永波
 * @since  2014-5-29
 */
@Controller
public class AccountController extends BaseController{
	@Autowired
	private AccountService accountService;
	@Autowired
	private PositionService positionService;
	@Autowired
	private GrowthTotalDao totalDao;
	/**
	 * 用户管理初始化界面
	 * @param req
	 * @return
	 */
	@RequestMapping(value="account!initAccountManage.do")
	public ModelAndView initAccountManage(HttpServletRequest req){
		DbContextHolder.clearDbType();
		Account acc = (Account) req.getSession().getAttribute("user");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("parent_userid", acc.getId());
		List<Account> accounts = accountService.getAccount(args);
		for (Account account : accounts) {
			//查询用户管理域
			queryAccountDistrict(account);
		}
		ModelAndView view = new ModelAndView("source/page/account/admins.jsp");
		view.addObject("account", accounts);
		Account account = (Account) req.getSession().getAttribute("user");
		if(account != null){
			Integer level = account.getLevel();
			if(level == null && "admin".equals(account.getName())){
				view.addObject("userLevel", -1);
			}else{
				view.addObject("userLevel", level);
			}
		}
		//查询所有的用户
		return view;
	}
	/**
	 * 查询用户的管理域
	 * @param account 用户
	 */
	private void queryAccountDistrict(Account account) {
		DbContextHolder.clearDbType();
		List<AccountDistrictRel> accDistrict = accountService.queryAccountDistrictRel(account);
		for (AccountDistrictRel adr : accDistrict) {
			List<String> list = Arrays.asList(WebContextArguments.Directly_City);
			if(adr != null && list.contains(adr.getCode())){
				adr.setCode(adr.getCode().substring(0, 2)+"0000");
			}
		}
		account.setPositions(accDistrict);
	}
	/**
	 * 保存用户
	 * @param req
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="/account!saveAccount.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject saveAccount(HttpServletRequest req) throws UnsupportedEncodingException{
		DbContextHolder.clearDbType();
		String username = req.getParameter("username");
		String password_one = req.getParameter("password_one");
		String real_name = req.getParameter("real_name");
		String contact = req.getParameter("contact");
		String district = req.getParameter("district");
		JSONObject jo = new JSONObject();
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("name", username);
		//检查用户是否存在
		List<Account> account2 = accountService.getAccount(args);
		if(account2 != null && account2.size() > 0 && account2.get(0) != null){
			return jo.element("success", "用户已经存在");
		}
		Account ac = (Account) req.getSession().getAttribute("user");
		//保存用户
		Account account = new Account();
		account.setName(username);
		account.setPassword(password_one);
		account.setReal_name(real_name);
		account.setContact(contact);
		if(ac.getParent_userid() == 0){
			account.setLevel(0);
		}else{
			account.setLevel(ac.getLevel()+1);
		}
		account.setParent_userid(ac.getId());
		account.setCreated_at(new Date(System.currentTimeMillis()));
		account.setUpdated_at(new Date(System.currentTimeMillis()));
		Account acc = accountService.saveAccount(account);
		//保存用户区域关系表
		String[] split = district.split(",");
		for (int i = 0; i < split.length; i++) {
			String string = split[i];
			if(string != null && !"".equals(string.trim())){
				String[] split2 = string.split(":");
				if(split2 != null){
					List<String> list = Arrays.asList(WebContextArguments.Directly_Province);
					if(list.contains(split2[0])){
						//查询直辖市下面的所有区
						HashMap<String, String> map = new HashMap<String, String>();
						map.put("parent_code", split2[0]);
						List<Position> treeDataByCode = positionService.getAddrTree(map);
						for (Position position : treeDataByCode) {
							if(position != null){
								AccountDistrictRel districtRel = new AccountDistrictRel();
								districtRel.setCode(position.getId());
								districtRel.setParent_code(position.getpId());
								districtRel.setLevel(Integer.parseInt(split2[2].toString().trim())+1);
								districtRel.setName(split2[3]);
								districtRel.setUserid(acc.getId());
								accountService.saveAccountDistrict(districtRel);
							}
						}
					}else{
						AccountDistrictRel districtRel = new AccountDistrictRel();
						districtRel.setCode(split2[0]);
						districtRel.setParent_code(split2[1]);
						districtRel.setLevel(Integer.parseInt(split2[2].toString().trim())+1);
						districtRel.setName(split2[3]);
						districtRel.setUserid(acc.getId());
						accountService.saveAccountDistrict(districtRel);
					}
				}
			}
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		jo.element("created_at", sdf.format(acc.getCreated_at()));
		jo.element("updated_at", sdf.format(acc.getUpdated_at()));
		jo.element("id", acc.getId());
		return jo.element("success", "success");
	}
	/**更新用户*/
	@RequestMapping(value="/account!updateAccount.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject updateAccount(HttpServletRequest req){
		DbContextHolder.clearDbType();
		JSONObject result = new JSONObject();
		String username = req.getParameter("username");
		String real_name = req.getParameter("real_name");
		String contact = req.getParameter("contact");
		String district = req.getParameter("district");
		String id = req.getParameter("accountId");
		String password_one = req.getParameter("password_one");
		if(id != null&&!"".equals(id.trim())){
			HashMap<String, Object> arguments = new HashMap<String, Object>();
			arguments.put("name", username);
			arguments.put("real_name", real_name);
			arguments.put("password", password_one);
			arguments.put("contact", contact);
			arguments.put("id", id);
			arguments.put("updated_at", new java.util.Date());
			accountService.updateAccount(arguments);
			//先删除已有的区域
			arguments = new HashMap<String, Object>();
			arguments.put("userid", id);
			if(district != null){
				accountService.deleteAccountDistrict(arguments);
				//将新的区域插入到表中
				String[] split = district.split(",");
				for (int i = 0; i < split.length; i++) {
					String string = split[i];
					if(string != null && !"".equals(string.trim())){
						String[] split2 = string.split(":");
						if(split2 != null){
							AccountDistrictRel districtRel = new AccountDistrictRel();
							districtRel.setCode(split2[0]);
							districtRel.setParent_code(split2[1]);
							districtRel.setLevel(Integer.parseInt(split2[2].toString().trim())+1);
							districtRel.setName(split2[3]);
							districtRel.setUserid(Long.parseLong(id));
							accountService.saveAccountDistrict(districtRel);
						}
					}
				}
			}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			result.element("updated_at", sdf.format(new java.util.Date()));
			result.element("success", "success");
			return result;
		}
		result.element("success", "更新失败，用户或不存在!");
		return result;
	}
	
	/**
	 * 登陆检查用户
	 * @param req
	 * @return
	 */
	@RequestMapping(value="/login!checkUser.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject checkUser(HttpServletRequest req){
		DbContextHolder.clearDbType();
		String name = req.getParameter("user.name");
		String pwd = req.getParameter("user.pwd");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("name", name);
		List<Account> accs = accountService.getAccount(args);
		Account account = null;
		if(accs != null && accs.size() > 0){
			account = accs.get(0);
		}
		Account acco = null;
		JSONObject jo = new JSONObject();
		//检查用户是否存在
		if(account == null){
			return jo.element("success", "用户不存在");
		}else{
			//检查账户是否停用
			if(account.getInvalid_flag()!= 0 && account.getInvalid_flag()!=null){
				return jo.element("success", "账户已停用");
			}
			//检查账户是否锁定
			java.util.Date lock_time = account.getLock_time();
			if(lock_time != null && (System.currentTimeMillis()-lock_time.getTime())/(1000*60) <= 30){
				return jo.element("success", "账户已锁定，"+(30-(System.currentTimeMillis()-lock_time.getTime())/(1000*60))+"分钟后解锁");
			}
			args.put("password", pwd);
			accs = accountService.getAccount(args);
			if(accs == null || accs.size() == 0){
				//用户密码错误
				Integer times = (Integer) req.getSession().getAttribute(name);
				if(times != null && times >= 6){
					HashMap<String, Object> argument = new HashMap<String, Object>();
					argument.put("lock_time", new java.util.Date());
					argument.put("id", account.getId());
					accountService.updateAccount(argument);
					return jo.element("success", "输入密码错误超过6次,账户已被锁定30分钟");
				}
				if(times == null){
					req.getSession().setAttribute(name, 1);
				}else{
					req.getSession().setAttribute(name, times+1);
				}
				return jo.element("success", "用户密码错误");
			}
		}
		acco = accs.get(0);
		req.getSession().setAttribute("user", acco);
		List<AccountDistrictRel> userDistrict = accountService.queryAccountDistrictRel(acco);
		acco.setPositions(userDistrict);
		//判断是否是管理员
		if(acco.getParent_userid() == 0){
			List<Position> province = positionService.getProvince(null);
			acco.setPcode(province.get(0).getId());
			acco.setProvinces(province);
		}else{
			List<String> codes = new ArrayList<String>();
			for (AccountDistrictRel rel : userDistrict) {
				if(rel != null && !codes.contains(rel.getCode().substring(0, 2)+"0000")){
					codes.add(rel.getCode().substring(0, 2)+"0000");
				}
			}
			args = new HashMap<String, Object>();
			args.put("codes", codes);
			List<Position> province = positionService.getProvince(args);
			acco.setPcode(province.get(0).getId());
			acco.setProvinces(province);
		}
		return jo.element("success", "success");
	}
	/**
	 * 退出登陆
	 * */
	@RequestMapping(value="/login!outLogin.do",method=RequestMethod.GET)
	public ModelAndView outLogin(HttpServletRequest req){
		ModelAndView view = new ModelAndView("login.jsp");
		req.getSession().removeAttribute("user");
		return view;
	}
	/**账户停用、启用*/
	@RequestMapping(value="account!invalidAccount.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject invalidAccount(HttpServletRequest req){
		DbContextHolder.clearDbType();
		JSONObject res = new JSONObject();
		String id = req.getParameter("id");
		if(id == null || "".equals(id.trim())){
			//账户不存在
			res.element("success", "用户不存在");
			return res;
		}else{
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("id", id);
			List<Account> acc = accountService.getAccount(args);
			if(acc == null||acc.size() == 0){
				res.element("success", "用户不存在");
				return res;
			}
		}
		String invalid_flag = req.getParameter("invalid_flag");
		if(invalid_flag != null && "0".equals(invalid_flag.trim())){
			invalid_flag = "1";
		}else{
			invalid_flag = "0";
		}
		Map<String, Object> arguments = new HashMap<String, Object>();
		arguments.put("id", id);
		arguments.put("invalid_flag", invalid_flag);
		accountService.updateAccount(arguments);
		res.element("success", "success");
		return res;
	}
	/**查询用户*/
	@RequestMapping(value="account!queryAccount.do",method=RequestMethod.GET)
	public ModelAndView queryAccount(HttpServletRequest req){
		DbContextHolder.clearDbType();
		Account acc = (Account) req.getSession().getAttribute("user");
		String search_text = req.getParameter("search_text");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("parent_userid", acc.getId());
		args.put("name", search_text);
		List<Account> accounts = accountService.getAccount(args);
		ModelAndView view = new ModelAndView("source/page/account/queryResult.jsp");
		view.addObject("account", accounts);
		return view;
	}
	/**账户设置初始化界面*/
	@RequestMapping(value="account!initAccountSetting.do",method=RequestMethod.GET)
	public ModelAndView accountSetting(HttpServletRequest req){
		ModelAndView view = new ModelAndView("source/page/account/admins_edit.jsp");
		Account acc = (Account) req.getSession().getAttribute("user");
		view.addObject("account", acc);
		return view;
	}
	/**修改密码*/
	@RequestMapping(value="account!modifyPassword.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject modifyPassword(HttpServletRequest req){
		DbContextHolder.clearDbType();
		String new_password = req.getParameter("new_password");
		String userid = req.getParameter("userid");
		//先查询用户
		JSONObject res = new JSONObject();
		HashMap<String, Object> arguments = new HashMap<String, Object>();
		arguments.put("id", userid);
		arguments.put("password", new_password);
		accountService.updateAccount(arguments);
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("id", userid);
		List<Account> accs = accountService.getAccount(args);
		if(accs != null && accs.get(0) != null){
			req.getSession().setAttribute("user", accs.get(0));
		}
		res.element("success", "success");
		return res;
	}
	
	/**
	 * 主页
	 * @param request
	 * @return
	 */
	@RequestMapping(value="login!index.do",method=RequestMethod.GET)
	public ModelAndView index(HttpServletRequest request){
		Account account = (Account) request.getSession().getAttribute("user");
		if(account == null){
			return new ModelAndView("login.jsp");
		}
		//将当前用户的
		ModelAndView view = new ModelAndView("source/page/index.jsp");
		view.addObject("provinces", account.getProvinces());
		return view;
	}
	
	/**
	 * 首页显示
	 * @param request
	 * @return
	 */
	@RequestMapping(value="index!homePage.do",method=RequestMethod.GET)
	public ModelAndView homePage(HttpServletRequest request){
		DbContextHolder.clearDbType();
		//得到用户
		Account account = (Account) request.getSession().getAttribute("user");
		List<GrowthTotal> growthTotals = new ArrayList<GrowthTotal>();
		//AP数
		long apTotal = 0l;
		//在线数
		long onLineNum = 0l;
		//客户数
		long customerNum = 0l;
		if(account.getParent_userid() == 0){
			growthTotals = totalDao.queryGrowthTotal(new HashMap<String, Object>());
			for (int i = 0;i<growthTotals.size();i++) {
				GrowthTotal growthTotal = growthTotals.get(i);
				if(growthTotal != null && growthTotal.getLevel() != 0){
					growthTotals.remove(growthTotal);
					i--;
				}else{
					apTotal+=growthTotal.getAp_total();
					onLineNum+=growthTotal.getOnline_num();
					customerNum+=growthTotal.getCustomer_num();
				}
			}
		}else{
			List<AccountDistrictRel> adr = accountService.queryAccountDistrictRel(account);
			for (AccountDistrictRel ar : adr) {
				if(ar != null){
					//根据Code和省代码查数据
					HashMap<String, Object> hashMap = new HashMap<String, Object>();
					hashMap.put("code", ar.getCode());
					hashMap.put("parent_code", ar.getParent_code());
					List<GrowthTotal> gto = totalDao.queryGrowthTotal(hashMap);
					if(gto != null && gto.size() > 0){
						growthTotals.addAll(gto);
					}
				}
				if(ar != null){
					//根据父Code查数据
					HashMap<String, Object> hashMap = new HashMap<String, Object>();
					hashMap.put("parent_code", ar.getCode());
					List<GrowthTotal> gto = totalDao.queryGrowthTotal(hashMap);
					if(gto != null && gto.size() > 0){
						growthTotals.addAll(gto);
					}
				}
			}
			for (GrowthTotal growthTotal : growthTotals) {
				if(growthTotal != null){
					apTotal+=growthTotal.getAp_total();
					onLineNum+=growthTotal.getOnline_num();
					customerNum+=growthTotal.getCustomer_num();
				}
			}
		}
		for (int i = 0; i < growthTotals.size(); i++) {
			GrowthTotal total = growthTotals.get(i);
			int code = Integer.parseInt(total.getCode());
			for (int j = i; j < growthTotals.size(); j++) {
				GrowthTotal total2 = growthTotals.get(j);
				if(total2 != null){
					int code2 = Integer.parseInt(total2.getCode());
					if(code2 < code){
						growthTotals.set(i, total2);
						growthTotals.set(j, total);
					}
				}
				
			}
		}
		ModelAndView view = new ModelAndView("source/page/shouye.jsp");
		//在线比
		int onLineRes = apTotal == 0l ? 0 : (int) ((onLineNum*100)/apTotal);
		view.addObject("apTotal",apTotal );
		view.addObject("customerNum",customerNum);
		view.addObject("onLineRes",onLineRes);
		view.addObject("adrs",growthTotals);
		return view;
	}
	
}
