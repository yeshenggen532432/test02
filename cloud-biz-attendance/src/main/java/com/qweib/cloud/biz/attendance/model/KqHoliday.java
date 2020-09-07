package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqHoliday {
	private Integer id;
	private String dayName;
	private String startDate;
	private String endDate;
	private String year;
	private String sdate;
	private String edate;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getDayName() {
		return dayName;
	}
	public void setDayName(String dayName) {
		this.dayName = dayName;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	

}
