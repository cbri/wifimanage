package com.sinosoft.addrtree.bean;
/**
 * 城市
 * @Author 于永波
 * @since  2014/05/26
 */
public class City {
	private Long id;
	private String code;
	private String name;
	private String province_code;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProvince_code() {
		return province_code;
	}
	public void setProvince_code(String province_code) {
		this.province_code = province_code;
	}
	
}
