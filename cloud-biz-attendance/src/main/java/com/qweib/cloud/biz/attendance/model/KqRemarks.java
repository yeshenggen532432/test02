package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqRemarks {
	private Integer id;
	private String kqDate;
	private String remarks;
	private Integer memberId;
	private Integer status;
	/////////////////////////////////
	private String memberNm;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getKqDate() {
		return kqDate;
	}
	public void setKqDate(String kqDate) {
		this.kqDate = kqDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
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
	

}
