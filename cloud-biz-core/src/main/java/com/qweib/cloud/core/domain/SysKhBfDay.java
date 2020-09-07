package com.qweib.cloud.core.domain;

public class SysKhBfDay {
	private String khNm;//客户名称
	private String mobile;//手机
	private String address;//地址
	private String scbfDate;//上次拜访日期
	private Integer dayNum;//天数
	private String database;//数据库
	private String memberNm;//业务员名称
	private String memberIds;
	
	
	
	public String getMemberIds() {
		return memberIds;
	}
	public void setMemberIds(String memberIds) {
		this.memberIds = memberIds;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	public Integer getDayNum() {
		return dayNum;
	}
	public void setDayNum(Integer dayNum) {
		this.dayNum = dayNum;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public String getScbfDate() {
		return scbfDate;
	}
	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}
	
	
}
