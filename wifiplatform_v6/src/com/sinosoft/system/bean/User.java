package com.sinosoft.system.bean;
/**
 * 用户model，数据模型
 * @author zhaolj
 *
 */
public class User {

	private Long id;
	
	private String name;
	
	private String pwd;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	
}
