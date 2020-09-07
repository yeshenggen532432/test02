package com.qweib.cloud.core.domain.customer;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/23 - 14:55
 */
@Data
public class CustomerPriceData {

    private Integer customerId;
    private Integer productId;
    /**
     * 大单位批发价
     */
    private Double bigUnitTradePrice;
    /**
     * 小单位批发价
     */
    private Double smallUnitTradePrice;

    //客户名称
    private String customerName;
    //商品名称
    private String productName;
}
