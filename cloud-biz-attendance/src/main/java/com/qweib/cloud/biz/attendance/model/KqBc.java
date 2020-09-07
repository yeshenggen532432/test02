package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

public class KqBc {
	private Integer id;
	private String bcName;//班次时间
	private String bcCode;//班次编号
	private Integer lateMinute;//迟到多少分钟算迟到
	private Integer earlyMinute;//早退多少分钟算早退
	private Integer beforeMinute;//上班前多少分钟刷卡有效
	private Integer afterMinute;//下班后多少分钟刷卡有效
	private Integer bcType;//班次类型
	private String latitude;//纬度
	private String longitude;//经度
	private Integer areaLong;//范围
	private Integer outOf;//超出指定范围是否可签到0不可 1可以
	private Integer crossDay;//是否跨天 0不跨天 1跨天
	private Integer status;//是否有效0无效1有效
	private String remarks;
	private String address; 
	////////////////////////////////////////////
	private List<KqBcTimes> subList;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getBcName() {
		return bcName;
	}
	public void setBcName(String bcName) {
		this.bcName = bcName;
	}
	public String getBcCode() {
		return bcCode;
	}
	public void setBcCode(String bcCode) {
		this.bcCode = bcCode;
	}
	public Integer getLateMinute() {
		return lateMinute;
	}
	public void setLateMinute(Integer lateMinute) {
		this.lateMinute = lateMinute;
	}
	public Integer getEarlyMinute() {
		return earlyMinute;
	}
	public void setEarlyMinute(Integer earlyMinute) {
		this.earlyMinute = earlyMinute;
	}
	public Integer getBeforeMinute() {
		return beforeMinute;
	}
	public void setBeforeMinute(Integer beforeMinute) {
		this.beforeMinute = beforeMinute;
	}
	public Integer getAfterMinute() {
		return afterMinute;
	}
	public void setAfterMinute(Integer afterMinute) {
		this.afterMinute = afterMinute;
	}
	public Integer getBcType() {
		return bcType;
	}
	public void setBcType(Integer bcType) {
		this.bcType = bcType;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public Integer getAreaLong() {
		return areaLong;
	}
	public void setAreaLong(Integer areaLong) {
		this.areaLong = areaLong;
	}
	public Integer getOutOf() {
		return outOf;
	}
	public void setOutOf(Integer outOf) {
		this.outOf = outOf;
	}
	public Integer getCrossDay() {
		return crossDay;
	}
	public void setCrossDay(Integer crossDay) {
		this.crossDay = crossDay;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<KqBcTimes> getSubList() {
		return subList;
	}
	public void setSubList(List<KqBcTimes> subList) {
		this.subList = subList;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	

}
