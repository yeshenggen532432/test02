package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 15:05
 */
@Data
public abstract class BaseResultDTO {

    /**
     * 单据编号
     */
    private String billNo;
    /**
     * 单据类型
     */
    private String billType;

    /**
     * 业务员 id
     */
    private Integer salesmanId;
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
     * 产品 id
     */
    private Integer wareId;
    /**
     * 商品名称
     */
    private String wareName;
    /**
     * 单位
     */
    private String unitName;
}
