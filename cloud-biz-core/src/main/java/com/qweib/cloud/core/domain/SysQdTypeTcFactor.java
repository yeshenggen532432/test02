package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户类型对应商品信息提成系数
 */
public class SysQdTypeTcFactor {
	private Integer id;//
	private Integer relaId;
	private Integer wareId;
	private String status;

	private BigDecimal saleQtyTcRate;//比例
	private BigDecimal saleProTcRate;//比例
	private BigDecimal saleGroTcRate;//比例

	private BigDecimal saleQtyTc;//单件提成
	private BigDecimal saleProTc;//利润提成
	private BigDecimal saleGroTc;//毛利提成

	private String wareNm;
	private String qdtpNm;
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
	public Integer getRelaId() {
		return relaId;
	}
	public void setRelaId(Integer relaId) {
		this.relaId = relaId;
	}

	public BigDecimal getSaleQtyTcRate() { return saleQtyTcRate; }

	public void setSaleQtyTcRate(BigDecimal saleQtyTcRate) { this.saleQtyTcRate = saleQtyTcRate; }

	public BigDecimal getSaleProTcRate() { return saleProTcRate; }

	public void setSaleProTcRate(BigDecimal saleProTcRate) { this.saleProTcRate = saleProTcRate; }

	public BigDecimal getSaleGroTcRate() { return saleGroTcRate; }

	public void setSaleGroTcRate(BigDecimal saleGroTcRate) { this.saleGroTcRate = saleGroTcRate; }

	public BigDecimal getSaleQtyTc() { return saleQtyTc; }

	public void setSaleQtyTc(BigDecimal saleQtyTc) { this.saleQtyTc = saleQtyTc; }

	public BigDecimal getSaleProTc() { return saleProTc; }

	public void setSaleProTc(BigDecimal saleProTc) { this.saleProTc = saleProTc; }

	public BigDecimal getSaleGroTc() {	return saleGroTc; }

	public void setSaleGroTc(BigDecimal saleGroTc) { this.saleGroTc = saleGroTc; }

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getQdtpNm() { return qdtpNm; }

	public void setQdtpNm(String qdtpNm) { this.qdtpNm = qdtpNm; }
}
