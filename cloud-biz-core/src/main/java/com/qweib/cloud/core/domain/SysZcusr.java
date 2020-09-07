package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class SysZcusr {
	private Integer zusrId;//主id
	private Integer cusrId;//次id
	//--------------------不在数据库-------------------
	private String memberNm;//用户名称
	private String cusrIds;//次id组
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getCusrIds() {
		return cusrIds;
	}
	public void setCusrIds(String cusrIds) {
		this.cusrIds = cusrIds;
	}
	public Integer getCusrId() {
		return cusrId;
	}
	public void setCusrId(Integer cusrId) {
		this.cusrId = cusrId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public Integer getZusrId() {
		return zusrId;
	}
	public void setZusrId(Integer zusrId) {
		this.zusrId = zusrId;
	}
	
	

}
