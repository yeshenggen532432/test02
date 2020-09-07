package com.qweib.cloud.core.domain;
//产品订单统计表
public class BiaoCpddtj {
	private String wareNm;//商品名称
	private String xsTp;//销售类型
	private String wareDw;//单位
	private Double nums;//订单数量
	private Double wareDj;//单价
	private Double zjs;//订单金额
	//--------------------
	private String stime;//开始时间
	private String etime;//结束时间
	private String khNm;//客户名称
	private String memberNm;//业务名称
	private String pszd;//配送指定（公司直送，转二批配送）
	private String tp;//1所有，2部门，3自己
	private String str;//用户id组
	
	
	public String getStr() {
		return str;
	}
	public void setStr(String str) {
		this.str = str;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public String getPszd() {
		return pszd;
	}
	public void setPszd(String pszd) {
		this.pszd = pszd;
	}
	public String getEtime() {
		return etime;
	}
	public void setEtime(String etime) {
		this.etime = etime;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public Double getNums() {
		return nums;
	}
	public void setNums(Double nums) {
		this.nums = nums;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	public Double getWareDj() {
		return wareDj;
	}
	public void setWareDj(Double wareDj) {
		this.wareDj = wareDj;
	}
	public String getWareDw() {
		return wareDw;
	}
	public void setWareDw(String wareDw) {
		this.wareDw = wareDw;
	}
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public String getXsTp() {
		return xsTp;
	}
	public void setXsTp(String xsTp) {
		this.xsTp = xsTp;
	}
	public Double getZjs() {
		return zjs;
	}
	public void setZjs(Double zjs) {
		this.zjs = zjs;
	}
	
	
}
