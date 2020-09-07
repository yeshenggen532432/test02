package com.qweib.cloud.biz.salesman;

import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;

/**
 * Description: 销售提成执行器
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 14:52
 */
public interface PushMoneyInvoker<T> {

    /**
     * 初始化操作
     */
    void initial();

    /**
     * 处理单笔数据处理
     *
     * @param billPriceDTO
     * @return
     */
    T invoke(BillPriceDTO billPriceDTO);
}
