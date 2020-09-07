package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

//拜访计划(新的)
public class BscPlanNew {
	private Integer id;//计划id
	private Integer mid;//业务员id
	private Integer xlid;//线路id
	private Integer branchId;//部门id
	private String pdate;//计划日期

	//------------------------------------------
	private String xlNm;//线路名称
	private String memberNm;//业务员名称
	private List<BscPlanSub> subList;
//	private String khNm;//客户名称
//	private String address;//客户地址
//	private String branchName;//部门名称
//	private String linkman;//联系人
//	private String tel;//电话
//	private String scbfDate;//上次拜访日期
//	private Integer num;//客户数
//	private Integer isWc;//是否完成（1是；2否）


	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getMid() {
		return mid;
	}

	public void setMid(Integer mid) {
		this.mid = mid;
	}

	public Integer getXlid() {
		return xlid;
	}

	public void setXlid(Integer xlid) {
		this.xlid = xlid;
	}

	public Integer getBranchId() {
		return branchId;
	}

	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}

	public String getPdate() {
		return pdate;
	}

	public void setPdate(String pdate) {
		this.pdate = pdate;
	}


	//----------------------------------------------------------------
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getXlNm() {
		return xlNm;
	}

	public void setXlNm(String xlNm) {
		this.xlNm = xlNm;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public List<BscPlanSub> getSubList() {
		return subList;
	}

	public void setSubList(List<BscPlanSub> subList) {
		this.subList = subList;
	}
}
