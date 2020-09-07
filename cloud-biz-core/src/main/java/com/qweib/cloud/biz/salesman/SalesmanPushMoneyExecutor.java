package com.qweib.cloud.biz.salesman;

import com.qweib.cloud.biz.salesman.pojo.input.SalesmanPushMoneyQuery;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/15 - 18:04
 */
public interface SalesmanPushMoneyExecutor<S> {

    /**
     * 根据查询条件开始执行
     *
     * @param database
     * @param query
     */
    void execute(String database, SalesmanPushMoneyQuery query);

    /**
     * 返回提成结果
     *
     * @return
     */
    List<S> getResultList();
}
