package com.sinosoft.constant;
/**
 * 用户分型枚举
 * @author zhaolj
 *
 */
public enum UserTyping {

	FLOW_OVERFLOW("流量溢出型"),
	VOICE_HOBBY("语音偏好型"),
	TERMINAL_RESTRICT("终端制约"),
	INSUFFICIENT("需求不足");
	
	private String name;
	
	private UserTyping(String name){
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
}
