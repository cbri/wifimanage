package com.sinosoft.base.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
/**
 * 控制器基类，通用方法的扩展类
 * @author zhaolj
 *
 */
public class BaseController extends AbstractController {
	
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest req,
			HttpServletResponse resp) throws Exception {
		return super.handleRequest(req, resp);
	}
	
	

}
