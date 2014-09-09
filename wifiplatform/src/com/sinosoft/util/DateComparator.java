package com.sinosoft.util;

import java.util.Comparator;
import java.util.Date;
import java.util.Map;

public class DateComparator implements Comparator {

	/**
	 * 日期比较器
	 */
	public int compare(Object o1, Object o2) {
		Map m1 = (Map) o1, m2 = (Map) o2;
		Date date1 = (Date) m1.get("set_time");
		Date date2 = (Date) m2.get("set_time");
		if (date1.getTime() > date2.getTime()) {
			return -1;
		} else if (date1.getTime() < date2.getTime()) {
			return 1;
		} else {
			return 0;
		}
	}
}
