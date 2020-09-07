package com.qweib.cloud.core.domain;

public class SysDeptmempower {

	private Integer id;
	private Integer deptId;//部门id
	private Integer memberId;//成员id
	private String tp;//类型（1可见 2 不可见）
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getDeptId() {
		return deptId;
	}
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	
	
}
