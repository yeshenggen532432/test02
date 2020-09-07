package com.qweib.cloud.core.domain;
/**
 *基础主题@表
 */
public class BscAita {
	   private Integer aitaId;//自增id
	   private Integer topicId;//所属主题
	   private Integer memberId;//@人
	public Integer getAitaId() {
		return aitaId;
	}
	public void setAitaId(Integer aitaId) {
		this.aitaId = aitaId;
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
	public BscAita(Integer topicId, Integer memberId) {
		super();
		this.topicId = topicId;
		this.memberId = memberId;
	}
	   
	
	   
}
