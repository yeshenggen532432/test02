package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqChgBc {
	private Integer id;
	private String chgDate;
	private String fromDate;
	private String toDate;
	private Integer memberId;
	private Integer bcId1;
	private Integer bcId2;
	private String remarks;
	private String operator;
	private Integer status;
	//////////////////////////////////////
	private String memberNm;
	private String bcName1;
	private String bcName2;
	private String sdate;
	private String edate;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getChgDate() {
		return chgDate;
	}
	public void setChgDate(String chgDate) {
		this.chgDate = chgDate;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public Integer getBcId1() {
		return bcId1;
	}
	public void setBcId1(Integer bcId1) {
		this.bcId1 = bcId1;
	}
	public Integer getBcId2() {
		return bcId2;
	}
	public void setBcId2(Integer bcId2) {
		this.bcId2 = bcId2;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBcName1() {
		return bcName1;
	}
	public void setBcName1(String bcName1) {
		this.bcName1 = bcName1;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBcName2() {
		return bcName2;
	}
	public void setBcName2(String bcName2) {
		this.bcName2 = bcName2;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	

}
