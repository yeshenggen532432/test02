package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

public class SysCustomerLevelTcFactor {
	private Integer id;//
	private Integer levelId;
	private Integer wareId;
	private String status;
	private BigDecimal saleQtyTcRate;//比例
	private BigDecimal saleProTcRate;//比例
	private BigDecimal saleGroTcRate;//比例

	private BigDecimal saleQtyTc;//单件提成
	private BigDecimal saleProTc;//利润提成
	private BigDecimal saleGroTc;//毛利提成
	private String khdjNm;
	@TableAnnotation(insertAble = false, updateAble = false)
	public String getKhdjNm() {
		return khdjNm;
	}

	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}

	private String wareNm;
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getLevelId() {
		return levelId;
	}
	public void setLevelId(Integer levelId) {
		this.levelId = levelId;
	}
	public Integer getWareId() {
		return wareId;
	}
	public void setWareId(Integer wareId) {
		this.wareId = wareId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

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

	public BigDecimal getSaleQtyTc() {
		return saleQtyTc;
	}

	public void setSaleQtyTc(BigDecimal saleQtyTc) {
		this.saleQtyTc = saleQtyTc;
	}

	public BigDecimal getSaleProTc() {
		return saleProTc;
	}

	public void setSaleProTc(BigDecimal saleProTc) {
		this.saleProTc = saleProTc;
	}

	public BigDecimal getSaleGroTc() {
		return saleGroTc;
	}

	public void setSaleGroTc(BigDecimal saleGroTc) {
		this.saleGroTc = saleGroTc;
	}
}
