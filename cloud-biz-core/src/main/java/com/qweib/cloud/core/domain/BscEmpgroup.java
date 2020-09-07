package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 员工圈实体类
 */
public class BscEmpgroup {
	private Integer groupId;
	private String groupNm;
	private String groupDesc;// 圈介绍
	private Integer memberId;// 创建人
	private String groupHead;// 圈头像
	private String groupBg;// 圈背景图
	private String creatime;// 创建时间
	private Integer groupNum;// 圈成员数
	private String thirdGroupId;// 关联第三方群id
	private String leadShield;//领导屏蔽 1 屏蔽 2 不屏蔽
	private String datasource;//数据库名称
	private String isOpen; //是否公开圈 1 是2 不是
	/*************************************/
	
	
	
	private String memberNm;//创建人名称
	
	

	public String getIsOpen() {
		return isOpen;
	}

	public void setIsOpen(String isOpen) {
		this.isOpen = isOpen;
	}

	@TableAnnotation(insertAble=false,updateAble=false,nullToUpdate=false)
	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	/*************************************/
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getGroupId() {
		return groupId;
	}

	public void setGroupId(Integer groupId) {
		this.groupId = groupId;
	}

	public String getGroupNm() {
		return groupNm;
	}

	public void setGroupNm(String groupNm) {
		this.groupNm = groupNm;
	}

	public String getGroupDesc() {
		return groupDesc;
	}

	public void setGroupDesc(String groupDesc) {
		this.groupDesc = groupDesc;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public String getGroupHead() {
		return groupHead;
	}

	public void setGroupHead(String groupHead) {
		this.groupHead = groupHead;
	}

	public String getGroupBg() {
		return groupBg;
	}

	public void setGroupBg(String groupBg) {
		this.groupBg = groupBg;
	}

	public String getCreatime() {
		return creatime;
	}

	public void setCreatime(String creatime) {
		this.creatime = creatime;
	}

	

	public Integer getGroupNum() {
		return groupNum;
	}

	public void setGroupNum(Integer groupNum) {
		this.groupNum = groupNum;
	}

	public String getThirdGroupId() {
		return thirdGroupId;
	}

	public void setThirdGroupId(String thirdGroupId) {
		this.thirdGroupId = thirdGroupId;
	}

	public String getLeadShield() {
		return leadShield;
	}

	public void setLeadShield(String leadShield) {
		this.leadShield = leadShield;
	}

	public String getDatasource() {
		return datasource;
	}

	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}

	

	
}
