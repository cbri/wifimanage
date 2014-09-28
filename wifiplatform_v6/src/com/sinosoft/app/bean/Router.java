package com.sinosoft.app.bean;
import java.util.Date;

public class Router {
	/**id*/
	private String id;
	/**mac地址*/
	private String mac;
	
	/**创建日期*/
	private Date created_at;
	/**更新日期*/
	private Date updated_at;
	/**软件*/
	private String software;
	/***/
	private String factory;
	/**在线日期*/
	private Date last_seen;
	
	/**是否更新*/
	private Boolean renew;

	public String getMac() {
		return mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}

	public Date getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public Date getUpdated_at() {
		return updated_at;
	}

	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}

	public String getSoftware() {
		return software;
	}

	public void setSoftware(String software) {
		this.software = software;
	}

	public String getFactory() {
		return factory;
	}

	public void setFactory(String factory) {
		this.factory = factory;
	}

	public Date getLast_seen() {
		return last_seen;
	}

	public void setLast_seen(Date last_seen) {
		this.last_seen = last_seen;
	}

	public Boolean getRenew() {
		return renew;
	}

	public void setRenew(Boolean renew) {
		this.renew = renew;
	}


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
}
