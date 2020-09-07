package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：订单提示信息
 *@创建：作者:llp		创建时间：2016-5-17
 *@修改历史：
 *		[序号](llp	2016-5-17)<修改说明>
 */
public class SysBforderMsg {
	private Integer id;//信息id
	private String orderNo;//订单号
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String msgtime;//时间
	private Integer isRead;//是否已读（1是；2否）
	//----------------------不在数据库------------------
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	
	
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getIsRead() {
		return isRead;
	}
	public void setIsRead(Integer isRead) {
		this.isRead = isRead;
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
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getMsgtime() {
		return msgtime;
	}
	public void setMsgtime(String msgtime) {
		this.msgtime = msgtime;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	
	

}
