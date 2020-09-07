package com.qweib.cloud.core.domain;

public class SysOftenuser {
	
	private Integer memberId; //会员
	private Integer bindMemberId; //常用联系人
	
	public Integer getBindMemberId() {
		return bindMemberId;
	}
	public void setBindMemberId(Integer bindMemberId) {
		this.bindMemberId = bindMemberId;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	
}
