package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：报
 *@创建：作者:llp		创建时间：2016-12-16
 *@修改历史：
 *		[序号](llp	2016-12-16)<修改说明>
 */
public class SysReport {
	private Integer id;//报id
	private Integer memberId;//用户id
	private Integer tp;//报类型(1日报；2周报；3月报)
	private String gzNr;//工作内容
	private String gzZj;//工作总结
	private String gzJh;//工作计划
	private String gzBz;//帮助与支持
	private String remo;//备注
	private String fbTime;//发布时间
	private String fileNms;//附件
	private String address;//地址
	//--------------------不在数据库----------------------
	private String memberNm;//用户名称
	private String memberHead;//用户头像
	private String tp2;//1所有，2部门，3自己
	private String str;//用户id组
	private String sdate;//开始时间
	private String edate;//结束时间
	private String fsMids;//发送者id
	
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getFsMids() {
		return fsMids;
	}
	public void setFsMids(String fsMids) {
		this.fsMids = fsMids;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getFileNms() {
		return fileNms;
	}
	public void setFileNms(String fileNms) {
		this.fileNms = fileNms;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getStr() {
		return str;
	}
	public void setStr(String str) {
		this.str = str;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getTp2() {
		return tp2;
	}
	public void setTp2(String tp2) {
		this.tp2 = tp2;
	}
	public String getFbTime() {
		return fbTime;
	}
	public void setFbTime(String fbTime) {
		this.fbTime = fbTime;
	}
	public String getGzBz() {
		return gzBz;
	}
	public void setGzBz(String gzBz) {
		this.gzBz = gzBz;
	}
	public String getGzJh() {
		return gzJh;
	}
	public void setGzJh(String gzJh) {
		this.gzJh = gzJh;
	}
	public String getGzNr() {
		return gzNr;
	}
	public void setGzNr(String gzNr) {
		this.gzNr = gzNr;
	}
	public String getGzZj() {
		return gzZj;
	}
	public void setGzZj(String gzZj) {
		this.gzZj = gzZj;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberHead() {
		return memberHead;
	}
	public void setMemberHead(String memberHead) {
		this.memberHead = memberHead;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public Integer getTp() {
		return tp;
	}
	public void setTp(Integer tp) {
		this.tp = tp;
	}
	
	

}
