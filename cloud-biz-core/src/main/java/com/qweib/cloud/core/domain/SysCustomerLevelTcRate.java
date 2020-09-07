package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户等级对应商品类别比例
 */
public class SysCustomerLevelTcRate {
	private Integer id;//
	private Integer relaId;//客户等级
	private Integer waretypeId;//商品类别ID
	private BigDecimal saleQtyTcRate;//单件提成比例
	private BigDecimal saleProTcRate;//利润提成比例
	private BigDecimal saleGroTcRate;//毛利提成比例
	private BigDecimal saleQtyTc;//单件提成
	private BigDecimal saleProTc;//利润提成
	private BigDecimal saleGroTc;//毛利提成
	private Integer status;
	private String waretypePath;

	private String khdjNm;
	@TableAnnotation(insertAble = false, updateAble = false)
	public String getKhdjNm() {
		return khdjNm;
	}

	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getRelaId() { return relaId; }

	public void setRelaId(Integer relaId) { this.relaId = relaId; }

	public Integer getWaretypeId() {
		return waretypeId;
	}

	public void setWaretypeId(Integer waretypeId) {
		this.waretypeId = waretypeId;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getWaretypePath() { return waretypePath; }
	public void setWaretypePath(String waretypePath) { this.waretypePath = waretypePath; }

	public BigDecimal getSaleQtyTcRate() {
		return saleQtyTcRate;
	}

	public void setSaleQtyTcRate(BigDecimal saleQtyTcRate) {
		this.saleQtyTcRate = saleQtyTcRate;
	}

	public BigDecimal getSaleProTcRate() {
		return saleProTcRate;
	}

	public void setSaleProTcRate(BigDecimal saleProTcRate) {
		this.saleProTcRate = saleProTcRate;
	}

	public BigDecimal getSaleGroTcRate() {
		return saleGroTcRate;
	}

	public void setSaleGroTcRate(BigDecimal saleGroTcRate) {
		this.saleGroTcRate = saleGroTcRate;
	}

	public BigDecimal getSaleQtyTc() { return saleQtyTc; }

	public void setSaleQtyTc(BigDecimal saleQtyTc) { this.saleQtyTc = saleQtyTc; }

	public BigDecimal getSaleProTc() { return saleProTc; }

	public void setSaleProTc(BigDecimal saleProTc) { this.saleProTc = saleProTc; }

	public BigDecimal getSaleGroTc() { return saleGroTc; }

	public void setSaleGroTc(BigDecimal saleGroTc) { this.saleGroTc = saleGroTc; }
}
