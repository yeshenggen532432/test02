package com.qweib.cloud.core.domain;


import lombok.Data;

import java.math.BigDecimal;

/**
 * 客户固定费用设置
 */
@Data
public class SysFixedCustomerPrice {
	private Integer id;//
	private Integer fixedId;
	private Integer customerId;
	private BigDecimal price;
	private String status;
	private String customerIds;
	private String month;

}
