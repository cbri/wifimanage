package com.sinosoft.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.app.bean.Plugins;
import com.sinosoft.app.bean.Router;
import com.sinosoft.app.service.AppService;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.dataSource.DbContextHolder;

@Controller
public class AppController extends BaseController {
	@Autowired
	private AppService appService;
	
	/**
	 * 用户管理初始化界面
	 * @param req
	 * @return
	 */
	@RequestMapping(value="app!initRouterManage.do")
	public ModelAndView initRouterManage(HttpServletRequest req){
		DbContextHolder.clearDbType();
		Account acc = (Account) req.getSession().getAttribute("user");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("parent_userid", acc.getId());
		List<Router> routers = appService.getRouter(args);
		
		ModelAndView view = new ModelAndView("source/page/app/router.jsp");
		view.addObject("router", routers);
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
	
	@RequestMapping(value="app!initPluginManage.do")
	public ModelAndView initPluginManage(HttpServletRequest req){
		DbContextHolder.clearDbType();
		Account acc = (Account) req.getSession().getAttribute("user");
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("parent_userid", acc.getId());
		List<Plugins> plugins = appService.getPlugin(args);
		
		ModelAndView view = new ModelAndView("source/page/app/plugin.jsp");
		view.addObject("plugin", plugins);
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
	@RequestMapping(value="app!initRouterPluginManage.do")
	public ModelAndView initRouterPluginManage(HttpServletRequest req){
		DbContextHolder.clearDbType();
		Account acc = (Account) req.getSession().getAttribute("user");
		Map<String, Object> args = new HashMap<String, Object>();
		String id=req.getParameter("id");
		if (id!=null)
		{
		  args.put("id", id);
		}
		List<Plugins> plugins = appService.getPluginByRouter(args);
		
		ModelAndView view = new ModelAndView("source/page/app/rplugin.jsp");
		view.addObject("plugin", plugins);
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
}
