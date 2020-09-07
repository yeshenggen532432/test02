package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.Date;

public class KqJia {
	private Integer id;
	private Integer memberId;
	private String jiaNm;
	private String startTime;
	private String endTime;
	private BigDecimal days;
	private BigDecimal hours;
	private Integer status;
	private Date jiaDate;
	private String operator;
	private String remarks;
	///////////////////////////////////////////////
	private String memberNm;
	private Integer branchId;
	private String sdate;
	private String edate;
	private String jiaDateStr;
	
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
	public String getJiaNm() {
		return jiaNm;
	}
	public void setJiaNm(String jiaNm) {
		this.jiaNm = jiaNm;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public BigDecimal getDays() {
		return days;
	}
	public void setDays(BigDecimal days) {
		this.days = days;
	}
	public BigDecimal getHours() {
		return hours;
	}
	public void setHours(BigDecimal hours) {
		this.hours = hours;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Date getJiaDate() {
		return jiaDate;
	}
	public void setJiaDate(Date jiaDate) {
		this.jiaDate = jiaDate;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getBranchId() {
		return branchId;
	}
	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getJiaDateStr() {
		return jiaDateStr;
	}
	public void setJiaDateStr(String jiaDateStr) {
		this.jiaDateStr = jiaDateStr;
	}
	
	

}
