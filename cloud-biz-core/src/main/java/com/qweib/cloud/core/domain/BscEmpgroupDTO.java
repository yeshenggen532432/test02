package com.qweib.cloud.core.domain;

import java.util.List;

/**
 * @author YYP
 *
 */
public class BscEmpgroupDTO {

	   private Integer groupId;
	   private String groupNm;
	   private String groupDesc;//圈介绍
	   private String creatime;//创建时间
	   private String groupNum;// 圈成员数
	   private String groupHead;
	   
	   private String remindFlag;//1 不提醒' 2 自动提醒
	   private String topFlag;//1 不置顶,2 置顶
	   private String leadShield;//领导屏蔽 1 屏蔽 2 不屏蔽
	   

	   private Integer memberId;//创建人
	   private String memberHead;//创建人头像
	   private String memberNm;
	   
	   
	   private List<BscEmpGroupMember> adminList;//管理员（多个）
	   private List<BscEmpGroupMember> memList;//圈成员
	   private String inGroup;//是否在圈成员（0 否，1 是）
	   
	   private String role;//圈角色
	   private String isOpen;//是否公开
	   
	   
	   
	
	public String getIsOpen() {
		return isOpen;
	}
	public void setIsOpen(String isOpen) {
		this.isOpen = isOpen;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getInGroup() {
		return inGroup;
	}
	public void setInGroup(String inGroup) {
		this.inGroup = inGroup;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public List<BscEmpGroupMember> getAdminList() {
		return adminList;
	}
	public void setAdminList(List<BscEmpGroupMember> adminList) {
		this.adminList = adminList;
	}
	public List<BscEmpGroupMember> getMemList() {
		return memList;
	}
	public void setMemList(List<BscEmpGroupMember> memList) {
		this.memList = memList;
	}
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
	public String getCreatime() {
		return creatime;
	}
	public void setCreatime(String creatime) {
		this.creatime = creatime;
	}
	
	
	public String getGroupNum() {
		return groupNum;
	}
	public void setGroupNum(String groupNum) {
		this.groupNum = groupNum;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getMemberHead() {
		return memberHead;
	}
	public void setMemberHead(String memberHead) {
		this.memberHead = memberHead;
	}
	public String getGroupHead() {
		return groupHead;
	}
	public void setGroupHead(String groupHead) {
		this.groupHead = groupHead;
	}
	
	
	public String getTopFlag() {
		return topFlag;
	}
	public void setTopFlag(String topFlag) {
		this.topFlag = topFlag;
	}
	public String getRemindFlag() {
		return remindFlag;
	}
	public void setRemindFlag(String remindFlag) {
		this.remindFlag = remindFlag;
	}
	public String getLeadShield() {
		return leadShield;
	}
	public void setLeadShield(String leadShield) {
		this.leadShield = leadShield;
	}

	
	   
	   
	   
}
