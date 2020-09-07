package com.qweib.cloud.core.domain;
/**
 * 签到列表用
 * @author yyp
 *
 */
public class SysCheckInConform {

	private String checkTime;
	private String locationup;
	private Integer upid;
	private String locationdown;
	private Integer downid;
	private String tp;//1-1 上班签到  1-2 下班签到 1 签到
	
	
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public String getCheckTime() {
		return checkTime;
	}
	public void setCheckTime(String checkTime) {
		this.checkTime = checkTime;
	}
	public String getLocationup() {
		return locationup;
	}
	public void setLocationup(String locationup) {
		this.locationup = locationup;
	}
	public Integer getUpid() {
		return upid;
	}
	public void setUpid(Integer upid) {
		this.upid = upid;
	}
	public String getLocationdown() {
		return locationdown;
	}
	public void setLocationdown(String locationdown) {
		this.locationdown = locationdown;
	}
	public Integer getDownid() {
		return downid;
	}
	public void setDownid(Integer downid) {
		this.downid = downid;
	}
	
	
}
