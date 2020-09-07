package com.qweib.cloud.core.domain;

public class SysCorporationRenew {
	private Integer id;//续费id
	private Integer deptsId;//公司id
	private Integer memberId;//操作用户id
	private String renewTime;//续费时间
	private String operTime;//操作时间
	private String endDate;//到期日期
	//---------------------------------
	private String deptNm;//公司名称
	private String memberNm;//用户名称
	
	
	
	public Integer getDeptsId() {
		return deptsId;
	}
	public void setDeptsId(Integer deptsId) {
		this.deptsId = deptsId;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
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
	public String getOperTime() {
		return operTime;
	}
	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}
	public String getRenewTime() {
		return renewTime;
	}
	public void setRenewTime(String renewTime) {
		this.renewTime = renewTime;
	}
	
	

}
