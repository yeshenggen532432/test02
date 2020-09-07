package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

public class SysBfKhXx {
	private Integer id;//拜访签到拍照id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String qddate;//拜访日期
	private String memberNm;//业务员名称
	private String memberMobile;//业务员手机号
	private String branchName;//业务员部门名称
	private String khNm;//客户名称
	private String qdtpNm;//客户类型
	private String remo;//客户备注
	private String bftime;//拜访时间
	private String qdtime;//签到时间
	private String ldtime;//离店时间
	private String bfsc;//拜访时长
	private String bcbfzj;//拜访总结
	private String dbsx;//代办事项
	private String qdaddress;//签到地址
	private String khaddress;//客户地址
	private String linkman;//负责人
	private String tel;//负责人电话
	private String mobile;//负责人手机
	private List<bfpzpicxx> listpic;//图片集合
	private String khdjNm;//客户等级
	//------------------------------------
	private List<SysBforderDetail> list1;//订单集合
	private List<SysBfxsxj> list2;//库存集合
	private String stime;//开始时间
	private String etime;//结束时间
	private String memberIds;
	private String imageListStr;//原图
	private String imageListStr1;//缩略图
	private String database;
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	private String branchId;//部门ID
	
	
	public String getMemberIds() {
		return memberIds;
	}
	public void setMemberIds(String memberIds) {
		this.memberIds = memberIds;
	}
	public String getKhdjNm() {
		return khdjNm;
	}
	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
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
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public List<bfpzpicxx> getListpic() {
		return listpic;
	}
	public void setListpic(List<bfpzpicxx> listpic) {
		this.listpic = listpic;
	}
	public String getBftime() {
		return bftime;
	}
	public void setBftime(String bftime) {
		this.bftime = bftime;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getBcbfzj() {
		return bcbfzj;
	}
	public void setBcbfzj(String bcbfzj) {
		this.bcbfzj = bcbfzj;
	}
	public String getBfsc() {
		return bfsc;
	}
	public void setBfsc(String bfsc) {
		this.bfsc = bfsc;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public String getDbsx() {
		return dbsx;
	}
	public void setDbsx(String dbsx) {
		this.dbsx = dbsx;
	}
	public String getKhaddress() {
		return khaddress;
	}
	public void setKhaddress(String khaddress) {
		this.khaddress = khaddress;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public String getLdtime() {
		return ldtime;
	}
	public void setLdtime(String ldtime) {
		this.ldtime = ldtime;
	}
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	public String getMemberMobile() {
		return memberMobile;
	}
	public void setMemberMobile(String memberMobile) {
		this.memberMobile = memberMobile;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getQdaddress() {
		return qdaddress;
	}
	public void setQdaddress(String qdaddress) {
		this.qdaddress = qdaddress;
	}
	public String getQddate() {
		return qddate;
	}
	public void setQddate(String qddate) {
		this.qddate = qddate;
	}
	public String getQdtime() {
		return qdtime;
	}
	public void setQdtime(String qdtime) {
		this.qdtime = qdtime;
	}
	public String getQdtpNm() {
		return qdtpNm;
	}
	public void setQdtpNm(String qdtpNm) {
		this.qdtpNm = qdtpNm;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getImageListStr() {
		return imageListStr;
	}
	public void setImageListStr(String imageListStr) {
		this.imageListStr = imageListStr;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getImageListStr1() {
		return imageListStr1;
	}
	public void setImageListStr1(String imageListStr1) {
		this.imageListStr1 = imageListStr1;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysBforderDetail> getList1() {
		return list1;
	}

	public void setList1(List<SysBforderDetail> list1) {
		this.list1 = list1;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysBfxsxj> getList2() {
		return list2;
	}

	public void setList2(List<SysBfxsxj> list2) {
		this.list2 = list2;
	}
}
