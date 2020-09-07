package com.qweib.cloud.core.domain;
/**
 *说明：轨迹信息
 *@创建：作者:llp		创建时间：2016-3-3
 *@修改历史：
 *		[序号](llp	2016-3-3)<修改说明>
 */
public class MapGjMd {
	private Integer userId;//用户id
	private String userNm;//名称
	private String userTel;//电话
	private String userHead;//头像
	private String memberJob;// 职位
	private String address;//最新轨迹地址
	private String times;//最新轨迹时间
	private String location;//经纬度
	private String zt;//运动；静止；异常
	private String ys;//颜色
	private String locationFrom;
	private String os;
	private String heartbeatSpan;
	private String speed;
	private String stayTime;
	private String azimuth;
	private String workStatus;
	private String workingDistance;
	private String checkInTime;
	private String visitCheckInTime;
	
	
	public String getMemberJob() {
		return memberJob;
	}
	public void setMemberJob(String memberJob) {
		this.memberJob = memberJob;
	}
	public String getAzimuth() {
		return azimuth;
	}
	public void setAzimuth(String azimuth) {
		this.azimuth = azimuth;
	}
	public String getCheckInTime() {
		return checkInTime;
	}
	public void setCheckInTime(String checkInTime) {
		this.checkInTime = checkInTime;
	}
	public String getHeartbeatSpan() {
		return heartbeatSpan;
	}
	public void setHeartbeatSpan(String heartbeatSpan) {
		this.heartbeatSpan = heartbeatSpan;
	}
	public String getLocationFrom() {
		return locationFrom;
	}
	public void setLocationFrom(String locationFrom) {
		this.locationFrom = locationFrom;
	}
	public String getOs() {
		return os;
	}
	public void setOs(String os) {
		this.os = os;
	}
	public String getSpeed() {
		return speed;
	}
	public void setSpeed(String speed) {
		this.speed = speed;
	}
	public String getStayTime() {
		return stayTime;
	}
	public void setStayTime(String stayTime) {
		this.stayTime = stayTime;
	}
	public String getVisitCheckInTime() {
		return visitCheckInTime;
	}
	public void setVisitCheckInTime(String visitCheckInTime) {
		this.visitCheckInTime = visitCheckInTime;
	}
	public String getWorkingDistance() {
		return workingDistance;
	}
	public void setWorkingDistance(String workingDistance) {
		this.workingDistance = workingDistance;
	}
	public String getWorkStatus() {
		return workStatus;
	}
	public void setWorkStatus(String workStatus) {
		this.workStatus = workStatus;
	}
	public String getYs() {
		return ys;
	}
	public void setYs(String ys) {
		this.ys = ys;
	}
	public String getZt() {
		return zt;
	}
	public void setZt(String zt) {
		this.zt = zt;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getUserHead() {
		return userHead;
	}
	public void setUserHead(String userHead) {
		this.userHead = userHead;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getTimes() {
		return times;
	}
	public void setTimes(String times) {
		this.times = times;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserTel() {
		return userTel;
	}
	public void setUserTel(String userTel) {
		this.userTel = userTel;
	}
	
	

}
