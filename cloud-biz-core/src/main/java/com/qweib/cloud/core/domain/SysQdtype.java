package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

/**
 *说明：客户类型
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysQdtype {
	private Integer id;//渠道类型id
	private String coding;//编码
	private String qdtpNm;//名称
	private String remo;//注备
	private Integer isSx;//是否生效（1是；2否）
	private String sxaDate;//生效日期
	private String sxeDate;//失效日期
	private BigDecimal rate;//利率;


	
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
	public String getSxeDate() {
		return sxeDate;
	}
	public void setSxeDate(String sxeDate) {
		this.sxeDate = sxeDate;
	}
	public Integer getIsSx() {
		return isSx;
	}
	public void setIsSx(Integer isSx) {
		this.isSx = isSx;
	}
	public String getSxaDate() {
		return sxaDate;
	}
	public void setSxaDate(String sxaDate) {
		this.sxaDate = sxaDate;
	}

	public BigDecimal getRate() { return rate; }
	public void setRate(BigDecimal rate) { this.rate = rate; }
}
