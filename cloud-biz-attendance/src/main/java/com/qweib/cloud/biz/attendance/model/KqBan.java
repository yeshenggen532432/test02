package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.Date;

public class KqBan {
	private Integer id;
	private Integer memberId;
	private String banNm;
	private String startTime;
	private String endTime;
	private BigDecimal days;
	private BigDecimal hours;
	private String remarks;
	private Date banDate;
	private String operator;
	private Integer status;
	private Integer bcId;
	///////////////////////////////////////
	private String memberNm;
	private Integer branchId;
	private String sdate;
	private String edate;
	private String endTimeStr;
	private String banDateStr;
	private String bcName;
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
	public String getBanNm() {
		return banNm;
	}
	public void setBanNm(String banNm) {
		this.banNm = banNm;
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
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Date getBanDate() {
		return banDate;
	}
	public void setBanDate(Date banDate) {
		this.banDate = banDate;
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
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEndTimeStr() {
		return endTimeStr;
	}
	public void setEndTimeStr(String endTimeStr) {
		this.endTimeStr = endTimeStr;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBanDateStr() {
		return banDateStr;
	}
	public void setBanDateStr(String banDateStr) {
		this.banDateStr = banDateStr;
	}
	public Integer getBcId() {
		return bcId;
	}
	public void setBcId(Integer bcId) {
		this.bcId = bcId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBcName() {
		return bcName;
	}
	public void setBcName(String bcName) {
		this.bcName = bcName;
	}
	

}
