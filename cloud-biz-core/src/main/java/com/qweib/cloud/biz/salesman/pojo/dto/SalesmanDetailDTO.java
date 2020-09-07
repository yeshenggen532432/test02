package com.qweib.cloud.biz.salesman.pojo.dto;

import com.qweib.cloud.biz.salesman.common.PushMoneyUtils;
import lombok.Data;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 14:55
 */
@Data
public class SalesmanDetailDTO extends BaseResultDTO {

    private BigDecimal quantity;
    private BigDecimal amount;

    /**
     * 计算后的提成金额
     */
    private BigDecimal pushMoney;

    public SalesmanDetailDTO() {
        this.quantity = BigDecimal.ZERO;
        this.amount = BigDecimal.ZERO;
        this.pushMoney = BigDecimal.ZERO;
    }

    public void addPushMoneyDTO(PushMoneyDTO pushMoneyDTO) {
        this.quantity = this.quantity.add(pushMoneyDTO.getQuantity());
        this.amount = this.amount.add(pushMoneyDTO.getAmount());
        this.pushMoney = this.pushMoney.add(pushMoneyDTO.getComputedPrice());
    }


    public static SalesmanDetailDTO createByPushMoney(PushMoneyDTO pushMoneyDTO) {
        SalesmanDetailDTO detailDTO = new SalesmanDetailDTO();

        PushMoneyUtils.copyResultData(pushMoneyDTO, detailDTO);

        return detailDTO;
    }
}
