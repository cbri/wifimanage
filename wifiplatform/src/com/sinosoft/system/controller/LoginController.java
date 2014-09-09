package com.sinosoft.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.system.bean.AdrressTestBean;
import com.sinosoft.system.bean.Member;
import com.sinosoft.system.bean.User;
import com.sinosoft.system.service.LoginService;
import com.sinosoft.util.StringUtil;

/**
 * 用户登录action
 * 处理用户登录和登录权限控制
 * @author zhaolj
 *
 */
@Controller
public class LoginController extends BaseController{
	
	@Autowired
	private LoginService loginService;
	// session记录
	private HttpSession session;
	
	/**
	 * 用户登陆action，处理用户登陆操作
	 * @param req    HttpServletRequest
	 * @param user   登陆用户信息
	 * @return
	 */
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public ModelAndView login(HttpServletRequest req, User user){
		// 获得用户名密码
		String userName = user.getName();
		String pwd = user.getPwd();
		// 提示信息
		Map<String, String> msgs = new HashMap<String, String>();
		// 用户登陆验证
		if(StringUtil.isNull(userName) || StringUtil.isNull(pwd)){
			msgs.put("msg", "用户名密码不能为空！");
			return new ModelAndView("redirect:login.jsp", msgs);
		} else {
			// 验证用户和密码是否匹配
			if(loginService.verificationUserInfo(userName, pwd) != null){
				user = loginService.verificationUserInfo(userName, pwd);
				// 用户信息存入session
				setSession(req, "user", user);
				
				//--------------------  模拟参数传递   begin--------------------------
				// TODO 添加登陆成功后页面跳转信息
				//Map<String, Object> map = new HashMap<String, Object>();
				//map.put("user", user);
				//ModelAndView mv = new ModelAndView("redirect:/index.jsp");
				// 页面访问路径
				ModelAndView mv = new ModelAndView("/dmms/index");
				// 模拟地址参数
				AdrressTestBean address = new AdrressTestBean();
				address.setDoorplate(100);
				address.setAddress("beijing");
				
				Member member1 = new Member();
				member1.setName("tom");
				member1.setAge(12);
				
				Member member2 = new Member();
				member2.setName("lily");
				member2.setAge(10);
				
				// 列表参数
				List<Member> members = new ArrayList<Member>();
				members.add(member1);
				members.add(member2);
				address.setMemberList(members);
				
				mv.addObject("address", address);
				
				mv.addObject("curruser", user);
				//--------------------  模拟参数传递  end  --------------------------
				return mv;
			} else {
				msgs.put("msg", "用户名密码不正确！");
				return new ModelAndView("redirect:login.jsp", msgs);
			}
		}
	}
	/**
	 * 将所需信息存入session
	 * @param req     HttpServletRequest
	 * @param key     保存信息索引
	 * @param value   保存信息对象
	 * @return
	 */
	public void setSession(HttpServletRequest req, String key, Object value) {
		session = req.getSession();
		session.setAttribute(key, value);
	}

}
