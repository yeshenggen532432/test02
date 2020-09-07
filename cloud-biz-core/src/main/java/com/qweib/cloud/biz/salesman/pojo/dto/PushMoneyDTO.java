package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 14:53
 */
@Data
public class PushMoneyDTO extends BaseResultDTO {

    private BigDecimal quantity;
    private BigDecimal amount;

    /**
     * 计算后的提成金额
     */
    private BigDecimal computedPrice;
}
