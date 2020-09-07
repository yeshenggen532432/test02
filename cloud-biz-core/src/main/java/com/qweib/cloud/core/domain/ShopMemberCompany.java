package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 *会员的供应商
 */
public class ShopMemberCompany {
	
	private Integer fdId;
	/**
	 * 对应会员ID
	 */
	private Integer memberId;
	/**
	 * 会员手机号
	 */
	private String memberMobile;
	/**
	 * 姓名
	 */
	private String memberNm;
	/**
	 * 公司ID
	 */
	private Integer companyId;
	/**
	 * 公司名称
	 */
	private String memberCompany; 
	/**
	 * 关联时间
	 */
	private String inTime;
	/**
	 * 失效时间
	 */
	private String outTime;

	private String shopLogo;

	private String shopName;


	public Integer getFdId() {
		return fdId;
	}
	public void setFdId(Integer fdId) {
		this.fdId = fdId;
	}
	
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	
	public String getMemberMobile() {
		return memberMobile;
	}
	public void setMemberMobile(String memberMobile) {
		this.memberMobile = memberMobile;
	}
	
	public Integer getCompanyId() {
		return companyId;
	}
	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}
	public String getInTime() {
		return inTime;
	}
	public void setInTime(String inTime) {
		this.inTime = inTime;
	}
	public String getOutTime() {
		return outTime;
	}
	public void setOutTime(String outTime) {
		this.outTime = outTime;
	}
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getMemberCompany() {
		return memberCompany;
	}
	public void setMemberCompany(String memberCompany) {
		this.memberCompany = memberCompany;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getShopLogo() {
		return shopLogo;
	}

	public void setShopLogo(String shopLogo) {
		this.shopLogo = shopLogo;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
}
