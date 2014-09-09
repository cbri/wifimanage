package com.sinosoft.system.bean;

import java.util.List;

/**
 * 地址测试类，模拟参数bean
 * @author zhaolj
 *
 */
public class AdrressTestBean {

	// 门牌号
	private int doorplate;
	
	private String address;

	private List<Member> memberList;
	
	public List<Member> getMemberList() {
		return memberList;
	}

	public void setMemberList(List<Member> memberList) {
		this.memberList = memberList;
	}

	public int getDoorplate () {
		return doorplate;
	}

	public void setDoorplate (int doorplate) {
		this.doorplate = doorplate;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
}
