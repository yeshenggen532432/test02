package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户等级对应商品类别比例
 */
public class SysCustomerLevelRate {
	private Integer id;//
	private Integer relaId;//客户等级
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
	public Integer getRelaId() { return relaId; }

	public void setRelaId(Integer relaId) { this.relaId = relaId; }

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

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getWaretypePath() { return waretypePath; }
	public void setWaretypePath(String waretypePath) { this.waretypePath = waretypePath; }
}
