package com.qweib.cloud.biz.attendance.model;

import java.util.List;

public class KqResultVo {
	private Integer memberId;
	private String memberNm;
	private List<String> titleList;
	private List<String> dayStr;
	private List<String> remarksList;
	private List<Integer> typeList;
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public List<String> getTitleList() {
		return titleList;
	}
	public void setTitleList(List<String> titleList) {
		this.titleList = titleList;
	}
	public List<String> getDayStr() {
		return dayStr;
	}
	public void setDayStr(List<String> dayStr) {
		this.dayStr = dayStr;
	}
	public List<String> getRemarksList() {
		return remarksList;
	}
	public void setRemarksList(List<String> remarksList) {
		this.remarksList = remarksList;
	}
	public List<Integer> getTypeList() {
		return typeList;
	}
	public void setTypeList(List<Integer> typeList) {
		this.typeList = typeList;
	}
	
	

}
