package com.sinosoft.app.bean;

import java.util.Date;

public class Plugins {
	/**id*/
	private String id;
	/**name*/
	private String name;
	
	/**创建日期*/
	private Date created_at;
	/**更新日期*/
	private Date updated_at;
	/**imagename*/
	private String imagename;
	private Boolean ishot;
	/***/
	private String category;
	/**在线日期*/
	private String installcmd;
	private String removecmd;
	
	/**是否更新*/
	private Boolean opkg;
	private String renewcmd;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public String getImagename() {
		return imagename;
	}
	public void setImagename(String imagename) {
		this.imagename = imagename;
	}
	public Boolean getIshot() {
		return ishot;
	}
	public void setIshot(Boolean ishot) {
		this.ishot = ishot;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getInstallcmd() {
		return installcmd;
	}
	public void setInstallcmd(String installcmd) {
		this.installcmd = installcmd;
	}
	public String getRemovecmd() {
		return removecmd;
	}
	public void setRemovecmd(String removecmd) {
		this.removecmd = removecmd;
	}
	public Boolean getOpkg() {
		return opkg;
	}
	public void setOpkg(Boolean opkg) {
		this.opkg = opkg;
	}
	public String getRenewcmd() {
		return renewcmd;
	}
	public void setRenewcmd(String renewcmd) {
		this.renewcmd = renewcmd;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
}
