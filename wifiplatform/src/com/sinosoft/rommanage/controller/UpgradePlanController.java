package com.sinosoft.rommanage.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
import com.sinosoft.dataSource.DbContextHolder;
import com.sinosoft.rommanage.bean.UpgradePlan;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.service.UpgradePlanService;
import com.sinosoft.util.WebContextArguments;
/**
 * 升级计划Controller
 * @Author 于永波
 * @since  2014-6-10 
 */
@Controller
public class UpgradePlanController extends BaseController{
	
	@Autowired
	private UpgradePlanService planService;
	/**
	 * 界面初始化
	 * @param req
	 * @return
	 */
	@RequestMapping(value="upgrade!upGradePlan.do",method=RequestMethod.GET)
	public ModelAndView init(HttpServletRequest req){
		DbContextHolder.clearDbType();
		ModelAndView view = new ModelAndView("/source/page/rom/upgrade_plan.jsp");
		List<UpgradePlan> upGradePlans = new ArrayList<UpgradePlan>();
		Account acc = (Account) req.getSession().getAttribute("user");
		HashMap<String, Object> args = new HashMap<String, Object>();
		//查本地
		if(acc.getParent_userid() != 0){
			args.put("userid", acc.getId());
		}
		args.put("pageNum", WebContextArguments.ZERO);
		args.put("pageSize", WebContextArguments.PAGE_SIZE);
		upGradePlans = planService.queryAdminUpgrade(args);
		if(acc.getParent_userid() != 0){
			upGradePlans = planService.queryUnAdminUpgrade(args);
		}
		for (UpgradePlan up : upGradePlans) {
			if(up != null && up.getUserid() != null&& up.getUserid() == acc.getId().intValue()){
				up.setIsSelfCreate(1);
			}
		}
		args.put("userid", acc.getId());
		for (UpgradePlan up : upGradePlans) {
			if(up.getUserid() != null){
				args.put("id", up.getId());
				List<UpgradePlanApRel> aprels = planService.queryUpGradePlanApRel(args);
				//解析区域编码，补充省、市、地区名称
				for (UpgradePlanApRel rel : aprels) {
					if(rel != null){
						supplementName(rel);
					}
				}
				up.setPlanApRels(aprels);
			}
		}
		//
		view.addObject("upGradePlans", upGradePlans);
		return view;
	}
	/**
	 * 补充AP的地址名称
	 * @param rel
	 */
	private void supplementName(UpgradePlanApRel rel) {
		String code = rel.getCode();
		if(code != null && !"".equals(code.trim())){
			if(code.matches("[1-9][0-9]{1}[0]{4}")){
				//省
				Position position = WebContextArguments.codeToObject.get(code);
				rel.setPname(position.getName());
			}else if(code.matches("[1-9][0-9][1-9][0-9][0]{2}|[1-9][0-9][0-9][1-9][0]{2}")){
				//市
				Position position = WebContextArguments.codeToObject.get(code);
				String cname = position.getName();
				rel.setCname(cname);
				String pcode = position.getpId();
				if(pcode != null && !"".equals(pcode.trim())){
					String name = WebContextArguments.codeToObject.get(pcode).getName();
					if(cname.equals(name)){
						rel.setCname("");
					}
					rel.setPname(name);
				}
			}else if(code.matches("[0-9]{4}[1-9][0-9]|[0-9]{4}[0-9][1-9]")){
				//区
				Position position = WebContextArguments.codeToObject.get(code);
				rel.setDname(position.getName());
				String ccode = position.getpId();
				if(ccode != null && !"".equals(ccode.trim())){
					Position city = WebContextArguments.codeToObject.get(ccode);
					String cname = city.getName();
					rel.setCname(cname);
					String pcode = city.getpId();
					if(pcode != null && !"".equals(pcode.trim())){
						String name = WebContextArguments.codeToObject.get(pcode).getName();
						if(cname.equals(name)){
							rel.setCname("");
						}
						rel.setPname(name);
					}
				}
			}
		}
	}
	/**点击树节点查询AP的信息*/
	@RequestMapping(value="upgrade!getApMessage.do",method=RequestMethod.GET)
	@ResponseBody
	public String getApMessage(HttpServletRequest req){
		String code = req.getParameter("id");
		List<ApMessage> aps = new ArrayList<ApMessage>();
		if(code != null){
			String pcode = code.trim().substring(0, 2)+"0000";
			String sourceName = DbContextHolder.getDataSourceName(pcode);
			DbContextHolder.setDbType(sourceName);
			Map<String, Object> arguments = new HashMap<String, Object>();
			if(Integer.parseInt(code.trim().substring(4, 6)) > 0){
				//地区
				arguments.put("district", code);
			}else if(Integer.parseInt(code.trim().substring(2, 4)) > 0){
				//市
				arguments.put("city", code);
			}else{
				//省
				arguments.put("province", code);
			}
			aps = planService.queryApMessage(arguments);
			if(aps != null){
				for (ApMessage apMessage : aps) {
					if(apMessage != null){
						apMessage.setPname(WebContextArguments.codeToName.get(apMessage.getProvince()));
						apMessage.setCname(WebContextArguments.codeToName.get(apMessage.getCity()));
						apMessage.setDname(WebContextArguments.codeToName.get(apMessage.getDistrict()));
					}
				}
			}
			DbContextHolder.clearDbType();
		}
		JSONArray object = new JSONArray();
		object.addAll(aps);
		return object.toString();
	}
	/**保存升级计划*/
	@RequestMapping(value="upgrade!saveUpGradePlan.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject saveUpGradePlan(HttpServletRequest req){
		String ap = req.getParameter("ap");
		//插入升级计划
		Integer id = insertUpgradePlan(req);
		if(id != -1){
			//插入关系表
			//解析APS
			String[] aps = ap.split(",");
			for (int i = 0; i < aps.length; i++) {
				if(!"".equals(aps[i])){
					String[] split = aps[i].split(":");
					String apId = split[0];
					String mac = split[1];
					String pcode = split[2];
					if("".equals(apId)){
						continue;
					}
					Map<String, Object> args = new HashMap<String, Object>();
					args.put("id", id);
					String code = "";
					if(!"".equals(pcode)){
						code = pcode.substring(0, 2)+"0000";
					}
					String sourceName = DbContextHolder.getDataSourceName(code);
					DbContextHolder.setDbType(sourceName);
					//根据APID查询所有信息
					args.put("apid", apId);
					List<Map<String, Object>> contacts = planService.queryApContacts(args);
					if(contacts != null && contacts.size() != 0){
						Map<String, Object> map = contacts.get(0);
						String name = map.get("name") != null ?map.get("name").toString():"";
						String apname = map.get("apname") != null ?map.get("apname").toString():"";
						args.put("contacts", name);
						args.put("apname", apname);
					}
					args.put("apid", apId);
					args.put("mac", mac);
					args.put("code", pcode);
					args.put("execute_result", "");
					DbContextHolder.clearDbType();
					planService.insertUpGradePlanApRel(args);
				}
			}
		}
		JSONObject json = new JSONObject();
		json.put("id", id);
		return json;
	}
	
	/**
	 * 插入升级计划
	 * @param req 请求对象
	 * @return 主键ID
	 */
	private Integer insertUpgradePlan(HttpServletRequest req) {
		String plan_name = req.getParameter("plan_name");
		String plan_time = req.getParameter("plan_time");
		Account acc = (Account) req.getSession().getAttribute("user");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("plan_name", plan_name);
		args.put("execute_time", plan_time);
		args.put("create_time", new Date());
		args.put("userid", acc.getId());
		Integer id = planService.insertUpGradePlan(args);
		return id;
	}
	
	/**保存升级计划*/
	@RequestMapping(value="upgrade!saveEditUpGradePlan.do",method=RequestMethod.POST)
	@ResponseBody
	public JSONObject saveEditUpGradePlan(HttpServletRequest req){
		DbContextHolder.clearDbType();
		String ap = req.getParameter("ap");
		//插入升级计划
		String id = updateEditUpGradePlan(req);
		Map<String, Object> args = new HashMap<String, Object>();
		if(id!=null&&!"".equals(id.trim())){
			//先删除原来的
			args.put("id", id);
			planService.deleteUpGradePlanApRel(args);
			//解析APS
			String[] aps = ap.split(",");
			for (int i = 0; i < aps.length; i++) {
				if(!"".equals(aps[i])){
					String[] split = aps[i].split(":");
					String apId = split[0];
					String mac = split[1];
					String pcode = split[2];
					if("".equals(apId)){
						continue;
					}
					args = new HashMap<String, Object>();
					//切库查询AP信息
					String code = "";
					if(!"".equals(pcode)){
						code = pcode.substring(0, 2)+"0000";
					}
					String sourceName = DbContextHolder.getDataSourceName(code);
					DbContextHolder.setDbType(sourceName);
					//根据APID查询所有信息
					args.put("apid", apId);
					List<Map<String, Object>> contacts = planService.queryApContacts(args);
					if(contacts != null && contacts.size() != 0){
						Map<String, Object> map = contacts.get(0);
						String name = map.get("name") != null ?map.get("name").toString():"";
						String apname = map.get("apname") != null ?map.get("apname").toString():"";
						args.put("contacts", name);
						args.put("apname", apname);
					}
					args.put("id", id);
					args.put("mac", mac);
					args.put("code", pcode);
					DbContextHolder.clearDbType();
					planService.insertUpGradePlanApRel(args);
				}
			}
		}
		JSONObject json = new JSONObject();
		json.put("id", id);
		return json;
	}
	/**
	 * 更新升级计划
	 * @param req 请求对象
	 * @return 主键ID
	 */
	private String updateEditUpGradePlan(HttpServletRequest req) {
		String plan_time = req.getParameter("plan_time");
		String id = req.getParameter("id");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("execute_time", plan_time);
		args.put("id", id);
		planService.updateEditUpGradePlan(args);
		return id;
	}
	/**查询到升级计划信息*/
	@RequestMapping(value="upgrade!searchUpgradePlan.do",method=RequestMethod.POST)
	@ResponseBody
	public String searchUpgradePlan(HttpServletRequest req){
		String search_text = req.getParameter("search_text");
		String pageNum = req.getParameter("pageNum");
		String start_time = req.getParameter("start_time");
		String end_time = req.getParameter("end_time");
		Account acc = (Account) req.getSession().getAttribute("user");
		List<UpgradePlan> upGradePlans = new ArrayList<UpgradePlan>();
		HashMap<String, Object> args = new HashMap<String, Object>();
		if(pageNum != null && !"".equals(pageNum)){
			args.put("pageNum", Integer.parseInt(pageNum)*WebContextArguments.PAGE_SIZE);
			args.put("pageSize", WebContextArguments.PAGE_SIZE);
		}else{
			args.put("pageNum", WebContextArguments.ZERO);
			args.put("pageSize", WebContextArguments.PAGE_SIZE);
		}
		if(acc.getParent_userid() != WebContextArguments.ZERO){
			args.put("userid", acc.getId());
		}
		args.put("plan_name", search_text);
		args.put("start_time", start_time);
		args.put("end_time", end_time);
		upGradePlans = planService.queryAdminUpgrade(args);
		if(acc.getParent_userid() != WebContextArguments.ZERO){
			upGradePlans = planService.queryUnAdminUpgrade(args);
		}
		for (UpgradePlan up : upGradePlans) {
			if(up.getUserid() != null&& up.getUserid() == acc.getId().intValue()){
				up.setIsSelfCreate(1);
			}
		}
		for (UpgradePlan up : upGradePlans) {
			if(up.getUserid() != null){
				args.put("id", up.getId());
				List<UpgradePlanApRel> rels = planService.queryUpGradePlanApRel(args);
				for (UpgradePlanApRel rel : rels) {
					supplementName(rel);
				}
				up.setPlanApRels(rels);
			}
		}
		
		return JSONArray.fromObject(upGradePlans).toString();
	}

	/**查询到计划的AP信息*/
	@RequestMapping(value="upgrade!queryUpgradePlanApMessage.do",method=RequestMethod.POST)
	@ResponseBody
	public String queryUpgradePlanApMessage(HttpServletRequest req){
		String id = req.getParameter("id");
		List<ApMessage> aps = new ArrayList<ApMessage>();
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("id", id);
		DbContextHolder.clearDbType();
		List<UpgradePlanApRel> apRels = planService.queryUpGradePlanApRel(args);
		if(apRels != null){
			for (UpgradePlanApRel apRel : apRels) {
				if(apRel != null){
					String province_code = apRel.getCode();
					if(province_code != null && !"".equals(province_code)){
						province_code = province_code.substring(0, 2)+"0000";
					}
					//TODO 根据省编码切库
					String dataSourceName = DbContextHolder.getDataSourceName(province_code);
					DbContextHolder.setDbType(dataSourceName);
					args.put("id", apRel.getApid());
					List<ApMessage> ap = planService.queryApMessage(args);
					for (int i = 0; i < ap.size(); i++) {
						if(ap.get(i)!=null){
							ApMessage apMessage = ap.get(i);
							apMessage.setCreated_at(null);
							apMessage.setPname(WebContextArguments.codeToName.get(apMessage.getProvince()));
							apMessage.setCname(WebContextArguments.codeToName.get(apMessage.getCity()));
							apMessage.setDname(WebContextArguments.codeToName.get(apMessage.getDistrict()));
							aps.add(ap.get(i));
						}
					}
					DbContextHolder.clearDbType();
				}
			}
		}
		DbContextHolder.clearDbType();
		return JSONArray.fromObject(aps).toString();
	}
	/**审核计划*/
	@RequestMapping(value="upgrade!upgradePlanVerify.do",method=RequestMethod.POST)
	@ResponseBody
	public String upgradePlanVerify(HttpServletRequest req){
		String id = req.getParameter("id");
		String check_state = req.getParameter("check_state");
		//解析ID
		//删除计划信息
		HashMap<String, Object> args = new HashMap<String, Object>();
		args.put("id", id);
		args.put("check_state", check_state);
		args.put("check_time", new Date());
		planService.updateEditUpGradePlan(args);
		//删除计划信息与AP关系表
		return "OK";
	}
	/**查询到计划与AP信息的关系表数据*/
	@RequestMapping(value="upgrade!lookApMessage.do",method=RequestMethod.POST)
	@ResponseBody
	public String lookApMessage(HttpServletRequest req){
		String id = req.getParameter("id");
		if(id != null && !"".equals(id)){
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("id", id);
			List<UpgradePlanApRel> rels = planService.queryUpGradePlanApRel(args);
			for (UpgradePlanApRel rel : rels) {
				supplementName(rel);
			}
			return JSONArray.fromObject(rels).toString();
		}
		return "";
	}
	
	/***删除升级计划*/
	@RequestMapping(value="upgrade!deleteUpgradePlan.do",method=RequestMethod.POST)
	@ResponseBody
	public String deleteUpgradePlan(HttpServletRequest req){
		String ids = req.getParameter("id");
		//解析ID
		String[] split = ids.split(":");
		List<Object> id_s = new ArrayList<Object>(); 
		for (int i = 0; i < split.length; i++) {
			String id = split[i];
			if(!"".equals(id)){
				id_s.add(id);
			}
		}
		//删除计划信息
		HashMap<String, Object> args = new HashMap<String, Object>();
		args.put("ids", id_s);
		planService.deleteUpGradePlan(args);
		//删除计划信息与AP关系表
		planService.deleteUpGradePlanApRel(args);
		return "OK";
	}
}
