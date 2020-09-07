package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class SysAutoPrice {
	private Integer id;//
	private Integer autoId;
	private Integer wareId;
	private String price;
	private String status;
	private String wareNm;

	private String autoCode;
	private String autoName;

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getAutoId() {
		return autoId;
	}
	public void setAutoId(Integer autoId) {
		this.autoId = autoId;
	}
	public Integer getWareId() {
		return wareId;
	}
	public void setWareId(Integer wareId) {
		this.wareId = wareId;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getAutoCode() { return autoCode; }

	public void setAutoCode(String autoCode) { this.autoCode = autoCode; }
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getAutoName() { return autoName; }
	public void setAutoName(String autoName) { this.autoName = autoName; }
}
