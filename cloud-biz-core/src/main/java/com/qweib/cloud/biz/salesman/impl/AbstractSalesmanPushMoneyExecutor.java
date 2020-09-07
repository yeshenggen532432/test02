package com.qweib.cloud.biz.salesman.impl;

import com.qweib.cloud.biz.salesman.PushMoneyInvoker;
import com.qweib.cloud.biz.salesman.SalesmanPushMoneyExecutor;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.input.SalesmanPushMoneyQuery;
import com.qweib.cloud.biz.salesman.service.SalesmanService;
import com.qweib.cloud.utils.SpringContextHolder;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 11:41
 */
public abstract class AbstractSalesmanPushMoneyExecutor<T, S> implements SalesmanPushMoneyExecutor<S> {

    /**
     * 导入不同的执行器
     */
    protected final PushMoneyInvoker<T> invoker;

    public AbstractSalesmanPushMoneyExecutor(PushMoneyInvoker<T> invoker) {
        this.invoker = invoker;
    }

    @Override
    public void execute(String database, SalesmanPushMoneyQuery query) {
        this.invoker.initial();
        SalesmanService salesmanService = SpringContextHolder.getBean(SalesmanService.class);
        /**
         * 查询原始数据
         */
        final List<BillPriceDTO> billPriceDTOS = salesmanService.queryBillWareList(database, query);

        doExecute(billPriceDTOS);
    }

    protected abstract void doExecute(List<BillPriceDTO> billPriceDTOS);

}
