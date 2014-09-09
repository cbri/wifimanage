package com.sinosoft.addrtree.bean;
/**
 * 区域
 * @Author 于永波
 * @since  2014/05/26
 */
public class District {
	private Long id;
	private String code;
	private String name;
	private String city_code;
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
	public String getCity_code() {
		return city_code;
	}
	public void setCity_code(String city_code) {
		this.city_code = city_code;
	}
	
}
