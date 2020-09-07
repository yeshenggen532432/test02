package com.qweib.cloud.biz.salesman.impl;

import com.qweib.cloud.biz.salesman.pojo.dto.*;
import com.qweib.cloud.biz.salesman.pojo.input.PushMoneyTypeEnum;
import com.qweibframework.commons.MathUtils;

import java.math.BigDecimal;

/**
 * Description: 按数量提成计算
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 15:07
 */
public class QuantityPushMoneyInvoker extends AbstractPushMoneyInvoker<PushMoneyDTO> {

    public QuantityPushMoneyInvoker(String database, PushMoneyTypeEnum configType, Integer configTypeId) {
        super(database, configType, configTypeId);
    }

    @Override
    protected PushMoneyDTO doInvokeCustomWare(BillPriceDTO billPriceDTO, BigDecimal wareCustomerFactor) {
        return this.wrapper.transToByQuantity(this, billPriceDTO, wareCustomerFactor);
    }

    @Override
    protected PushMoneyDTO doInvokeLevelAndWare(BillPriceDTO billPriceDTO, CustomerLevelWarePushMoneyDTO levelWareDTO) {
        if (MathUtils.valid(levelWareDTO.getWareFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO, levelWareDTO.getWareFactor());
        }

        if (MathUtils.valid(billPriceDTO.getWareDefaultFactor()) && MathUtils.valid(levelWareDTO.getGlobalFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO,
                    billPriceDTO.getWareDefaultFactor(), levelWareDTO.getGlobalFactor());
        }

        return null;
    }

    @Override
    protected PushMoneyDTO doInvokeLevelAndWareType(BillPriceDTO billPriceDTO, CustomerLevelPushMoneyDTO levelDTO) {
        if (MathUtils.valid(billPriceDTO.getWareDefaultFactor()) && MathUtils.valid(levelDTO.getGlobalFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO,
                    billPriceDTO.getWareDefaultFactor(), levelDTO.getGlobalFactor());
        }

        return null;
    }

    @Override
    protected PushMoneyDTO doInvokeTypeAndWare(BillPriceDTO billPriceDTO, CustomerTypeWarePushMoneyDTO typeWareDTO) {
        if (MathUtils.valid(typeWareDTO.getWareFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO, typeWareDTO.getWareFactor());
        }

        if (MathUtils.valid(billPriceDTO.getWareDefaultFactor()) && MathUtils.valid(typeWareDTO.getGlobalFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO,
                    billPriceDTO.getWareDefaultFactor(), typeWareDTO.getGlobalFactor());
        }

        return null;
    }

    @Override
    protected PushMoneyDTO doInvokeTypeAndWareType(BillPriceDTO billPriceDTO, CustomerTypePushMoneyDTO typeDTO) {
        if (MathUtils.valid(billPriceDTO.getWareDefaultFactor()) && MathUtils.valid(typeDTO.getGlobalFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO,
                    billPriceDTO.getWareDefaultFactor(), typeDTO.getGlobalFactor());
        }

        return null;
    }

    @Override
    protected PushMoneyDTO invokeSourceWare(BillPriceDTO billPriceDTO) {
        if (MathUtils.valid(billPriceDTO.getWareDefaultFactor())) {
            return this.wrapper.transToByQuantity(this, billPriceDTO, billPriceDTO.getWareDefaultFactor());
        } else {
            PushMoneyDTO pushMoneyDTO = this.wrapper.makePushMoney(billPriceDTO);
            pushMoneyDTO.setComputedPrice(BigDecimal.ZERO);
            return pushMoneyDTO;
        }
    }
}
