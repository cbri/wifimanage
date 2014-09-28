package com.sinosoft.apmessage.bean;

import java.util.Date;

/**
 * AP信息
 * 
 * @author dyf
 * 
 */
public class ApMessage {

	private String ipaddr;
	private String merchant;
	private String mname;
	private String phonenum;
	private String telephonenum;
	private String email;
	private String weixin;
	private String auth_type;

	public String getMname() {
		return mname;
	}

	public void setMname(String mname) {
		this.mname = mname;
	}

	public String getPhonenum() {
		return phonenum;
	}

	public void setPhonenum(String phonenum) {
		this.phonenum = phonenum;
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

	private Long id;
	// 主键ID
	private String name;
	// AP名称
	private String mac;
	// mac地址
	private Long sys_uptime;
	// 运行时长
	private Long sys_upload;
	// 平均负载
	private Long sys_memfree;
	// 空闲内存
	private String remote_addr;
	// AP的IP（exIP）
	private Long update_time;
	// 更新次数
	private String last_seen;
	// 最近一次探测时间
	private String redirect_url;
	// 跳转url
	private String portal_url;
	// 欢迎url
	private String created_at;
	// 创建时间（入网）
	private String updated_at;
	// 更新时间
	private Long configflag;
	// 配置标记
	private String cmdline;
	// 执行命令
	private Long time_limit;
	// 每次上网时长
	private Float lat;
	// 经度
	private Float long1;
	// 纬度
	private String developer;
	// 第三方调用用户名
	private Long cmdflag;
	// cmd标记
	private String province;
	// 省代码
	private String city;
	// 市代码
	private String district;
	// 地区代码
	private String hardware_ver;
	// 硬件版本
	private String software_ver;
	// 软件版本
	private String ssid;
	// SSID
	private String premodel_ip;
	// 前置模块IP
	private String gwip;
	// 内网IP
	private Long merchant_id;
	// 商户ID
	private String detail;
	private String uptime;
	private String address;
	private Integer belong_type;

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String createdAt) {
		created_at = createdAt;
	}

	/** 省名称 */
	private String pname;
	/** 市名称 */
	private String cname;
	/** 区名称 */
	private String dname;

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAuth_type() {
		return auth_type;
	}

	public void setAuth_type(String authType) {
		auth_type = authType;
	}

	// 地址
	// 安装位置
	private boolean onLine;
	private String platform;

	public String getIpaddr() {
		return ipaddr;
	}

	public void setIpaddr(String ipaddr) {
		this.ipaddr = ipaddr;
	}

	public String getMerchant() {
		return merchant;
	}

	public void setMerchant(String merchant) {
		this.merchant = merchant;
	}

	public String getUptime() {
		return uptime;
	}

	public void setUptime(String uptime) {
		if (uptime != null && !"".equals(uptime)) {
			this.uptime = secToTime(Integer.parseInt(uptime));
		} else {
			this.uptime = uptime;
		}
	}

	public String secToTime(int time) {
		String timeStr = null;
		int hour = 0;
		int minute = 0;
		int second = 0;
		if (time <= 0)
			return "00:00:00";
		else {
			minute = time / 60;
			if (minute < 60) {
				second = time % 60;
				timeStr = "00:"+unitFormat(minute) + ":" + unitFormat(second);
			} else {
				hour = minute / 60;
				if (hour > 99)
					return "99:59:59";
				minute = minute % 60;
				second = time - hour * 3600 - minute * 60;
				timeStr = unitFormat(hour) + ":" + unitFormat(minute) + ":"
						+ unitFormat(second);
			}
		}
		return timeStr;
	}
	public String unitFormat(int i) {
		String retStr = null;
		if (i >= 0 && i < 10)
			retStr = "0" + Integer.toString(i);
		else
			retStr = "" + i;
		return retStr;
	}

	public boolean isOnLine() {
		return onLine;
	}

	public void setOnLine(boolean onLine) {
		this.onLine = onLine;
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

	public String getMac() {
		return mac;
	}

	public void setMac(String mac) {
		this.mac = mac;
	}

	public Long getSys_uptime() {
		return sys_uptime;
	}

	public void setSys_uptime(Long sysUptime) {
		sys_uptime = sysUptime;
	}

	public Long getSys_upload() {
		return sys_upload;
	}

	public void setSys_upload(Long sysUpload) {
		sys_upload = sysUpload;
	}

	public Long getSys_memfree() {
		return sys_memfree;
	}

	public void setSys_memfree(Long sysMemfree) {
		sys_memfree = sysMemfree;
	}

	public String getRemote_addr() {
		return remote_addr;
	}

	public void setRemote_addr(String remoteAddr) {
		remote_addr = remoteAddr;
	}

	public Long getUpdate_time() {
		return update_time;
	}

	public void setUpdate_time(Long updateTime) {
		update_time = updateTime;
	}

	public String getLast_seen() {
		return last_seen;
	}

	public void setLast_seen(String lastSeen) {
		last_seen = lastSeen;
	}

	public String getRedirect_url() {
		return redirect_url;
	}

	public void setRedirect_url(String redirectUrl) {
		redirect_url = redirectUrl;
	}

	public String getPortal_url() {
		return portal_url;
	}

	public void setPortal_url(String portalUrl) {
		portal_url = portalUrl;
	}

	public String getUpdated_at() {
		return updated_at;
	}

	public void setUpdated_at(String updatedAt) {
		updated_at = updatedAt;
	}

	public Long getConfigflag() {
		return configflag;
	}

	public void setConfigflag(Long configflag) {
		this.configflag = configflag;
	}

	public String getCmdline() {
		return cmdline;
	}

	public void setCmdline(String cmdline) {
		this.cmdline = cmdline;
	}

	public Long getTime_limit() {
		return time_limit;
	}

	public void setTime_limit(Long timeLimit) {
		time_limit = timeLimit;
	}

	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

	public Float getLong1() {
		return long1;
	}

	public void setLong1(Float long1) {
		this.long1 = long1;
	}

	public String getDeveloper() {
		return developer;
	}

	public void setDeveloper(String developer) {
		this.developer = developer;
	}

	public Long getCmdflag() {
		return cmdflag;
	}

	public void setCmdflag(Long cmdflag) {
		this.cmdflag = cmdflag;
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

	public String getHardware_ver() {
		return hardware_ver;
	}

	public void setHardware_ver(String hardwareVer) {
		hardware_ver = hardwareVer;
	}

	public String getSoftware_ver() {
		return software_ver;
	}

	public void setSoftware_ver(String softwareVer) {
		software_ver = softwareVer;
	}

	public String getSsid() {
		return ssid;
	}

	public void setSsid(String ssid) {
		this.ssid = ssid;
	}

	public String getPremodel_ip() {
		return premodel_ip;
	}

	public void setPremodel_ip(String premodelIp) {
		premodel_ip = premodelIp;
	}

	public String getGwip() {
		return gwip;
	}

	public void setGwip(String gwip) {
		this.gwip = gwip;
	}

	public Long getMerchant_id() {
		return merchant_id;
	}

	public void setMerchant_id(Long merchantId) {
		merchant_id = merchantId;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
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
