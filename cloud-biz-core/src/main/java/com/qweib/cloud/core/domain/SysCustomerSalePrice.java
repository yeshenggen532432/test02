package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

/**
 * 客户商品价格设置--业务员提成设置
 * @author guojr
 *
 */
public class SysCustomerSalePrice {
	private Integer id;//主键
	private Integer customerId;
	private Integer wareId;//商品id
	private BigDecimal tcAmt;//业务提成费用
	
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
	public BigDecimal getTcAmt() {
		return tcAmt;
	}
	public void setTcAmt(BigDecimal tcAmt) {
		this.tcAmt = tcAmt;
	}
	
	
	
}
