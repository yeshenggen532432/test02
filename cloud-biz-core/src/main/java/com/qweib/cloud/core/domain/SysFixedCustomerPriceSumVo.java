package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

public class SysFixedCustomerPriceSumVo {
    private Integer fixedId;
    private BigDecimal price;

    public Integer getFixedId() {
        return fixedId;
    }

    public void setFixedId(Integer fixedId) {
        this.fixedId = fixedId;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
