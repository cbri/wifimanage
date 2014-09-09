package com.sinosoft.util;

import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 获取当前时间
 * */
public class NowStringUtil {
		
	
	public static String getDate() {
		 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
		 return df.format(new Date());// new Date()为获取当前系统时间
	}

}
