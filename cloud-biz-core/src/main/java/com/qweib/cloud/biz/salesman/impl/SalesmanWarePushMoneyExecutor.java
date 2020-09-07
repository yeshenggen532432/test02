package com.qweib.cloud.biz.salesman.impl;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.salesman.PushMoneyInvoker;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.PushMoneyDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.SalesmanDetailDTO;

import java.util.List;

/**
 * Description: 商品详情
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 16:30
 */
public class SalesmanWarePushMoneyExecutor extends AbstractSalesmanPushMoneyExecutor<PushMoneyDTO, SalesmanDetailDTO> {

    private List<SalesmanDetailDTO> salesmanDetailDTOS = Lists.newArrayList();

    public SalesmanWarePushMoneyExecutor(PushMoneyInvoker<PushMoneyDTO> invoker) {
        super(invoker);
    }

    @Override
    protected void doExecute(List<BillPriceDTO> billPriceDTOS) {
        for (BillPriceDTO billPriceDTO : billPriceDTOS) {
            final PushMoneyDTO pushMoneyDTO = this.invoker.invoke(billPriceDTO);
            if (pushMoneyDTO == null) {
                continue;
            }

            SalesmanDetailDTO detailDTO = SalesmanDetailDTO.createByPushMoney(pushMoneyDTO);
            detailDTO.addPushMoneyDTO(pushMoneyDTO);
            salesmanDetailDTOS.add(detailDTO);
        }
    }

    @Override
    public List<SalesmanDetailDTO> getResultList() {
        return salesmanDetailDTOS;
    }
}
