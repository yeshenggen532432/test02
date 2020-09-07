package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Getter;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:52
 */
@Getter
public class CustomerTypePushMoneyDTO extends BasePushMoneyDTO {

    /**
     * 客户类型 id
     */
    private final Integer customerTypeId;
    /**
     * 商品类别 id
     */
    private final Integer wareTypeId;

    public CustomerTypePushMoneyDTO(Integer id, BigDecimal globalFactor, Integer customerTypeId, Integer wareTypeId) {
        super(id, globalFactor);
        this.customerTypeId = customerTypeId;
        this.wareTypeId = wareTypeId;
    }
}
