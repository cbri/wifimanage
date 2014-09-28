package com.sinosoft.rommanage.bean;
/**
 * 升级计划与AP关系的实体
 * @author 于永波
 * @since  2014-6-10
 */
public class UpgradePlanApRel {
	/**升级计划的ID*/
	private Integer id;
	/**AP的mac*/
	private String mac;
	/**ap主键ID*/
	private Integer apid;
	/**区域编码*/
	private String code;
	/**是否已执行*/
	private Integer isexecute;
	/**是否执行成功*/
	private Integer issuccess;
	/**省名称*/
	private String pname;
	/**市名称*/
	private String cname;
	/**地区名称*/
	private String dname;
	/**ap名称*/
	private String apname;
	/**商家信息*/
	private String contacts;
	/**执行结果*/
	private String execute_result;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getMac() {
		return mac;
	}
	public void setMac(String mac) {
		this.mac = mac;
	}
	public Integer getApid() {
		return apid;
	}
	public void setApid(Integer apid) {
		this.apid = apid;
	}
	public Integer getIsexecute() {
		return isexecute;
	}
	public void setIsexecute(Integer isexecute) {
		this.isexecute = isexecute;
	}
	public Integer getIssuccess() {
		return issuccess;
	}
	public void setIssuccess(Integer issuccess) {
		this.issuccess = issuccess;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public String getCname() {
		return cname;
	}
	public void setCname(String cname) {
		this.cname = cname;
	}
	public String getDname() {
		return dname;
	}
	public void setDname(String dname) {
		this.dname = dname;
	}
	public String getApname() {
		return apname;
	}
	public void setApname(String apname) {
		this.apname = apname;
	}
	public String getContacts() {
		return contacts;
	}
	public void setContacts(String contacts) {
		this.contacts = contacts;
	}
	public String getExecute_result() {
		return execute_result;
	}
	public void setExecute_result(String execute_result) {
		this.execute_result = execute_result;
	}
	
}
