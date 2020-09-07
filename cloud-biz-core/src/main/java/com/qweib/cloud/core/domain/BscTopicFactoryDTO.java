package com.qweib.cloud.core.domain;

import java.util.List;

public class BscTopicFactoryDTO {
	private Integer topicId;
	private Integer memberId;
	private String memberHead;
	private String memberNm;
	private String topicTitle;
	private String topicTime;
	private String topiContent;
	private String url;
	private String tpType;//0 员工圈话题 1 真心话话题 2 外部来源(发帖)
	
	private List<BscTopicPic> picList;
	private List<BscTopicPraise> praiseList;
	private List<BscTopicComment> commentList;
	
	///////
	private String role;
	private Integer groupId;
	private String groupNm;
	
	
	
	
	
	public String getGroupNm() {
		return groupNm;
	}
	public void setGroupNm(String groupNm) {
		this.groupNm = groupNm;
	}
	public String getTpType() {
		return tpType;
	}
	public void setTpType(String tpType) {
		this.tpType = tpType;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Integer getGroupId() {
		return groupId;
	}
	public void setGroupId(Integer groupId) {
		this.groupId = groupId;
	}
	public Integer getTopicId() {
		return topicId;
	}
	public void setTopicId(Integer topicId) {
		this.topicId = topicId;
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
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getTopicTitle() {
		return topicTitle;
	}
	public void setTopicTitle(String topicTitle) {
		this.topicTitle = topicTitle;
	}
	public String getTopicTime() {
		return topicTime;
	}
	public void setTopicTime(String topicTime) {
		this.topicTime = topicTime;
	}
	public List<BscTopicPic> getPicList() {
		return picList;
	}
	public void setPicList(List<BscTopicPic> picList) {
		this.picList = picList;
	}
	public List<BscTopicPraise> getPraiseList() {
		return praiseList;
	}
	public void setPraiseList(List<BscTopicPraise> praiseList) {
		this.praiseList = praiseList;
	}
	public List<BscTopicComment> getCommentList() {
		return commentList;
	}
	public void setCommentList(List<BscTopicComment> commentList) {
		this.commentList = commentList;
	}
	public String getTopiContent() {
		return topiContent;
	}
	public void setTopiContent(String topiContent) {
		this.topiContent = topiContent;
	}

	
	
}
