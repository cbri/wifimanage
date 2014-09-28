package com.sinosoft.onclien.bean;

import java.util.Date;
import java.util.List;
/**
 * 客户连接AP日志
 * @author 李洪因
 * @since  2014-6-13 
 */
public class Connections {
	
	//上限流量
	private String out;
	//下限流量
	private String in;
	public String getOut() {
		return out;
	}
	public void setOut(String out) {
		this.out = out;
	}
	public String getIn() {
		return in;
	}
	public void setIn(String in) {
		this.in = in;
	}
	//客户基本信息
	private String fid;
	private String merchant;
	private String mname;
	private String telephonenum;
	private String phone;
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	private String email;
	private String weixin;
	public String getFid() {
		return fid;
	}
	public void setFid(String fid) {
		this.fid = fid;
	}
	public String getMerchant() {
		return merchant;
	}
	public void setMerchant(String merchant) {
		this.merchant = merchant;
	}
	public String getMname() {
		return mname;
	}
	public void setMname(String mname) {
		this.mname = mname;
	}
	public String getTelephonenum() {
		return telephonenum;
	}
	public void setTelephonenum(String telephonenum) {
		this.telephonenum = telephonenum;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getWeixin() {
		return weixin;
	}
	public void setWeixin(String weixin) {
		this.weixin = weixin;
	}
	
	
	
	/**客户连接AP日志表**/
	
	/**主键ID*/
	private Long id;
	/**标记*/
	private String token;
	/**ip地址*/
	private String ipaddr;
	/**APMAC地址*/
	private String access_mac;
	/**上线时间*/
	private Date used_on;
	/**下线时间*/
	private Date expired_on;
	/**终端MAC地址*/
	private String mac;
	/**下载流量*/
	private int incoming;
	/**上传流量*/
	private int outgoing;
	/**创建时间*/
	private Date create_at;
	/**更新时间*/
	private Date updated_at;
	/**APID*/
	private int access_node_id;
	/**终端类型*/
	private String device;
	/**欢迎页面*/
	private String portal_url;
	/**电话号码*/
	private String phonenum;
	
	
	/*新添加的地区和名称*/
	/**省编码*/
	private String province;
	/**市编码*/
	private String city;
	/**区编码*/
	private String district;
	/**省名称*/
	private String pname;
	/**市名称*/
	private String cname;
	/**区名称*/
	private String dname;
	
	//新添加的时间
	private String time;
	
	

	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
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
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public String getIpaddr() {
		return ipaddr;
	}
	public void setIpaddr(String ipaddr) {
		this.ipaddr = ipaddr;
	}
	public String getAccess_mac() {
		return access_mac;
	}
	public void setAccess_mac(String access_mac) {
		this.access_mac = access_mac;
	}
	public Date getUsed_on() {
		return used_on;
	}
	public void setUsed_on(Date used_on) {
		this.used_on = used_on;
	}
	public Date getExpired_on() {
		return expired_on;
	}
	public void setExpired_on(Date expired_on) {
		this.expired_on = expired_on;
	}
	public String getMac() {
		return mac;
	}
	public void setMac(String mac) {
		this.mac = mac;
	}
	public int getIncoming() {
		return incoming;
	}
	public void setIncoming(int incoming) {
		this.incoming = incoming;
	}
	public int getOutgoing() {
		return outgoing;
	}
	public void setOutgoing(int outgoing) {
		this.outgoing = outgoing;
	}
	public Date getCreate_at() {
		return create_at;
	}
	public void setCreate_at(Date create_at) {
		this.create_at = create_at;
	}
	public Date getUpdated_at() {
		return updated_at;
	}
	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}
	public int getAccess_node_id() {
		return access_node_id;
	}
	public void setAccess_node_id(int access_node_id) {
		this.access_node_id = access_node_id;
	}
	public String getDevice() {
		return device;
	}
	public void setDevice(String device) {
		this.device = device;
	}
	public String getPortal_url() {
		return portal_url;
	}
	public void setPortal_url(String portal_url) {
		this.portal_url = portal_url;
	}
	public String getPhonenum() {
		return phonenum;
	}
	public void setPhonenum(String phonenum) {
		this.phonenum = phonenum;
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
	private Integer belong_type;
	private String platform;
	public Integer getBelong_type() {
		if (belong_type==null){
			return 0;
		}
		return belong_type;
	}

	public void setBelong_type(Integer belong_type) {
		this.belong_type = belong_type;
	}

	public String getPlatform() {
		return platform;
	}

	public void setPlatform(String platform) {
		this.platform = platform;
	}
	
}
