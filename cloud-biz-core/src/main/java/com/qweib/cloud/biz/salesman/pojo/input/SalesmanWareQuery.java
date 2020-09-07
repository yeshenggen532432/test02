package com.qweib.cloud.biz.salesman.pojo.input;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * Description: 业务员详情
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 15:18
 */
@Data
public class SalesmanWareQuery extends BaseSalesmanQuery {

    /**
     * 业务员 id
     */
    @NotNull
    private Integer salesmanId;
    /**
     * 客户名称
     */
    private Integer customerId;

    /**
     * 商品名称
     */
    private Integer wareId;
}
