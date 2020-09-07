package com.qweib.cloud.core.domain;

import java.util.List;


/**
 * 签到
 * @author yyp
 *
 */
public class SysCheckInPC {
	private Integer id;
	private String branchNm;
	private String memberNm;
	private String cdate;
	private String stime;
	private String etime;
	private String dateweek;
	private String location;
	private String cdzt;//迟到/早退
	private List<SysCheckinPic> picList;
	
	public String getCdzt() {
		return cdzt;
	}
	public void setCdzt(String cdzt) {
		this.cdzt = cdzt;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getDateweek() {
		return dateweek;
	}
	public void setDateweek(String dateweek) {
		this.dateweek = dateweek;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getBranchNm() {
		return branchNm;
	}
	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	
	public String getCdate() {
		return cdate;
	}
	public void setCdate(String cdate) {
		this.cdate = cdate;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	public String getEtime() {
		return etime;
	}
	public void setEtime(String etime) {
		this.etime = etime;
	}
	public List<SysCheckinPic> getPicList() {
		return picList;
	}
	public void setPicList(List<SysCheckinPic> picList) {
		this.picList = picList;
	}
	
	
	
	
}
