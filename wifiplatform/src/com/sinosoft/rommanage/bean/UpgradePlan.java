package com.sinosoft.rommanage.bean;

import java.util.List;

/**
 * 升级计划实体
 * @author 于永波
 * @since  2014-6-10
 */
public class UpgradePlan {
	/**主键ID*/
	private Integer id;
	/**计划名称*/
	private String plan_name;
	/**计划执行时间*/
	private String execute_time;
	/**实际执行实际*/
	private String real_time;
	/**计划创建时间*/
	private String create_time;
	/**升级前版本*/
	private Integer pre_upgrade_ver;
	/**新版本ID*/
	private Integer version_id;
	/**创建人*/
	private Integer userid;
	/**是否已执行*/
	private Integer isexecute;
	/**审核状态*/
	private Integer check_state;
	/**审核时间*/
	private String check_time;
	/**更新时间*/
	private String updated_at;
	/**该计划对应的AP*/
	private List<UpgradePlanApRel> planApRels;
	/**该计划是否是自己创建*/
	private int isSelfCreate;
	/**创建人*/
	private String create_user;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getPlan_name() {
		return plan_name;
	}
	public void setPlan_name(String plan_name) {
		this.plan_name = plan_name;
	}
	public String getExecute_time() {
		return execute_time;
	}
	public void setExecute_time(String execute_time) {
		this.execute_time = execute_time;
	}
	public String getReal_time() {
		return real_time;
	}
	public void setReal_time(String real_time) {
		this.real_time = real_time;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public Integer getPre_upgrade_ver() {
		return pre_upgrade_ver;
	}
	public void setPre_upgrade_ver(Integer pre_upgrade_ver) {
		this.pre_upgrade_ver = pre_upgrade_ver;
	}
	public Integer getVersion_id() {
		return version_id;
	}
	public void setVersion_id(Integer version_id) {
		this.version_id = version_id;
	}
	public Integer getUserid() {
		return userid;
	}
	public void setUserid(Integer userid) {
		this.userid = userid;
	}
	public Integer getIsexecute() {
		return isexecute;
	}
	public void setIsexecute(Integer isexecute) {
		this.isexecute = isexecute;
	}
	public Integer getCheck_state() {
		return check_state;
	}
	public void setCheck_state(Integer check_state) {
		this.check_state = check_state;
	}
	public String getCheck_time() {
		return check_time;
	}
	public void setCheck_time(String check_time) {
		this.check_time = check_time;
	}
	public String getUpdated_at() {
		return updated_at;
	}
	public void setUpdated_at(String updated_at) {
		this.updated_at = updated_at;
	}
	public List<UpgradePlanApRel> getPlanApRels() {
		return planApRels;
	}
	public void setPlanApRels(List<UpgradePlanApRel> planApRels) {
		this.planApRels = planApRels;
	}
	public int getIsSelfCreate() {
		return isSelfCreate;
	}
	public void setIsSelfCreate(int isSelfCreate) {
		this.isSelfCreate = isSelfCreate;
	}
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
}
