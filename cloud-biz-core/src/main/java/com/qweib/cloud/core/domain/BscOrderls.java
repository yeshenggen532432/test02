package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

//旅行社订单
public class BscOrderls {
	private Integer id;//旅行社订单id
	private String orderNo;//订单号
	private Integer cid;//客户id
	private Integer mid;//用户id
	private String oddate;//日期
	private String orderZt;//订单状态（审核，未审核)
	//------------------------不在数据库--------------------
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	private String sdate;//开始时间
	private String edate;//结束时间
	private List<BscOrderlsDetail> list;//详情集合
	private Integer isMe;//是否我的（1是；2否）
	private String database;//数据库
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getIsMe() {
		return isMe;
	}
	public void setIsMe(Integer isMe) {
		this.isMe = isMe;
	}
	public String getOrderZt() {
		return orderZt;
	}
	public void setOrderZt(String orderZt) {
		this.orderZt = orderZt;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<BscOrderlsDetail> getList() {
		return list;
	}
	public void setList(List<BscOrderlsDetail> list) {
		this.list = list;
	}
	@TableAnnotation(updateAble=false)
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
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
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	@TableAnnotation(updateAble=false)
	public String getOddate() {
		return oddate;
	}
	public void setOddate(String oddate) {
		this.oddate = oddate;
	}
	
	
	

}
