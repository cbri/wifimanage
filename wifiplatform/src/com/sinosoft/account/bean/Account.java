package com.sinosoft.account.bean;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import com.sinosoft.addrtree.bean.Position;
/**
 * 用户实体对象
 * @author 于永波
 * @since  2014-5-29
 *
 */
public class Account {
	/**主键ID*/
	private Long id;
	/**用户名*/
	private String name;
	/**密码*/
	private String password;
	/**创建日期*/
	private Date created_at;
	/**更新日期*/
	private Date updated_at;
	/**标记*/
	private String token;
	/**真实姓名*/
	private String real_name;
	/**失效标示*/
	private Integer invalid_flag;
	/**锁定时间*/
	private Date lock_time;
	/**联系方式*/
	private String contact;
	/**上级用户ID*/
	private Long parent_userid;
	/**管理域*/
	private List<AccountDistrictRel> positions;
	/**可用切库用的所有省份*/
	private List<Position> provinces;
	private Integer level;
	/**管理域code*/
	private String code;
	/**用户操作当前库的Pcode*/
	private String pcode;
	
	public String getCode() {
		/*Iterator<AccountDistrictRel> it = positions.iterator();
		String code = null;
		while(it.hasNext()){
			AccountDistrictRel positions = it.next();
			code = positions.getCode()+",";
		}
		return code;*/
		return positions.get(0).getCode();
	}
	public void setCode(String code) {
		this.code = code;
	}
	
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
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
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
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
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public String getReal_name() {
		return real_name;
	}
	public void setReal_name(String real_name) {
		this.real_name = real_name;
	}
	public Integer getInvalid_flag() {
		return invalid_flag;
	}
	public void setInvalid_flag(Integer invalid_flag) {
		this.invalid_flag = invalid_flag;
	}
	public Date getLock_time() {
		return lock_time;
	}
	public void setLock_time(Date lock_time) {
		this.lock_time = lock_time;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
	public Long getParent_userid() {
		return parent_userid;
	}
	public void setParent_userid(Long parent_userid) {
		this.parent_userid = parent_userid;
	}
	public List<AccountDistrictRel> getPositions() {
		return positions;
	}
	public void setPositions(List<AccountDistrictRel> positions) {
		this.positions = positions;
	}
	
	public List<Position> getProvinces() {
		return provinces;
	}
	public void setProvinces(List<Position> provinces) {
		this.provinces = provinces;
	}
	public Account(String name, String password, Date updated_at,
			String real_name, String contact) {
		super();
		this.name = name;
		this.password = password;
		this.updated_at = updated_at;
		this.real_name = real_name;
		this.contact = contact;
	}
	public Account() {
	}
	public String getPcode() {
		return pcode;
	}
	public void setPcode(String pcode) {
		this.pcode = pcode;
	}
}
