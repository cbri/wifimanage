package com.sinosoft.account.bean;


/**
 * 主页显示统计
 * @author 于永波
 * @since  2014-6-17
 */
public class GrowthTotal{
	/**区域编码*/
	private String code;
	/**父区域编码*/
	private String parent_code;
	/**区域名称*/
	private String name;
	/**区域级别(0表示省级，1表示市级，2表示区级，9表示全国)*/
	private Integer level;
	/**AP总数*/
	private Integer ap_total;
	/**在线数*/
	private Integer online_num;
	/**在线率*/
	private String online_rate;
	/**上行流量*/
	private Long inconming_total;
	/**下行流量*/
	private Long outgoing_total;
	/**客户数*/
	private Integer customer_num;
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getParent_code() {
		return parent_code;
	}
	public void setParent_code(String parent_code) {
		this.parent_code = parent_code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getAp_total() {
		return ap_total;
	}
	public void setAp_total(Integer ap_total) {
		this.ap_total = ap_total;
	}
	public Integer getOnline_num() {
		return online_num;
	}
	public void setOnline_num(Integer online_num) {
		this.online_num = online_num;
	}
	public String getOnline_rate() {
		return online_rate;
	}
	public void setOnline_rate(String online_rate) {
		this.online_rate = online_rate;
	}
	public Long getInconming_total() {
		return inconming_total;
	}
	public void setInconming_total(Long inconming_total) {
		this.inconming_total = inconming_total;
	}
	public Long getOutgoing_total() {
		return outgoing_total;
	}
	public void setOutgoing_total(Long outgoing_total) {
		this.outgoing_total = outgoing_total;
	}
	public Integer getCustomer_num() {
		return customer_num;
	}
	public void setCustomer_num(Integer customer_num) {
		this.customer_num = customer_num;
	}
}
