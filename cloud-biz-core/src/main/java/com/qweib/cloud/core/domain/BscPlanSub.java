package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

//拜访计划明细表
public class BscPlanSub {
	private Integer id;//id
	private Integer pid;//计划id（与BscPlanNew关联）
	private Integer cid;//客户id
	private Integer isWc;//是否完成（1：完成）

	//------------------------------------------
	private String khNm;//客户名称
	private String address;//客户地址
	private String linkman;//联系人
	private String tel;//电话
	private String scbfDate;//上次拜访日期

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getPid() {
		return pid;
	}

	public void setPid(Integer pid) {
		this.pid = pid;
	}

	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	public Integer getIsWc() {
		return isWc;
	}

	public void setIsWc(Integer isWc) {
		this.isWc = isWc;
	}

	//------------------------------------------------------------
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getKhNm() {
		return khNm;
	}

	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
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
	public String getScbfDate() {
		return scbfDate;
	}

	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}


}
