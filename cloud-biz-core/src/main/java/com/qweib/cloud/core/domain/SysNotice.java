package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 公告
 * @author guojp
 *
 */
public class SysNotice {
	/**
	 * 通知ID
	 */
	private Integer noticeId;
	/**
	 * 发表人
	 */
	private Integer memberId;
	/**
	 * 标题
	 */
	private String noticeTitle;
	/**
	 * 通知类型 1系统公告 2企业公告3园区公告 4 购划算
	 */
	private String noticeTp;
	/**
	 * 通知内容
	 */
	private String noticeContent;
	/**
	 * 通知时间
	 */
	private String noticeTime;
	/**
	 * 是否推送 1:是 2：否
	 */
	private String isPush;
	/**
	 * 数据库名称
	 */
	private String datasource;
	/**********页面显示***************/
	/**
	 * 开始时间
	 */
	private String startTime;
	/**
	 * 结束时间
	 */
	private String endTime;
	/**
	 * 会员名称
	 */
	private String memberNm;
	private String noticePic;//公告标题图
	/**********页面显示***************/
	public Integer getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getNoticeTitle() {
		return noticeTitle;
	}
	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}
	public String getNoticeTp() {
		return noticeTp;
	}
	public void setNoticeTp(String noticeTp) {
		this.noticeTp = noticeTp;
	}
	public String getNoticeContent() {
		return noticeContent;
	}
	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}
	public String getNoticeTime() {
		return noticeTime;
	}
	public void setNoticeTime(String noticeTime) {
		this.noticeTime = noticeTime;
	}
	public String getIsPush() {
		return isPush;
	}
	public void setIsPush(String isPush) {
		this.isPush = isPush;
	}
	@TableAnnotation(updateAble = false)
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	@TableAnnotation(updateAble = false)
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	@TableAnnotation(updateAble = false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getDatasource() {
		return datasource;
	}
	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}
	public String getNoticePic() {
		return noticePic;
	}
	public void setNoticePic(String noticePic) {
		this.noticePic = noticePic;
	}
	
}
