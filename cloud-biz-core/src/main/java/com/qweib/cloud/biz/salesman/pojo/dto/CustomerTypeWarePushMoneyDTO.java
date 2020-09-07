package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Getter;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:56
 */
@Getter
public class CustomerTypeWarePushMoneyDTO extends BasePushMoneyDTO {

    /**
     * 客户类型 id
     */
    private final Integer customerTypeId;
    /**
     * 商品 id
     */
    private final Integer wareId;

    /**
     * 按商品实际提成系数
     */
    private final BigDecimal wareFactor;

    public CustomerTypeWarePushMoneyDTO(Integer id, BigDecimal globalFactor, Integer customerTypeId, Integer wareId, BigDecimal wareFactor) {
        super(id, globalFactor);
        this.customerTypeId = customerTypeId;
        this.wareId = wareId;
        this.wareFactor = wareFactor;
    }
}
