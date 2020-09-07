package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.ArrayList;
import java.util.List;

/**
 * 说明：任务表模型
 * 
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
 */
public class SysTask {
	public static Integer STATUS_NO = 1; // 未完成
	public static Integer STATUS_YES = 2; // 完成
	public static Integer STATUS_DRAFT = 3;// 草稿
	public static Integer REMIND_YES = 1;// 已提醒
	public static Integer REMIND_NO = 0;// 未提醒

	private Integer id;
	private String taskTitle; // 任务标题
	private String createTime;//创建时间
	private String startTime; // 开始时间
	private String endTime; // 完成时间
	private String taskMemo; // 任务说明
	private Integer parentId; // 父任务ID
	private Integer createBy; // 创建人
	private Integer status; // 任务状态
	private Integer remind1; // 提醒1
	private Integer remind2; // 提醒2
	private Integer remind3; // 提醒3
	private Integer remind4; // 提醒4
	private Integer remindState1; // 提醒1是否已经提醒 
	private Integer remindState2; // 提醒2是否已经提醒
	private Integer remindState3; // 提醒3是否已经提醒
	private Integer remindState4; // 提醒4是否已经提醒
	private String actTime; // 实际完成时间
	private Integer percent; // 完成进度
	/** ******************************* */
	private Integer isovertime;//是否超时
	private Integer merberId;// 责任人ID
	private String memberNm;// 责任人
	private Integer complete;// 按时完成统计
	private Integer unfinished;// 超期完成
	private Integer totalnumber;// 总数
	private Integer timeout;// 超期未完成
	private Double ratio;// 超期未完成
	private Integer isMemberNm;// 是否责任人
	private Integer isSupervisor;// 是否关注人
	private String supervisor;// 关注人
	private Integer child;// 是否有子任务
	private String parentTitle;//父任务标题
	private String createName;//创建人
	private String memberIds;//责任人ID集合
	private String supervisorIds;//关注人ID集合
	public static Integer CHILE_NO = 0; // 没有
	public static Integer CHILE_YES = 1; // 有
	private String createByNm;//发布任务人名
	private String isAct;//0 不是关注 1 是关注状态
	private List<SysMemDTO> memList = new ArrayList<SysMemDTO>();
	private String pstartTime;//主任务的开始时间
	private String pendTime;//主任务的结束时间
	
	private String nm;//发布人
	
	
	
	@TableAnnotation(insertAble = false, updateAble = false)
	public String getNm() {
		return nm;
	}

	public void setNm(String nm) {
		this.nm = nm;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getPstartTime() {
		return pstartTime;
	}

	public void setPstartTime(String pstartTime) {
		this.pstartTime = pstartTime;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getPendTime() {
		return pendTime;
	}

	public void setPendTime(String pendTime) {
		this.pendTime = pendTime;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public List<SysMemDTO> getMemList() {
		return memList;
	}

	public void setMemList(List<SysMemDTO> memList) {
		this.memList = memList;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getIsAct() {
		return isAct;
	}

	public void setIsAct(String isAct) {
		this.isAct = isAct;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getCreateByNm() {
		return createByNm;
	}

	public void setCreateByNm(String createByNm) {
		this.createByNm = createByNm;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getIsovertime() {
		return isovertime;
	}

	public void setIsovertime(Integer isovertime) {
		this.isovertime = isovertime;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getMemberIds() {
		return memberIds;
	}
	
	public void setMemberIds(String memberIds) {
		this.memberIds = memberIds;
	}
	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getSupervisorIds() {
		return supervisorIds;
	}
	public void setSupervisorIds(String supervisorIds) {
		this.supervisorIds = supervisorIds;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getParentTitle() {
		return parentTitle;
	}

	public void setParentTitle(String parentTitle) {
		this.parentTitle = parentTitle;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Double getRatio() {
		return ratio;
	}

	public void setRatio(Double ratio) {
		this.ratio = ratio;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getTotalnumber() {
		return totalnumber;
	}

	public void setTotalnumber(Integer totalnumber) {
		this.totalnumber = totalnumber;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getComplete() {
		return complete;
	}

	public void setComplete(Integer complete) {
		this.complete = complete;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getUnfinished() {
		return unfinished;
	}

	public void setUnfinished(Integer unfinished) {
		this.unfinished = unfinished;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getTimeout() {
		return timeout;
	}

	public void setTimeout(Integer timeout) {
		this.timeout = timeout;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getIsSupervisor() {
		return isSupervisor;
	}

	public void setIsSupervisor(Integer isSupervisor) {
		this.isSupervisor = isSupervisor;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getMerberId() {
		return merberId;
	}

	public void setMerberId(Integer merberId) {
		this.merberId = merberId;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getIsMemberNm() {
		return isMemberNm;
	}

	public void setIsMemberNm(Integer isMemberNm) {
		this.isMemberNm = isMemberNm;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getSupervisor() {
		return supervisor;
	}

	public void setSupervisor(String supervisor) {
		this.supervisor = supervisor;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	@TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
	public Integer getChild() {
		return child;
	}

	public void setChild(Integer child) {
		this.child = child;
	}

	/** ******************************* */
	@TableAnnotation(insertAble = false, updateAble = false)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getTaskTitle() {
		return taskTitle;
	}

	public void setTaskTitle(String taskTitle) {
		this.taskTitle = taskTitle;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getTaskMemo() {
		return taskMemo;
	}

	public void setTaskMemo(String taskMemo) {
		this.taskMemo = taskMemo;
	}

	public Integer getParentId() {
		return parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}

	public Integer getCreateBy() {
		return createBy;
	}

	public void setCreateBy(Integer createBy) {
		this.createBy = createBy;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getRemind1() {
		return remind1;
	}

	public void setRemind1(Integer remind1) {
		this.remind1 = remind1;
	}

	public Integer getRemind2() {
		return remind2;
	}

	public void setRemind2(Integer remind2) {
		this.remind2 = remind2;
	}

	public Integer getRemind3() {
		return remind3;
	}

	public void setRemind3(Integer remind3) {
		this.remind3 = remind3;
	}

	public Integer getRemind4() {
		return remind4;
	}

	public void setRemind4(Integer remind4) {
		this.remind4 = remind4;
	}

	public String getActTime() {
		return actTime;
	}

	public void setActTime(String actTime) {
		this.actTime = actTime;
	}

	public Integer getPercent() {
		return percent;
	}

	public void setPercent(Integer percent) {
		this.percent = percent;
	}

	public Integer getRemindState1() {
		return remindState1;
	}

	public void setRemindState1(Integer remindState1) {
		this.remindState1 = remindState1;
	}

	public Integer getRemindState2() {
		return remindState2;
	}

	public void setRemindState2(Integer remindState2) {
		this.remindState2 = remindState2;
	}

	public Integer getRemindState3() {
		return remindState3;
	}

	public void setRemindState3(Integer remindState3) {
		this.remindState3 = remindState3;
	}

	public Integer getRemindState4() {
		return remindState4;
	}

	public void setRemindState4(Integer remindState4) {
		this.remindState4 = remindState4;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	
	

}
