package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

//拜访计划
public class BscPlan {
	private Integer id;//计划id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private Integer branchId;//部门id
	private String pdate;//计划日期
	private Integer isWc;//是否完成（1是；2否）
	//------------------------------------------
	private String memberNm;//业务员名称
	private String khNm;//客户名称
	private String address;//客户地址
	private String branchName;//部门名称
	private String linkman;//联系人
	private String tel;//电话
	private String scbfDate;//上次拜访日期
	private Integer num;//客户数
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getScbfDate() {
		return scbfDate;
	}
	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Integer getBranchId() {
		return branchId;
	}
	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
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
	public Integer getIsWc() {
		return isWc;
	}
	public void setIsWc(Integer isWc) {
		this.isWc = isWc;
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
	public String getPdate() {
		return pdate;
	}
	public void setPdate(String pdate) {
		this.pdate = pdate;
	}
	
	
	
	

}
