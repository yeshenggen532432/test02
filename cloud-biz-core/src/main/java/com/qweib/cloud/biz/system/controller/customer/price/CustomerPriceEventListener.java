package com.qweib.cloud.biz.system.controller.customer.price;

import com.alibaba.excel.context.AnalysisContext;
import com.google.common.collect.Lists;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModel;
import com.qweib.commons.StringUtils;
import com.qweibframework.excel.event.ExcelEventListener;
import com.qweibframework.excel.event.ModelExecutor;
import lombok.extern.slf4j.Slf4j;

/**
 * Description: 客户价格导入事件监听器
 *
 * @author zeng.gui
 * Created on 2019/4/22 - 18:09
 */
@Slf4j
public class CustomerPriceEventListener extends ExcelEventListener<CustomerPriceModel> {

    private static final int BATCH_SIZE = 200;

    public CustomerPriceEventListener(ModelExecutor<CustomerPriceModel> modelExecutor) {
        super(CustomerPriceModel.class, 0, modelExecutor);
    }

    @Override
    public void onHandle(CustomerPriceModel customerPriceModel, Object source, AnalysisContext analysisContext) {
        if (StringUtils.isBlank(customerPriceModel.getCustomerName()) ||
                StringUtils.isBlank(customerPriceModel.getProductName())) {
//            log.error("跳过" + customerPriceModel.getCurrentRow());
            return;
        }

        customerPriceModel.setRowNum(analysisContext.getCurrentRowNum());

        dataList.add(customerPriceModel);
        if (dataList.size() >= BATCH_SIZE) {
            handleModels();
            dataList = Lists.newArrayList();
        }
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        handleModels();
        log.error("finished");
    }
}