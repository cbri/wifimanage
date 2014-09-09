package com.sinosoft.count.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sinosoft.account.bean.Account;
import com.sinosoft.apmessage.service.ApMessageService;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.count.service.CountService;
import com.sinosoft.util.NowStringUtil;

@Controller
public class CountController extends BaseController {

	// session记录
	private HttpSession session;
	// 注入service
	@Autowired
	private CountService countService;
	@Autowired
	private ApMessageService apMessageService;

	/**
	 * 跳转统计页面
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/countController!toCountPage.do")
	public ModelAndView toCountPage(HttpServletRequest req, HttpServletResponse rep) {
		// 从Session中获取userid
		Account user = (Account) req.getSession().getAttribute("user");
		List<String> codelist = new ArrayList<String>();
		List<HashMap> countList = new ArrayList<HashMap>();
		if (user.getId()==1) {
			// 如果是管理员直接查询全国level=0
			countList = countService.queryAllProvinceCount();
		} else {
			// 获取用户管辖的最高级区域code
			codelist = countService.findTopCodeByid(user.getId());
			for (int i = 0; i < codelist.size(); i++) {
				String code = codelist.get(i);
				// 通过地区code查询该区域统计
				HashMap count = countService.queryCountByCode(code);
				countList.add(count);
			}
		}
		String flag=req.getParameter("flag");
		if(flag!=null){
			//将json数据传回
			String json = JSONArray.fromObject(countList).toString();
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
		//计算总客户数
		int customerTotal=0;
		for (int i = 0; i < countList.size(); i++) {
			customerTotal+=(Integer)countList.get(i).get("customer_num");
		}
		req.setAttribute("customerTotal", customerTotal);
		req.setAttribute("countList", countList);
		// 遍历区域code
		ModelAndView mv = new ModelAndView("/source/page/count/countIndex.jsp");
		return mv;
	}

	/**
	 * 查询区域统计
	 * @param req
	 * @param rep
	 */
	@ResponseBody
	@RequestMapping(value = "/countController!initGrowth.do")
	public void initGrowth(HttpServletRequest req, HttpServletResponse rep) {
		rep.setContentType("text/html;charset=utf-8");
		//接收level和区域code
		String code=req.getParameter("code");
		String level=req.getParameter("level");
		List countList=new ArrayList();
		//区域查询本身
		if("1".equals(level)){
			HashMap count=countService.queryCountByCode(code);
			if(count!=null)
				countList.add(count);
		}//省市查询子集
		else{
			countList=countService.queryCountSubset(code);
		}
		//将json数据传回
		String json = JSONArray.fromObject(countList).toString();
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
	}
	
	/**
	 * 初始化省
	 * @param req
	 * @param rep
	 */
	@ResponseBody
	@RequestMapping(value = "/countController!initSelectProvince.do")
	public void initSelectProvince(HttpServletRequest req, HttpServletResponse rep) {
		rep.setContentType("text/html;charset=utf-8");
		Map map = new HashMap();
		Account user = (Account) req.getSession().getAttribute("user");
		map.put("userid", user.getId());
		map.put("level", user.getLevel());
		List provinceList=new ArrayList();
		//管理员查所有非管理员查本身
		if(user.getId()==1){
			provinceList = countService.initProvince();
		}else{
			provinceList = apMessageService.init(map);
		}
		//将json数据传回
		String json = JSONArray.fromObject(provinceList).toString();
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
	}

	/**
	 * 图表初始化AP总数
	 * @param req
	 * @param rep
	 */
	@ResponseBody
	@RequestMapping(value = "/countController!initAPChart.do")
	public void initAPChart(HttpServletRequest req, HttpServletResponse rep) {
		rep.setContentType("text/html;charset=utf-8");
		Account user = (Account) req.getSession().getAttribute("user");
		List<String> codelist = new ArrayList<String>();
		List<HashMap> countList = new ArrayList<HashMap>();
		if (user.getId()==1) {
			// 如果是管理员直接查询全国总计 
			countList = countService.queryAllCount();
		} else {
			// 获取用户管辖的最高级区域code
			codelist = countService.findTopCodeByid(user.getId());
			int ap_total=0;
			int online_num=0;
			int incoming=0;
			int outgoing=0;
			for (int i = 0; i < codelist.size(); i++) {
				String code = codelist.get(i);
				// 通过地区code查询该区域统计
				HashMap count = countService.queryCount(code);
				ap_total+=(Integer)count.get("ap_total");
				online_num+=(Integer)count.get("online_num");
				incoming+=(Integer)count.get("incoming");
				outgoing+=(Integer)count.get("outgoing");
			}
			HashMap result=new HashMap();
			result.put("ap_total", ap_total);
			result.put("online_num", online_num);
			result.put("incoming", incoming);
			result.put("outgoing", outgoing);;
			countList.add(result);
		}
		//将json数据传回
		String json = JSONArray.fromObject(countList).toString();
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
	}
	
	
	/**
	 * 根据条件查询制图数据
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/countController!selectHighcharts")
	public List<String> selectHighcharts (HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("textml;charset=utf-8");
			Map map = new HashMap();
			List<String> areaList = new ArrayList<String>();
			String timeM 	= req.getParameter("timeM");
			String timeY 	= req.getParameter("timeY");
			String province = req.getParameter("province");
			String city = req.getParameter("city");
			String district = req.getParameter("district");
			
			if(!"".equals(timeY) && "".equals(timeM) ){ //年选不为空并且月选为空，表示看月度数据。查询某年的12个自然月
				  if(!"".equals(province) && "".equals(city) &&  "".equals(district)){  //查看省
					  String[] strings = province.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					  	map.put("code",areaList);
				  }else if(!"".equals(city) &&  "".equals(district)){ //查看市
					  String[] strings = city.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					   map.put("code",areaList);
				  }else if(!"".equals(district)){  //查看区
					  String[] strings = district.split(",");
					  for( String code : strings){
						  areaList.add(code);
					   }
					  map.put("code",areaList);
				  }
				  map.put("year_num",timeY);
				  map.put("table","selectHighcharts_m");
				  
			}else if(!"".equals(timeY) && !"".equals(timeM) ){ //年选不为空并且月选不为空表示查看日度数据。某个自然月30天的数据
				 if(!"".equals(province) && "".equals(city) &&  "".equals(district)){  //查看某省的制图数据
					 String[] strings = province.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					  	map.put("code",areaList);
				  }else if(!"".equals(city) &&  "".equals(district)){ //查看某省下一个或多个市的制图数据
					  String[] strings = city.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					   map.put("code",areaList);
				  }else if(!"".equals(district)){  //查看某省多个市下一个或多个区的制图数据
					  String[] strings = district.split(",");
					  for( String code : strings){
						  areaList.add(code);
					   }
					  map.put("code",areaList);
				  }
				  map.put("year_num",timeY);
				  map.put("month_num",timeM);
				  map.put("table","selectHighcharts_d");
			}
			List list = countService.selectHighcharts(map);
			return list;
		}
	
	
	
	
	
	/**
	 * 根据条件查询制图数据
	 * @param req
	 * @param rep
	 * wanghp
	 * */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/countController!Highcharts2")
	public List<String> Highcharts2 (HttpServletRequest req,HttpServletResponse rep){
		rep.setContentType("textml;charset=utf-8");
			Map map = new HashMap();
			List<String> areaList = new ArrayList<String>();
			String strTimeM 	= req.getParameter("strTimeM");
			String strTimeD 	= req.getParameter("strTimeD");
			String province = req.getParameter("province");
			String city = req.getParameter("city");
			String district = req.getParameter("district");
			
			if(!"".equals(strTimeM) && "".equals(strTimeD) ){ //月度数据
				  if(!"".equals(province) && "".equals(city) &&  "".equals(district)){  //查看某省的制图数据
					  String[] strings = province.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					  	map.put("code",areaList);
				  }else if(!"".equals(city) &&  "".equals(district)){ //查看某省一个市的制图数据
					  String[] strings = city.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					   map.put("code",areaList);
				  }else if(!"".equals(district)){  //查看某省一个区的制图数据
					  String[] strings = district.split(",");
					  for( String code : strings){
						  areaList.add(code);
					   }
					  map.put("code",areaList);
				  }
				  String[] strings = strTimeM.split(",");
					 List list = new ArrayList();
					 for(String time : strings){ //2014-06-04  截取字符串“2014” 数字运算减去1后替换
							if(time==""){
								return list ;
							}else{
								list.add(time);
								}
							}
				  map.put("stat_date", list);
				  map.put("table","selectHighcharts2_m");
				  
			}else if(!"".equals(strTimeD) && "".equals(strTimeM)){ //日期数据
				 if(!"".equals(province) && "".equals(city) &&  "".equals(district)){  //查看某省的制图数据
					 String[] strings = province.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					  	map.put("code",areaList);
				  }else if(!"".equals(city) &&  "".equals(district)){ //查看某省下一个或多个市的制图数据
					  String[] strings = city.split(",");
					   for( String code : strings){
						   areaList.add(code);
					   }
					   map.put("code",areaList);
				  }else if(!"".equals(district)){  //查看某省多个市下一个或多个区的制图数据
					  String[] strings = district.split(",");
					  for( String code : strings){
						  areaList.add(code);
					   }
					  map.put("code",areaList);
				  }
				 String[] strings = strTimeD.split(",");
				 List list = new ArrayList();
				 for(String time : strings){ //2014-06-04  截取字符串“2014” 数字运算减去1后替换
						if(time==""){
							return list ;
						}else{
							list.add(time);
							}
						}
				  map.put("stat_date", list);
				  map.put("table","selectHighcharts2_d");
			}
			List list = countService.selectHighcharts(map);
			return list;
		}
	/**
	 * 将所需信息存入session
	 * 
	 * @param req
	 *            HttpServletRequest
	 * @param key
	 *            保存信息索引
	 * @param value
	 *            保存信息对象
	 * @return
	 */
	public void setSession(HttpServletRequest req, String key, Object value) {
		session = req.getSession();
		session.setAttribute(key, value);
	}

}
