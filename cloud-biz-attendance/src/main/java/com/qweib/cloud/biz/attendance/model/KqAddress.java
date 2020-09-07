package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqAddress {
	private Integer id;
	private String type;//用来区分：考勤地址是否是独立的kq_bc_address表还是从班次kq_bc中获取的地址
	private String address;
	private String address1;//旧地址
	private String longitude;
	private String latitude;

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}
