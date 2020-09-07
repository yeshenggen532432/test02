package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqPb {
	private Integer id;
	private Integer memberId;
	private Integer bcId;
	private String bcDate;
	private String memberNm;
	private String bcName;
	private String sdate;
	private String edate;
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
	public Integer getBcId() {
		return bcId;
	}
	public void setBcId(Integer bcId) {
		this.bcId = bcId;
	}
	public String getBcDate() {
		return bcDate;
	}
	public void setBcDate(String bcDate) {
		this.bcDate = bcDate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBcName() {
		return bcName;
	}
	public void setBcName(String bcName) {
		this.bcName = bcName;
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
	

}
