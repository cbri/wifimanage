package com.sinosoft.util;

/**
 * 
 * 字符处理工具类
 * @author zhaolj
 * 
 */
public class StringUtil extends org.apache.commons.lang.StringUtils {

	/**
	 * 判断字符串是否为空
	 * @param characters 字符串
	 * @return
	 */
	public static boolean isNull(String characters) {
		if (null == characters || "".equals(characters)) {
			return true;
		}
		return false;
	}
	

}
