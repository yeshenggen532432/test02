package com.qweib.cloud.biz.salesman.pojo.input;

import lombok.Data;

/**
 * Description: 业务员提成统计条件
 *
 * @author zeng.gui
 * Created on 2019/7/15 - 17:45
 */
@Data
public class SalesmanCountQuery extends BaseSalesmanQuery {

    /**
     * 商品名称
     */
    private String wareName;

    /**
     * 客户名称
     */
    private String customerName;
    /**
     * 业务员姓名
     */
    private String salesmanName;

}
