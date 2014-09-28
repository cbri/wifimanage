package com.sinosoft.system.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sinosoft.account.bean.Account;

/**
 * 访问时对用户是否登录进行验证
 * @author 于永波
 * @since 2014-6-9
 *
 */
public class AccountFilter implements Filter{
	
	private String login_page;
	private String login_url;

	public void destroy() {}

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		Account account = (Account) request.getSession().getAttribute("user");
		if(account == null){
			//用户未登录,跳到登录界面
			if(request.getRequestURI() != null && (request.getRequestURI().indexOf(login_page) != -1 ||
					request.getRequestURI().indexOf(login_url) != -1)){
				chain.doFilter(req, res);
			}else{
//				request.getRequestDispatcher(login_page).forward(request, response);
				response.sendRedirect(login_page);
			}
		}else{
			chain.doFilter(req, res);
		}
	}
	public void init(FilterConfig config) throws ServletException {
		login_page = config.getInitParameter("login_page");
		login_url = config.getInitParameter("login_url");
		if(login_page == null){
			login_page = "index.jsp";
		}
	}

}
