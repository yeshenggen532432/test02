package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:13
 */
@Data
public class BillPriceDTO extends BaseResultDTO {

    /**
     * 商品类别 id
     */
    private Integer wareTypeId;

    /**
     * 提成配置
     */
    private BigDecimal wareDefaultFactor;

    /**
     * 数量
     */
    private BigDecimal quantity;
    /**
     * 单价
     */
    private BigDecimal unitPrice;


    /**
     * 客户类型名称
     */
    private String customerTypeName;
    /**
     * 客户等级名称
     */
    private String customerLevelName;
}
