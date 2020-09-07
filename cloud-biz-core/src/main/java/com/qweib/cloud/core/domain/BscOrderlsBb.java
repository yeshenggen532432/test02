package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

//旅行社订单结算表
public class BscOrderlsBb {
	private Integer id;//订单结算id
	private Integer orderId;//订单id
	private String orderNo;//订单号
	private Integer cid;//客户id
	private Integer mid;//业务员id
	private String odate;//日期
	private Double awJg;//其他啤酒
	private Double bwJg;//小商品
	private Double cwJg;//化妆品
	private Double dwJg;//衣服燕窝
	private Double ewJg;//酵素
	private Double fwJg;//乳液
	private Double allJg;//合计金额
	private Double zhJg;//总回
	private Double lsJg;//旅社
	private Double dyJg;//导游
	private Double sjJg;//司机
	private Double qpJg;//全陪
	private String isJs;//结算状态（结算，未结算）
   //------------------------不在数据库--------------------
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	private String sdate;//开始时间
	private String edate;//结束时间
	private String database;//数据库
	private String isJs2;
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getIsJs2() {
		return isJs2;
	}
	public void setIsJs2(String isJs2) {
		this.isJs2 = isJs2;
	}
	@TableAnnotation(updateAble=false)
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getIsJs() {
		return isJs;
	}
	public void setIsJs(String isJs) {
		this.isJs = isJs;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	public Double getAllJg() {
		return allJg;
	}
	public void setAllJg(Double allJg) {
		this.allJg = allJg;
	}
	public Double getAwJg() {
		return awJg;
	}
	public void setAwJg(Double awJg) {
		this.awJg = awJg;
	}
	public Double getBwJg() {
		return bwJg;
	}
	public void setBwJg(Double bwJg) {
		this.bwJg = bwJg;
	}
	@TableAnnotation(updateAble=false)
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public Double getCwJg() {
		return cwJg;
	}
	public void setCwJg(Double cwJg) {
		this.cwJg = cwJg;
	}
	public Double getDwJg() {
		return dwJg;
	}
	public void setDwJg(Double dwJg) {
		this.dwJg = dwJg;
	}
	public Double getDyJg() {
		return dyJg;
	}
	public void setDyJg(Double dyJg) {
		this.dyJg = dyJg;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	public Double getEwJg() {
		return ewJg;
	}
	public void setEwJg(Double ewJg) {
		this.ewJg = ewJg;
	}
	public Double getFwJg() {
		return fwJg;
	}
	public void setFwJg(Double fwJg) {
		this.fwJg = fwJg;
	}
	@TableAnnotation(updateAble=false)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public Double getLsJg() {
		return lsJg;
	}
	public void setLsJg(Double lsJg) {
		this.lsJg = lsJg;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(updateAble=false)
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	@TableAnnotation(updateAble=false)
	public String getOdate() {
		return odate;
	}
	public void setOdate(String odate) {
		this.odate = odate;
	}
	@TableAnnotation(updateAble=false)
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}
	public Double getQpJg() {
		return qpJg;
	}
	public void setQpJg(Double qpJg) {
		this.qpJg = qpJg;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	public Double getSjJg() {
		return sjJg;
	}
	public void setSjJg(Double sjJg) {
		this.sjJg = sjJg;
	}
	public Double getZhJg() {
		return zhJg;
	}
	public void setZhJg(Double zhJg) {
		this.zhJg = zhJg;
	}
	
	

}
