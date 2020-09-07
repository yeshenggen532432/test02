package com.qweib.cloud.biz.salesman.impl;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.salesman.PushMoneyInvoker;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.PushMoneyDTO;
import com.qweib.cloud.biz.salesman.pojo.dto.SalesmanDetailDTO;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Description: 按业务员查询商品明细
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 14:57
 */
public class SalesmanDetailPushMoneyExecutor extends AbstractSalesmanPushMoneyExecutor<PushMoneyDTO, SalesmanDetailDTO> {

    private Map<String, SalesmanDetailDTO> salesmanCache = Maps.newHashMap();

    public SalesmanDetailPushMoneyExecutor(PushMoneyInvoker<PushMoneyDTO> invoker) {
        super(invoker);
    }

    @Override
    protected void doExecute(List<BillPriceDTO> billPriceDTOS) {
        for (BillPriceDTO billPriceDTO : billPriceDTOS) {
            final PushMoneyDTO pushMoneyDTO = this.invoker.invoke(billPriceDTO);
            if (pushMoneyDTO == null) {
                continue;
            }

            final String key = generateKey(pushMoneyDTO);
            final SalesmanDetailDTO salesmanDTO = Optional.ofNullable(salesmanCache.get(key))
                    .orElseGet(() -> {
                        SalesmanDetailDTO detailDTO = SalesmanDetailDTO.createByPushMoney(pushMoneyDTO);

                        salesmanCache.put(key, detailDTO);

                        return detailDTO;
                    });

            salesmanDTO.addPushMoneyDTO(pushMoneyDTO);
        }
    }

    private String generateKey(PushMoneyDTO data) {
        final StringBuilder keyBuilder = new StringBuilder(64);
        keyBuilder.append(StringUtils.isNotBlank(data.getBillType()) ? data.getBillType() : "-1");
        keyBuilder.append(":").append(MathUtils.valid(data.getSalesmanId()) ? data.getSalesmanId() : -1);
        keyBuilder.append(":").append(StringUtils.isNotBlank(data.getCustomerName()) ? data.getCustomerName() : "-1");
        keyBuilder.append(":").append(StringUtils.isNotBlank(data.getWareName()) ? data.getWareName() : "-1");
        keyBuilder.append(":").append(StringUtils.isNotBlank(data.getUnitName()) ? data.getUnitName() : "-1");

        return keyBuilder.toString();
    }

    @Override
    public List<SalesmanDetailDTO> getResultList() {
        return salesmanCache.values().stream().collect(Collectors.toList());
    }
}
