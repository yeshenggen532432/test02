package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

public class KqRule {
	private Integer id;
	private String ruleName;
	private Integer ruleUnit;//0天 1周 2月
	private Integer days;//只有ruleUnit=0时有效
	private String remarks;
	private Integer status;
	private List<KqRuleDetail> subList;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getRuleName() {
		return ruleName;
	}
	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
	}
	public Integer getRuleUnit() {
		return ruleUnit;
	}
	public void setRuleUnit(Integer ruleUnit) {
		this.ruleUnit = ruleUnit;
	}
	public Integer getDays() {
		return days;
	}
	public void setDays(Integer days) {
		this.days = days;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<KqRuleDetail> getSubList() {
		return subList;
	}
	public void setSubList(List<KqRuleDetail> subList) {
		this.subList = subList;
	}
	

}
