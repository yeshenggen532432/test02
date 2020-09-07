package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Getter;

import java.math.BigDecimal;

/**
 * Description: 客户等级配置
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:58
 */
@Getter
public class CustomerLevelPushMoneyDTO extends BasePushMoneyDTO {

    /**
     * 客户等级 id
     */
    private final Integer customerLevelId;
    /**
     * 商品类别 id
     */
    private final Integer wareTypeId;

    public CustomerLevelPushMoneyDTO(Integer id, BigDecimal globalFactor, Integer customerLevelId, Integer wareTypeId) {
        super(id, globalFactor);
        this.customerLevelId = customerLevelId;
        this.wareTypeId = wareTypeId;
    }
}
