package com.qweib.cloud.core.domain;

import java.util.List;


public class SysCheckInDate {
	private Integer psnId;
	private String checkTime;
	private List<SysCheckInConform> list;
	private String memberName;
	
	
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getCheckTime() {
		return checkTime;
	}
	public void setCheckTime(String checkTime) {
		this.checkTime = checkTime;
	}
	public List<SysCheckInConform> getList() {
		return list;
	}
	public void setList(List<SysCheckInConform> list) {
		this.list = list;
	}
	public Integer getPsnId() {
		return psnId;
	}
	public void setPsnId(Integer psnId) {
		this.psnId = psnId;
	}
	
	
}
