package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:47
 */
@AllArgsConstructor
@Getter
public class BasePushMoneyDTO {

    private final Integer id;

    /**
     * 全局默认提成系数
     */
    private final BigDecimal globalFactor;

}
