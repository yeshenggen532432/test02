package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 *说明：客户等级
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysKhlevel {
	private Integer id;//客户等级id
	private Integer qdId;//渠道类型id
	private String coding;//编码
	private String khdjNm;//名称
	private BigDecimal rate;//利率;

	//------------------------------
	private String qdtpNm;//渠道类型名称
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getQdtpNm() {
		return qdtpNm;
	}
	public void setQdtpNm(String qdtpNm) {
		this.qdtpNm = qdtpNm;
	}
	public Integer getQdId() {
		return qdId;
	}
	public void setQdId(Integer qdId) {
		this.qdId = qdId;
	}
	public String getCoding() {
		return coding;
	}
	public void setCoding(String coding) {
		this.coding = coding;
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

	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getRate() {
		return rate;
	}

	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}
}
