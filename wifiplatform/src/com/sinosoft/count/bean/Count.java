package com.sinosoft.count.bean;

import java.math.BigDecimal;
import java.util.Date;

public class Count {
	
	private String code;
	private String parent_code;
	private String name;
	private int level;
	private int ap_total;
	private int online_num;
	private String online_rate;
	private BigDecimal inconming_total;
	private BigDecimal outgoing_total;
	private Long customer_num;
	private Date date;
	private int yearNum;
	private int monthNum;
	private int day;
	
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public int getYearNum() {
		return yearNum;
	}
	public void setYearNum(int yearNum) {
		this.yearNum = yearNum;
	}
	public int getMonthNum() {
		return monthNum;
	}
	public void setMonthNum(int monthNum) {
		this.monthNum = monthNum;
	}
	public int getDay() {
		return day;
	}
	public void setDay(int day) {
		this.day = day;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getParent_code() {
		return parent_code;
	}
	public void setParent_code(String parentCode) {
		parent_code = parentCode;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public int getAp_total() {
		return ap_total;
	}
	public void setAp_total(int apTotal) {
		ap_total = apTotal;
	}
	public int getOnline_num() {
		return online_num;
	}
	public void setOnline_num(int onlineNum) {
		online_num = onlineNum;
	}
	public String getOnline_rate() {
		return online_rate;
	}
	public void setOnline_rate(String onlineRate) {
		online_rate = onlineRate;
	}
	public BigDecimal getInconming_total() {
		return inconming_total;
	}
	public void setInconming_total(BigDecimal inconmingTotal) {
		inconming_total = inconmingTotal;
	}
	public BigDecimal getOutgoing_total() {
		return outgoing_total;
	}
	public void setOutgoing_total(BigDecimal outgoingTotal) {
		outgoing_total = outgoingTotal;
	}
	public Long getCustomer_num() {
		return customer_num;
	}
	public void setCustomer_num(Long customerNum) {
		customer_num = customerNum;
	}
	
}
