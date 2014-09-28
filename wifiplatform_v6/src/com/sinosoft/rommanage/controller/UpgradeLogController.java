package com.sinosoft.rommanage.controller;

import java.io.PrintWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.rommanage.bean.UpgradePlanApRel;
import com.sinosoft.rommanage.service.UpgradeLogService;
import com.sinosoft.util.CommonDaoImpl;
import com.sinosoft.util.RemoteCallUtil;
import com.sinosoft.util.WebContextArguments;

/**
 * 升级日志的Controller
 * @author 于永波
 * @since  2014-6-10
 */
@Controller
public class UpgradeLogController extends BaseController{
	
	@Autowired
	private UpgradeLogService upgradeLogService;
	@Autowired
	private CommonDaoImpl commonDaoImpl;
	/**
	 * 界面初始化
	 * @param req
	 * @return
	 */
	@RequestMapping(value="upGrade!upGradeLog.do",method=RequestMethod.GET)
	public ModelAndView init(HttpServletRequest req){
		Account user = (Account) req.getSession().getAttribute("user");
		HashMap<String,Object> map = new HashMap<String,Object>();
		map.put("pageNum", WebContextArguments.ZERO);
		map.put("pageSize", WebContextArguments.PAGE_SIZE);
		map.put("userid", user.getId());
		List<?>romloglist = upgradeLogService.queryAllLog(map);
		ModelAndView view = new ModelAndView("/source/page/rom/upgrade_log.jsp");
		view.addObject("romloglist",romloglist);
		return view;
	}
	/**
	 * 根据名称搜索
	 * @param req
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="upGrade!queryByName",method=RequestMethod.POST)
	public String queryLogByName(HttpServletRequest req,HttpServletResponse rep)throws ParseException{
		String planname = req.getParameter("planname");
		String start_time = req.getParameter("start_time");
		String end_time = req.getParameter("end_time");
		String pageNum = req.getParameter("pageNum");
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("planname", planname);
		map.put("start_time", start_time);
		map.put("end_time", end_time);
		Account user = (Account) req.getSession().getAttribute("user");
		map.put("userid", user.getId());
		if(pageNum != null && !"".equals(pageNum)){
			map.put("pageNum", Integer.parseInt(pageNum)*WebContextArguments.PAGE_SIZE);
			map.put("pageSize", WebContextArguments.PAGE_SIZE);
		}else{
			map.put("pageNum", WebContextArguments.ZERO);
			map.put("pageSize", WebContextArguments.PAGE_SIZE);
		}
		List<?> romloglist = upgradeLogService.queryLogByName(map);
		String json = JSONArray.fromObject(romloglist).toString();
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
	 * 查询AP的执行日志信息
	 * @param req
	 * @param rep
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="upGrade!queryUpgradeApLog.do",method=RequestMethod.POST)
	public String queryUpgradeApLog(HttpServletRequest req,HttpServletResponse rep){
		String id = req.getParameter("id");
		//根据升级日志的ID查询，AP执行日志信息
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<UpgradePlanApRel> apLogs = upgradeLogService.queryUpgradeApLog(map);
		for (UpgradePlanApRel apRel : apLogs) {
			supplementName(apRel);
		}
		return JSONArray.fromObject(apLogs).toString();
	}
	
	/**
	 * 重新执行升级计划
	 * @param req
	 * @param rep
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="upGrade!rexecuteUpgradePlan.do",method=RequestMethod.POST)
	public JSONObject rexecuteUpgradePlan(HttpServletRequest req,HttpServletResponse rep){
		String macs = req.getParameter("macs");
		String id = req.getParameter("id");
		String [] mac = macs.split(":");
		int success = 0;
		HashMap<String, Object> mp = new HashMap<String, Object>();
		List<String> succesMac = new ArrayList<String>();
		for (String mc : mac) {
			if(!"".equals(mc.trim())){
				//
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("cmd_flag", 5);
				map.put("mac", mc);
				String ip = commonDaoImpl.queryIpByMac(map);
				map.put("ip", ip);
				String result = RemoteCallUtil.remoteCall(map);
				//解析是否执行成功
				String code = result;
				map = new HashMap<String, Object>();
				map.put("id", id);
				map.put("mac", mc);
				map.put("isexecute", 1);
				map.put("execute_result",code);
				if(code.contains("200")){
					//成功
					map.put("issuccess", 1);
					upgradeLogService.updateUpradePlanApRel(map);
					succesMac.add(mc);
					logger.debug("计划执行成功!!!!!--------："+code);
					success ++;
				}else{
					map.put("issuccess", 0);
					upgradeLogService.updateUpradePlanApRel(map);
					logger.debug("计划执行失败!!!!!--------："+code);
				}
			}
		}
		mp.put("id", id);
		mp.put("success", success);
		upgradeLogService.updateUpgradePlanLog(mp);
		JSONObject obj = new JSONObject();
		obj.element("id", id);
		obj.element("success", success);
		obj.element("successMac", succesMac);
		return obj;
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
}
