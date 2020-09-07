package com.qweib.cloud.biz.system.controller.product.excel;

import com.alibaba.excel.context.AnalysisContext;
import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.product.TempProductModel;
import com.qweib.commons.StringUtils;
import com.qweibframework.excel.event.ExcelEventListener;
import com.qweibframework.excel.event.ModelExecutor;
import lombok.extern.slf4j.Slf4j;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:12
 */
@Slf4j
public class TempProductEventListener extends ExcelEventListener<TempProductModel> {

    private static final int BATCH_SIZE = 200;

    public TempProductEventListener(ModelExecutor<TempProductModel> modelExecutor) {
        super(TempProductModel.class, 0, modelExecutor);
    }

    @Override
    public void onHandle(TempProductModel model, Object source, AnalysisContext context) {
        if (StringUtils.isBlank(model.getProductName())) {
            return;
        }

        dataList.add(model);
        if (dataList.size() >= BATCH_SIZE) {
            handleModels();
            dataList = Lists.newArrayList();
        }
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        handleModels();
    }

}
