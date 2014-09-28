package com.sinosoft.account.bean;

/**
 * 用户区域关系对象s
 * @author 于永波
 * @since  2014-5-30
 */
public class AccountDistrictRel {
	/**用户ID*/
	private Long userid;
	/**区域编码*/
	private String code;
	/**区域名称*/
	private String name;
	/**父区域编码*/
	private String parent_code;
	/**区域等级*/
	private Integer level;
	public Long getUserid() {
		return userid;
	}
	public void setUserid(Long userid) {
		this.userid = userid;
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
	public String getParent_code() {
		return parent_code;
	}
	public void setParent_code(String parent_code) {
		this.parent_code = parent_code;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	
}
