package com.qweib.cloud.biz.system.controller.customer.price;

import com.qweibframework.excel.event.ModelExecutor;
import com.qweibframework.excel.metadata.BaseModel;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:28
 */
public abstract class BaseModelExecutor<T extends BaseModel> implements ModelExecutor<T> {

    public static final String PRODUCT_TYPE_SEPARATOR = "/";

    protected final String database;
    /**
     * 操作人员（业务员 id）
     */
    protected final Integer operatorId;
    /**
     * 统计重复数据
     */
    protected int repeatCount = 0;

    public BaseModelExecutor(String database, Integer operatorId) {
        this.database = database;
        this.operatorId = operatorId;
    }

    @Override
    public int getRepeatCount() {
        return this.repeatCount;
    }
}
