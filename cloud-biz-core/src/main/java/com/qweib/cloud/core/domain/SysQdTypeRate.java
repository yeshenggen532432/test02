package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户类别对应商品类别 销售折扣比例
 */
public class SysQdTypeRate {
	private Integer id;//
	private Integer relaId;//客户类别
	private Integer waretypeId;//商品类别ID
	private BigDecimal rate;//比例
	private Integer status;
	private String waretypePath;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getWaretypeId() {
		return waretypeId;
	}

	public void setWaretypeId(Integer waretypeId) {
		this.waretypeId = waretypeId;
	}

	public BigDecimal getRate() {
		return rate;
	}

	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getRelaId() {
		return relaId;
	}
	public void setRelaId(Integer relaId) {
		this.relaId = relaId;
	}

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getWaretypePath() { return waretypePath; }
	public void setWaretypePath(String waretypePath) { this.waretypePath = waretypePath; }
}
