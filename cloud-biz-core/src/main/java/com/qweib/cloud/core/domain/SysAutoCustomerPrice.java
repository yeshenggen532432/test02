package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class SysAutoCustomerPrice {
	private Integer id;//
	private Integer autoId;
	private Integer wareId;
	private Integer customerId;
	private String price;
	private String status;

	private String customerIds;

	private String wareIds;

	private String wareNm;
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
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getCustomerIds() { return customerIds; }

	public void setCustomerIds(String customerIds) { this.customerIds = customerIds; }

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareIds() { return wareIds; }

	public void setWareIds(String wareIds) { this.wareIds = wareIds; }
}
