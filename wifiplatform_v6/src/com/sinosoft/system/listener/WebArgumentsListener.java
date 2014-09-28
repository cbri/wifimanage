package com.sinosoft.system.listener;

import java.io.File;
import java.util.List;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.dao.impl.AddrTreeDaoImpl;
import com.sinosoft.util.WebContextArguments;
/**
 * 项目全局参数加载实例
 * @author 于永波
 * @since  2014-6-13
 */
public class WebArgumentsListener implements ServletContextListener{
	/**Spring上下文管理实例*/
	private WebApplicationContext context;
	/**项目绝对根路径*/
	private String realPath;
	
	public void contextInitialized(ServletContextEvent event){
		realPath = event.getServletContext().getRealPath(File.separator);
		context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
		AddrTreeDaoImpl addrTreeDao = (AddrTreeDaoImpl) context.getBean("addrTreeDao");
		List<Position> addrTree = addrTreeDao.getAddrTree();
		for (Position position : addrTree) {
			WebContextArguments.codeToName.put(position.getId(),position.getName());
			WebContextArguments.codeToObject.put(position.getId(), position);
		}
	}
	
	public void contextDestroyed(ServletContextEvent event){
		
	}
	
}
