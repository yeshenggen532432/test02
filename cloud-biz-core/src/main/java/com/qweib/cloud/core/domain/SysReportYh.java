package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：报用户关系
 *@创建：作者:llp		创建时间：2016-12-16
 *@修改历史：
 *		[序号](llp	2016-12-16)<修改说明>
 */
public class SysReportYh {
	private Integer bid;//报id
	private Integer fsMid;//发送用户id
	private Integer jsMid;//接收用户id
	//-------------------不在数据库---------------------
	private String memberNm;//接收用户名称
	private String memberHead;//接收用户头像
	
	
	public Integer getBid() {
		return bid;
	}
	public void setBid(Integer bid) {
		this.bid = bid;
	}
	public Integer getFsMid() {
		return fsMid;
	}
	public void setFsMid(Integer fsMid) {
		this.fsMid = fsMid;
	}
	public Integer getJsMid() {
		return jsMid;
	}
	public void setJsMid(Integer jsMid) {
		this.jsMid = jsMid;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberHead() {
		return memberHead;
	}
	public void setMemberHead(String memberHead) {
		this.memberHead = memberHead;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	
	

}
