package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqEmpRule {
	private Integer id;
	private Integer memberId;
	private Integer ruleId;
	private String memberNm;
	private String memberMobile;
	private String ruleName;
	private Integer branchId;
	private Integer memberUse;
	////////////////////////////////////////
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
	public Integer getRuleId() {
		return ruleId;
	}
	public void setRuleId(Integer ruleId) {
		this.ruleId = ruleId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberMobile() {
		return memberMobile;
	}
	public void setMemberMobile(String memberMobile) {
		this.memberMobile = memberMobile;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getRuleName() {
		return ruleName;
	}
	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
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
	public Integer getMemberUse() {
		return memberUse;
	}
	public void setMemberUse(Integer memberUse) {
		this.memberUse = memberUse;
	}
	

}
