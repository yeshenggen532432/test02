package com.qweib.cloud.biz.salesman.pojo.input;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 15:22
 */
@Data
public class SalesmanPushMoneyQuery extends BaseSalesmanQuery {

    /**
     * 业务员 id
     */
    private Integer salesmanId;
    /**
     * 业务员姓名
     */
    private String salesmanName;

    /**
     * 客户 id
     */
    private Integer customerId;
    /**
     * 客户名称
     */
    private String customerName;
    /**
     * 商品 id
     */
    private Integer wareId;
    /**
     * 商品名称
     */
    private String wareName;
}
