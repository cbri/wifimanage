package com.sinosoft.onclien.bean;

import java.util.Date;

/**
 * 区域实信息对象
 * @author 李洪因
 * @since  2014-6-13 
 */
public class Addresses {
	/***/
	private Integer id;
	/***/
	private String province;
	/***/
	private String city;
	/***/
	private String district;
	/***/
	private String detail;
	/***/
	private int access_node_id;
	/***/
	private Date created_at;
	/***/
	private Date updated_at;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getDistrict() {
		return district;
	}
	public void setDistrict(String district) {
		this.district = district;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public int getAccess_node_id() {
		return access_node_id;
	}
	public void setAccess_node_id(int access_node_id) {
		this.access_node_id = access_node_id;
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
	
	
}
