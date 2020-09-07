package com.qweib.cloud.core.domain;

public class SysBforderXls {
	private Integer orderId;//订单id
	private String orderNo;//订单号
	private String pszd;//配送指定（公司直送，转二批配送）
	private String oddate;//日期
	private String odtime;//时间
	private String shTime;//送货时间
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	private String wareNm;//商品名称
	private String xsTp;//销售类型 
	private String wareDw;//单位
	private String wareGg;//规格
	private Integer wareNum;//数量
	private Double wareDj;//单价
	private Double wareZj;//总价
	private Double zje;//总金额
	private Double zdzk;//整单折扣
	private Double cjje;//成交金额
	private Integer counts;//数量
	private String orderZt;//订单状态（审核，未审核)
	private String remo;//备注
	
	
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public String getOrderZt() {
		return orderZt;
	}
	public void setOrderZt(String orderZt) {
		this.orderZt = orderZt;
	}
	public Integer getCounts() {
		return counts;
	}
	public void setCounts(Integer counts) {
		this.counts = counts;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}
	public Double getCjje() {
		return cjje;
	}
	public void setCjje(Double cjje) {
		this.cjje = cjje;
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
	public String getOddate() {
		return oddate;
	}
	public void setOddate(String oddate) {
		this.oddate = oddate;
	}
	public String getOdtime() {
		return odtime;
	}
	public void setOdtime(String odtime) {
		this.odtime = odtime;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getPszd() {
		return pszd;
	}
	public void setPszd(String pszd) {
		this.pszd = pszd;
	}
	public String getShTime() {
		return shTime;
	}
	public void setShTime(String shTime) {
		this.shTime = shTime;
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
	public String getWareGg() {
		return wareGg;
	}
	public void setWareGg(String wareGg) {
		this.wareGg = wareGg;
	}
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public Integer getWareNum() {
		return wareNum;
	}
	public void setWareNum(Integer wareNum) {
		this.wareNum = wareNum;
	}
	public Double getWareZj() {
		return wareZj;
	}
	public void setWareZj(Double wareZj) {
		this.wareZj = wareZj;
	}
	public String getXsTp() {
		return xsTp;
	}
	public void setXsTp(String xsTp) {
		this.xsTp = xsTp;
	}
	public Double getZdzk() {
		return zdzk;
	}
	public void setZdzk(Double zdzk) {
		this.zdzk = zdzk;
	}
	public Double getZje() {
		return zje;
	}
	public void setZje(Double zje) {
		this.zje = zje;
	}
	
	
}
