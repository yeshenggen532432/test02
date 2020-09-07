package com.qweib.cloud.biz.sms.service;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 15:34
 */
public interface SmsTotalService {

//    /**
//     * 短信充值条数
//     *
//     * @param database
//     * @param type     类型
//     * @param total    数量
//     */
//    void addTotal(String database, Integer type, Integer total);

    /**
     * 短信扣除
     *
     * @param database
     * @param total    数量
     */
    void updateDeductTotal(String database, Integer total);


    /**
     * 查询短信剩余数量
     *
     * @param database
     * @return
     */
    Integer getTotal(String database);
}
