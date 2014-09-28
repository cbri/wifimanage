package com.sinosoft.util;

import java.util.HashMap;
import java.util.Map;

import com.sinosoft.addrtree.bean.City;
import com.sinosoft.addrtree.bean.District;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.bean.Province;
/**
 * 项目上下文参数库
 * @author 于永波
 * @since  2014-6-9
 */
public class WebContextArguments {
	/**项目路径后缀*/
	public static final String SUFFIX = "do";
	/**所有区域编码--名称缓存*/
	public static Map<String, String> codeToName = new HashMap<String, String>();
	/**所有区域编码--对象缓存*/
	public static Map<String, Position> codeToObject = new HashMap<String, Position>();
	/**省份编码--对象缓存*/
	@Deprecated
	public static Map<String, Province> codeToProvince = new HashMap<String, Province>();
	/**城市编码--对象缓存*/
	@Deprecated
	public static Map<String, City> codeToCity = new HashMap<String, City>();
	/**区域编码--对象缓存*/
	@Deprecated
	public static Map<String, District> codeToDistrict = new HashMap<String, District>();
	/**切换数据的KEY*/
	public static String CODE = "";
	/**直辖市省编码*/
	public static String [] Directly_Province = {"110000","310000","120000","500000"};
	/**直辖市*/
	public static String [] Directly_City = {"110100","310100","120100","500100"};
	/**每页多少行*/
	public static final int PAGE_SIZE = 20;
	/**常量1*/
	public static final int ONE = 1;
	/**常量2*/
	public static final int TWO = 2;
	/**常量3*/
	public static final int THREE = 3;
	/**常量4*/
	public static final int FOUR = 4;
	/**常量0*/
	public static final int ZERO = 0;
}
