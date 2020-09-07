package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：报评论
 *@创建：作者:llp		创建时间：2016-12-30
 *@修改历史：
 *		[序号](llp	2016-12-30)<修改说明>
 */
public class SysReportPl {
	private Integer id;//报评论id
	private Integer bid;//报id
	private Integer memberId;//用户id
	private String content;//内容
	private String pltime;//时间
	//-------------------------不在数据库--------------------------
	private String memberNm;//用户名称
	
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getPltime() {
		return pltime;
	}
	public void setPltime(String pltime) {
		this.pltime = pltime;
	}
	public Integer getBid() {
		return bid;
	}
	public void setBid(Integer bid) {
		this.bid = bid;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	
}
