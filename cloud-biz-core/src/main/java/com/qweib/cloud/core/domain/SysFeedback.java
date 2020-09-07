package com.qweib.cloud.core.domain;

public class SysFeedback {
	private Integer feedId;
	private String feedType;
	private String feedContent;
	private Integer memberId;
	private String feedTime;
	private String plat;
	public Integer getFeedId() {
		return feedId;
	}
	public void setFeedId(Integer feedId) {
		this.feedId = feedId;
	}
	public String getFeedType() {
		return feedType;
	}
	public void setFeedType(String feedType) {
		this.feedType = feedType;
	}
	public String getFeedContent() {
		return feedContent;
	}
	public void setFeedContent(String feedContent) {
		this.feedContent = feedContent;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getFeedTime() {
		return feedTime;
	}
	public void setFeedTime(String feedTime) {
		this.feedTime = feedTime;
	}
	public String getPlat() {
		return plat;
	}
	public void setPlat(String plat) {
		this.plat = plat;
	}
	
	
	

}
