package com.qweib.cloud.biz.system.controller.customer.price.domain;

import com.qweibframework.excel.annotation.ModelProperty;
import com.qweibframework.excel.metadata.BaseModel;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/22 - 17:59
 */
@Data
public class CustomerPriceModel extends BaseModel {

    @ModelProperty(label = "客户名称")
    private String customerName;
    @ModelProperty(label = "客户地址")
    private String customerAddress;
    @ModelProperty(label = "商品类别")
    private String productType;
    @ModelProperty(label = "商品名称")
    private String productName;

    @ModelProperty(label = "大单位名称")
    private String bigUnitName;
    @ModelProperty(label = "大单位规格")
    private String bigUnitSpec;
    @ModelProperty(label = "大单位批发价")
    private String bigUnitTradePrice;

    @ModelProperty(label = "小单位名称")
    private String smallUnitName;
    @ModelProperty(label = "小单位规格")
    private String smallUnitSpec;
    @ModelProperty(label = "小单位批发价")
    private String smallUnitTradePrice;

    @ModelProperty(label = "小单位换算比例(1:n)")
    private String smallUnitScale;
}
