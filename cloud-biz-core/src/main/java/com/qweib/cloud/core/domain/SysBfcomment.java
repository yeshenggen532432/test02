package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.ArrayList;
import java.util.List;


public class SysBfcomment {
   private Integer commentId;//评论id
   private Integer bfId;//所属话题
   private Integer memberId;//评论人
   private String commentTime;//评论时间
   private String content;//评论内容
   private Integer belongId;//回复的对象id 0 为评论 其他为回复的对应评论id
   private Integer rcId;//被回复人id
   private String rcNm;//被回复人用户名
   private Integer voiceTime;//语音时长
    /////不在数据库//////
   private String memberNm;
   private List<SysBfcomment> rcList = new ArrayList<SysBfcomment>();
   
   
	public Integer getVoiceTime() {
	return voiceTime;
	}
	public void setVoiceTime(Integer voiceTime) {
		this.voiceTime = voiceTime;
	}
	public Integer getCommentId() {
		return commentId;
	}
	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}
	public Integer getBfId() {
		return bfId;
	}
	public void setBfId(Integer bfId) {
		this.bfId = bfId;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getCommentTime() {
		return commentTime;
	}
	public void setCommentTime(String commentTime) {
		this.commentTime = commentTime;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getBelongId() {
		return belongId;
	}
	public void setBelongId(Integer belongId) {
		this.belongId = belongId;
	}
	public Integer getRcId() {
		return rcId;
	}
	public void setRcId(Integer rcId) {
		this.rcId = rcId;
	}
	public String getRcNm() {
		return rcNm;
	}
	public void setRcNm(String rcNm) {
		this.rcNm = rcNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysBfcomment> getRcList() {
		return rcList;
	}
	public void setRcList(List<SysBfcomment> rcList) {
		this.rcList = rcList;
	}
	   
	   
	   
}
