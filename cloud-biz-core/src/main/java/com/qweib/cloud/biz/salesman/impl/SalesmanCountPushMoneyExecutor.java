package com.qweib.cloud.biz.salesman.impl;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.salesman.PushMoneyInvoker;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.PushMoneyDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.SalesmanCountDTO;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 14:47
 */
public class SalesmanCountPushMoneyExecutor extends AbstractSalesmanPushMoneyExecutor<PushMoneyDTO, SalesmanCountDTO> {

    private Map<Integer, SalesmanCountDTO> salesmanCache = Maps.newHashMap();

    public SalesmanCountPushMoneyExecutor(PushMoneyInvoker<PushMoneyDTO> invoker) {
        super(invoker);
    }

    @Override
    protected void doExecute(List<BillPriceDTO> billPriceDTOS) {
        for (BillPriceDTO billPriceDTO : billPriceDTOS) {
            final PushMoneyDTO pushMoneyDTO = this.invoker.invoke(billPriceDTO);
            if (pushMoneyDTO == null) {
                continue;
            }

            final Integer salesmanId = pushMoneyDTO.getSalesmanId();
            final SalesmanCountDTO salesmanDTO = Optional.ofNullable(salesmanCache.get(salesmanId))
                    .orElseGet(() -> {
                        SalesmanCountDTO countDTO = new SalesmanCountDTO(salesmanId, pushMoneyDTO.getSalesmanName());

                        salesmanCache.put(salesmanId, countDTO);

                        return countDTO;
                    });

            salesmanDTO.addPushMoneyDTO(pushMoneyDTO);
        }
    }

    @Override
    public List<SalesmanCountDTO> getResultList() {
        return salesmanCache.values()
                .stream().collect(Collectors.toList());
    }
}
