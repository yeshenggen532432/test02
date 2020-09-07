package com.qweib.cloud.biz.customer.duplicate;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 10:10
 */
public interface DataReceiver {

    /**
     * 获取各模块数据
     *
     * @param database     数据库
     * @param customerName 比较名称
     * @return
     */
    List<CustomerDTO> getDatas(String database, String customerName);
}
