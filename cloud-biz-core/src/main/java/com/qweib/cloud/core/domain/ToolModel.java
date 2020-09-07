package com.qweib.cloud.core.domain;

public class ToolModel {
	private String wareNm;//商品名称
	private Integer nums;//数量统计
	private Double zjs;//数量金额
	//--------------------------------
	private String khNm;//客户名称
	private String memberNm;
	private String orderNo;
	private Double allJg;
	private Double zhJg;
	
	
	public Double getAllJg() {
		return allJg;
	}
	public void setAllJg(Double allJg) {
		this.allJg = allJg;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public Double getZhJg() {
		return zhJg;
	}
	public void setZhJg(Double zhJg) {
		this.zhJg = zhJg;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public Double getZjs() {
		return zjs;
	}
	public void setZjs(Double zjs) {
		this.zjs = zjs;
	}
	public Integer getNums() {
		return nums;
	}
	public void setNums(Integer nums) {
		this.nums = nums;
	}
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	
	
}
