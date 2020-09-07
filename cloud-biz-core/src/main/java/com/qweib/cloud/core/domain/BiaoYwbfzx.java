package com.qweib.cloud.core.domain;

import java.util.List;

//业务拜访执行表
public class BiaoYwbfzx {
	private Integer id;//拜访id
	private String timed;//时间段
	private String khNm;//客户名称
	private String khdjNm;//客户等级
	private String memberNm;//业务员名称
	private Integer qdtpNum;//签到图片数量
	private Integer sdhtpNum;//生动化图片数量
	private Integer kcjctpNum;//图片数量
	private List<SysBforderDetail> list1;//订单集合
	private List<SysBfxsxj> list2;//库存集合
	private Integer bfbz;//拜访步骤
	//----------------------------
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String qddate;//签到日期
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
	public String getKhdjNm() {
		return khdjNm;
	}
	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}
	public Integer getKcjctpNum() {
		return kcjctpNum;
	}
	public void setKcjctpNum(Integer kcjctpNum) {
		this.kcjctpNum = kcjctpNum;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getBfbz() {
		return bfbz;
	}
	public void setBfbz(Integer bfbz) {
		this.bfbz = bfbz;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
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
	public List<SysBfxsxj> getList2() {
		return list2;
	}
	public void setList2(List<SysBfxsxj> list2) {
		this.list2 = list2;
	}
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
	public String getQddate() {
		return qddate;
	}
	public void setQddate(String qddate) {
		this.qddate = qddate;
	}
	public Integer getQdtpNum() {
		return qdtpNum;
	}
	public void setQdtpNum(Integer qdtpNum) {
		this.qdtpNum = qdtpNum;
	}
	public Integer getSdhtpNum() {
		return sdhtpNum;
	}
	public void setSdhtpNum(Integer sdhtpNum) {
		this.sdhtpNum = sdhtpNum;
	}
	public String getTimed() {
		return timed;
	}
	public void setTimed(String timed) {
		this.timed = timed;
	}
	
	
}
