package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Getter;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:59
 */
@Getter
public class CustomerLevelWarePushMoneyDTO extends BasePushMoneyDTO {

    /**
     * 客户等级 id
     */
    private final Integer customerLevelId;
    /**
     * 商品 id
     */
    private final Integer wareId;

    /**
     * 按商品提成系数
     */
    private final BigDecimal wareFactor;

    public CustomerLevelWarePushMoneyDTO(Integer id, BigDecimal globalFactor, Integer customerLevelId, Integer wareId, BigDecimal wareFactor) {
        super(id, globalFactor);
        this.customerLevelId = customerLevelId;
        this.wareId = wareId;
        this.wareFactor = wareFactor;
    }
}
