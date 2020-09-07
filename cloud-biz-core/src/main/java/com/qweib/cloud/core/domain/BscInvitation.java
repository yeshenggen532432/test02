package com.qweib.cloud.core.domain;

public class BscInvitation {

	private Integer id;//自增id
	private Integer memberId;//邀请人
	private Integer receiveId;//接收人id
	private String tp;//1 邀请加入员工圈 3邀请加入公司 4 邀请加入部门
	private String content;//内容
	private String datasource;//数据库名称
	private Integer belongId;//公司或部门id或员工圈id
	private String intime;//邀请时间
	private String agree;// 是否同意 -1不同意 1 同意
	
	
	
	
	public String getAgree() {
		return agree;
	}
	public void setAgree(String agree) {
		this.agree = agree;
	}
	public String getIntime() {
		return intime;
	}
	public void setIntime(String intime) {
		this.intime = intime;
	}
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
	public Integer getReceiveId() {
		return receiveId;
	}
	public void setReceiveId(Integer receiveId) {
		this.receiveId = receiveId;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getDatasource() {
		return datasource;
	}
	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}
	public Integer getBelongId() {
		return belongId;
	}
	public void setBelongId(Integer belongId) {
		this.belongId = belongId;
	}
	
	
}
