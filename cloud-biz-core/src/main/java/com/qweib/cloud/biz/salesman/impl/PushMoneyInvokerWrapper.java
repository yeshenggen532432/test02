package com.qweib.cloud.biz.salesman.impl;

import com.qweib.cloud.biz.salesman.common.PushMoneyUtils;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.PushMoneyDTO;
import com.qweibframework.commons.MathUtils;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/17 - 11:05
 */
public class PushMoneyInvokerWrapper {

    public <T> PushMoneyDTO transToByQuantity(AbstractPushMoneyInvoker<T> invoker, BillPriceDTO billPriceDTO, BigDecimal wareData) {
        PushMoneyDTO pushMoneyDTO = makePushMoney(billPriceDTO);

        final BigDecimal computedPrice = invoker.multiplyByAssign(billPriceDTO.getQuantity(), wareData);
        pushMoneyDTO.setComputedPrice(computedPrice);

        return pushMoneyDTO;
    }

    public <T> PushMoneyDTO transToByQuantity(AbstractPushMoneyInvoker<T> invoker, BillPriceDTO billPriceDTO,
                                              BigDecimal wareData, BigDecimal rateData) {
        PushMoneyDTO pushMoneyDTO = makePushMoney(billPriceDTO);

        final BigDecimal computedPrice = invoker.multiplyByRate(billPriceDTO.getQuantity(), wareData, rateData);
        pushMoneyDTO.setComputedPrice(computedPrice);

        return pushMoneyDTO;
    }

    /**
     * 计算收入百分提成，结果要乘以百分比
     * @param invoker
     * @param billPriceDTO
     * @param wareData
     * @param <T>
     * @return
     */
    public <T> PushMoneyDTO transToByAmount(AbstractPushMoneyInvoker<T> invoker, BillPriceDTO billPriceDTO,
                                            BigDecimal wareData) {
        PushMoneyDTO pushMoneyDTO = makePushMoney(billPriceDTO);

        final BigDecimal computedPrice = invoker.multiplyByAssign(billPriceDTO.getQuantity().multiply(billPriceDTO.getUnitPrice()), wareData);
        pushMoneyDTO.setComputedPrice(MathUtils.divideByScale(computedPrice, BigDecimal.valueOf(100D), 2));

        return pushMoneyDTO;
    }

    public <T> PushMoneyDTO transToByAmount(AbstractPushMoneyInvoker<T> invoker, BillPriceDTO billPriceDTO,
                                            BigDecimal wareData, BigDecimal configData) {
        PushMoneyDTO pushMoneyDTO = makePushMoney(billPriceDTO);

        final BigDecimal computedPrice = invoker.multiplyByRate(billPriceDTO.getQuantity().multiply(billPriceDTO.getUnitPrice()), wareData, configData);
        pushMoneyDTO.setComputedPrice(MathUtils.divideByScale(computedPrice, BigDecimal.valueOf(100D), 2));

        return pushMoneyDTO;
    }

    public PushMoneyDTO makePushMoney(BillPriceDTO billPriceDTO) {
        PushMoneyDTO pushMoneyDTO = new PushMoneyDTO();
        PushMoneyUtils.copyResultData(billPriceDTO, pushMoneyDTO);

        pushMoneyDTO.setQuantity(billPriceDTO.getQuantity());
        pushMoneyDTO.setAmount(billPriceDTO.getQuantity().multiply(billPriceDTO.getUnitPrice()));

        return pushMoneyDTO;
    }
}
