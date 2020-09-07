package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 16:25
 */
@Data
public class SalesmanCountDTO {

    private final Integer salesmanId;
    private final String salesmanName;

    private BigDecimal quantity;
    private BigDecimal amount;

    private BigDecimal pushMoney;

    public SalesmanCountDTO(Integer salesmanId, String salesmanName) {
        this.salesmanId = salesmanId;
        this.salesmanName = salesmanName;

        this.quantity = BigDecimal.ZERO;
        this.amount = BigDecimal.ZERO;
        this.pushMoney = BigDecimal.ZERO;
    }

    public void addPushMoneyDTO(PushMoneyDTO pushMoneyDTO) {
        this.quantity = this.quantity.add(pushMoneyDTO.getQuantity());
        this.amount = this.amount.add(pushMoneyDTO.getAmount());
        this.pushMoney = this.pushMoney.add(pushMoneyDTO.getComputedPrice());
    }
}
