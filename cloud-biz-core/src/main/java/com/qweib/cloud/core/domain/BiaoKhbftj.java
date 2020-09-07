package com.qweib.cloud.core.domain;
//客户拜访统计表
public class BiaoKhbftj {
	private Integer id;//客户id
	private Integer khTp;//客户种类（1经销商；2客户）
	private String khNm;//客户名称
	private String khdjNm;//客户等级
	private String createTime;//建立时间
	private String scbfDate;//拜访日期
	private String bfsc;//时长（分钟）
	private Integer bfpl;//拜访频率
	//---------------------
	private String stime;//开始时间
	private String etime;//结束时间
	private String memberNm;//业务员名称
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
	public Integer getKhTp() {
		return khTp;
	}
	public void setKhTp(Integer khTp) {
		this.khTp = khTp;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getEtime() {
		return etime;
	}
	public void setEtime(String etime) {
		this.etime = etime;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	public Integer getBfpl() {
		return bfpl;
	}
	public void setBfpl(Integer bfpl) {
		this.bfpl = bfpl;
	}
	public String getBfsc() {
		return bfsc;
	}
	public void setBfsc(String bfsc) {
		this.bfsc = bfsc;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getKhdjNm() {
		return khdjNm;
	}
	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public String getScbfDate() {
		return scbfDate;
	}
	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}
	
	

}
