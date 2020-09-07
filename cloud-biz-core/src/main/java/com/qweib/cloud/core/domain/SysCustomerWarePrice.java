package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

/**
 * 客户商品运输费用价格设置
 * @author guojr
 *
 */
public class SysCustomerWarePrice {
	private Integer id;//主键
	private Integer customerId;
	private Integer wareId;//商品id
	private BigDecimal tranAmt;//运输费用
	
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
	public BigDecimal getTranAmt() {
		return tranAmt;
	}
	public void setTranAmt(BigDecimal tranAmt) {
		this.tranAmt = tranAmt;
	}
	
    
	
	
}
