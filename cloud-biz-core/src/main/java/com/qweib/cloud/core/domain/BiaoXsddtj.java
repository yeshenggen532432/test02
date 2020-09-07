package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

//销售订单统计表
public class BiaoXsddtj {
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	private String orderIds;//订单id组
	private List<SysBforderDetail> list1;//订单商品集合
	private Double zje;//总金额
	//-----------------------
	private String stime;//开始时间
	private String etime;//结束时间
	private String orderZt;//订单状态（审核，未审核)
	private String pszd;//配送指定（公司直送，转二批配送）
	private String tp;//1所有，2部门，3自己
	private String str;//用户id组
	private Integer cid;//客户id
	
	private Integer jepx;//排序
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getJepx() {
		return jepx;
	}
	public void setJepx(Integer jepx) {
		this.jepx = jepx;
	}
	public Double getZje() {
		return zje;
	}
	public void setZje(Double zje) {
		this.zje = zje;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
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
	public String getOrderZt() {
		return orderZt;
	}
	public void setOrderZt(String orderZt) {
		this.orderZt = orderZt;
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
	public List<SysBforderDetail> getList1() {
		return list1;
	}
	public void setList1(List<SysBforderDetail> list1) {
		this.list1 = list1;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getOrderIds() {
		return orderIds;
	}
	public void setOrderIds(String orderIds) {
		this.orderIds = orderIds;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	
	

}
