package com.qweib.cloud.core.domain;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class SysFixedCustomerDTO {
    private String khNm;
    private Integer customerId;
    private BigDecimal price1;
    private BigDecimal price2;
    private Integer id1;
    private Integer id2;
}
