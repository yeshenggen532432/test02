package com.qweib.cloud.core.domain;

public class SearchModel {

	private Integer belongId;//各个id
	private String headUrl;//各个头像
	private String nm;//各个名称
	private String tp;//1 成员 2 公司 3 部门 4 员工圈
	private Integer whetherIn;//是否好友或是否部门成员 1 是 2 不是 是否在员工圈内 0(不在)其他为在改圈的角色
	private String datasource;//数据库名称 （员工圈时表示是否公开）
	public Integer getBelongId() {
		return belongId;
	}
	public void setBelongId(Integer belongId) {
		this.belongId = belongId;
	}
	public String getNm() {
		return nm;
	}
	public void setNm(String nm) {
		this.nm = nm;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public String getHeadUrl() {
		return headUrl;
	}
	public void setHeadUrl(String headUrl) {
		this.headUrl = headUrl;
	}
	public Integer getWhetherIn() {
		return whetherIn;
	}
	public void setWhetherIn(Integer whetherIn) {
		this.whetherIn = whetherIn;
	}
	public String getDatasource() {
		return datasource;
	}
	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}
	
	
	
	
	
	
	
}
