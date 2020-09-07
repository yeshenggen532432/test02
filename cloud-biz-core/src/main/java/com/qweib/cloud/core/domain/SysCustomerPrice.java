package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户销售价格设置
 * @author guojr
 *
 */
public class SysCustomerPrice {
	private Integer id;//主键
	private Integer customerId;
	private Integer wareId;//商品id

	private BigDecimal saleAmt;//大单位批发价

	private Double lsPrice; //零售价--进销存：大单位零售价
	private Double fxPrice;//分销价--进销存:大单位分销价
	private Double cxPrice;//促销价--进销存:大单位促销价
	private Double sunitPrice;//小单位销售价--进销存：小单位批发价
	private Double minLsPrice;//小单位零售价--进销存：小单位零售价
	private Double minFxPrice;//小单位分销价--进销存：小单位分销价
	private Double minCxPrice;//小单位促销价--进销存：小单位促销价

	private Double maxHisPfPrice;//最新大单位历史批发价;
	private String maxHisPfPrices;//大单位历史批发价;

	private Double minHisPfPrice;//最新小单位历史批发价;
	private String minHisPfPrices;//小单位历史批发价;


	private Double maxHisGyPrice;//最大历史干预价
	private Double minHisGyPrice;//最小历史干预价

	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getWareId() {
		return wareId;
	}
	public void setWareId(Integer wareId) {
		this.wareId = wareId;
	}
	public BigDecimal getSaleAmt() {
		return saleAmt;
	}
	public void setSaleAmt(BigDecimal saleAmt) {
		this.saleAmt = saleAmt;
	}

	public Double getLsPrice() {
		return lsPrice;
	}

	public void setLsPrice(Double lsPrice) {
		this.lsPrice = lsPrice;
	}

	public Double getFxPrice() {
		return fxPrice;
	}

	public void setFxPrice(Double fxPrice) {
		this.fxPrice = fxPrice;
	}

	public Double getCxPrice() {
		return cxPrice;
	}

	public void setCxPrice(Double cxPrice) {
		this.cxPrice = cxPrice;
	}

	public Double getSunitPrice() {
		return sunitPrice;
	}

	public void setSunitPrice(Double sunitPrice) {
		this.sunitPrice = sunitPrice;
	}

	public Double getMinLsPrice() {
		return minLsPrice;
	}

	public void setMinLsPrice(Double minLsPrice) {
		this.minLsPrice = minLsPrice;
	}

	public Double getMinFxPrice() {
		return minFxPrice;
	}

	public void setMinFxPrice(Double minFxPrice) {
		this.minFxPrice = minFxPrice;
	}

	public Double getMinCxPrice() {
		return minCxPrice;
	}

	public void setMinCxPrice(Double minCxPrice) {
		this.minCxPrice = minCxPrice;
	}

	private String wareNm;
	@TableAnnotation(insertAble = false, updateAble = false)
	public String getWareNm() {
		return wareNm;
	}

	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}

	public Double getMaxHisPfPrice() {
		return maxHisPfPrice;
	}

	public void setMaxHisPfPrice(Double maxHisPfPrice) {
		this.maxHisPfPrice = maxHisPfPrice;
	}

	public String getMaxHisPfPrices() {
		return maxHisPfPrices;
	}

	public void setMaxHisPfPrices(String maxHisPfPrices) {
		this.maxHisPfPrices = maxHisPfPrices;
	}

	public Double getMinHisPfPrice() { return minHisPfPrice; }

	public void setMinHisPfPrice(Double minHisPfPrice) { this.minHisPfPrice = minHisPfPrice; }

	public String getMinHisPfPrices() { return minHisPfPrices; }

	public void setMinHisPfPrices(String minHisPfPrices) { this.minHisPfPrices = minHisPfPrices; }

	public Double getMaxHisGyPrice() { return maxHisGyPrice; }

	public void setMaxHisGyPrice(Double maxHisGyPrice) { this.maxHisGyPrice = maxHisGyPrice; }

	public Double getMinHisGyPrice() { return minHisGyPrice; }

	public void setMinHisGyPrice(Double minHisGyPrice) { this.minHisGyPrice = minHisGyPrice; }
}
