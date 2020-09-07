package com.qweib.cloud.biz.attendance.model;

import java.math.BigDecimal;

public class KqBanDetail {
	private Integer id;
	private Integer memberId;
	private Integer mastId;
	private String kqDate;
	private BigDecimal hours;
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
	public Integer getMastId() {
		return mastId;
	}
	public void setMastId(Integer mastId) {
		this.mastId = mastId;
	}
	public String getKqDate() {
		return kqDate;
	}
	public void setKqDate(String kqDate) {
		this.kqDate = kqDate;
	}
	public BigDecimal getHours() {
		return hours;
	}
	public void setHours(BigDecimal hours) {
		this.hours = hours;
	}
	

}
