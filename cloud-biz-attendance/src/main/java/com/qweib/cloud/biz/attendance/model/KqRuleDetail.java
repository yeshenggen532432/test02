package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqRuleDetail {
	private Integer id;
	private Integer ruleId;
	private Integer seqNo;
	private Integer bcId;
	private String dayName;
	///////////////////////////////
	private String bcName;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getRuleId() {
		return ruleId;
	}
	public void setRuleId(Integer ruleId) {
		this.ruleId = ruleId;
	}
	public Integer getSeqNo() {
		return seqNo;
	}
	public void setSeqNo(Integer seqNo) {
		this.seqNo = seqNo;
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
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDayName() {
		return dayName;
	}
	public void setDayName(String dayName) {
		this.dayName = dayName;
	}
	

}
