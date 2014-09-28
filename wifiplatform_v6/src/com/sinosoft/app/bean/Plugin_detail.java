package com.sinosoft.app.bean;

import java.util.Date;

public class Plugin_detail {
	/**id*/
	private String plugin_id;
	/**name*/
	private String detail;
	/**创建日期*/
	private Date publish_time;
	/**创建日期*/
	private Date created_at;
	/**更新日期*/
	private Date updated_at;
	/**imagename*/
	private String developer;
	private String version;
	/***/
	private String category;
	private String desc1;
	private String desc2;
	private String desc3;
	public String getPlugin_id() {
		return plugin_id;
	}
	public void setPlugin_id(String plugin_id) {
		this.plugin_id = plugin_id;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public Date getPublish_time() {
		return publish_time;
	}
	public void setPublish_time(Date publish_time) {
		this.publish_time = publish_time;
	}
	public Date getUpdated_at() {
		return updated_at;
	}
	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}
	public Date getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getDeveloper() {
		return developer;
	}
	public void setDeveloper(String developer) {
		this.developer = developer;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getDesc1() {
		return desc1;
	}
	public void setDesc1(String desc1) {
		this.desc1 = desc1;
	}
	public String getDesc2() {
		return desc2;
	}
	public void setDesc2(String desc2) {
		this.desc2 = desc2;
	}
	public String getDesc3() {
		return desc3;
	}
	public void setDesc3(String desc3) {
		this.desc3 = desc3;
	}
}
