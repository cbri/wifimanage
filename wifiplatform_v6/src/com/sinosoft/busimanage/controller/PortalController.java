package com.sinosoft.busimanage.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.base.controller.BaseController;
/**
 * Portal管理Controller
 * @author 于永波
 * @since  2014-6-10
 */
@Controller
public class PortalController extends BaseController{
	
	@RequestMapping(value="portal!portalManage.do",method=RequestMethod.GET)
	public ModelAndView init(HttpServletRequest req){
		ModelAndView view = new ModelAndView("/source/page/business/portal.jsp");
		return view;
	}
	
}
