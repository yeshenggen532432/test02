package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;

/**
 * 客户价格导出
 * CustomerPriceModel转移过来
 */
@Data
public class DownCustomerPriceVo extends ImportBaseVo {

    @ModelProperty(label = "客户名称")
    private String customerName;

    //暂时无用
    //@ModelProperty(label = "客户地址")
    //private String customerAddress;

    @ModelProperty(label = "商品名称")
    private String productName;

    @ModelProperty(label = "大单位")
    private String bigUnitName;
    @ModelProperty(label = "规格(大)")
    private String bigUnitSpec;
    @ModelProperty(label = "批发价(大)")
    private String bigUnitTradePrice;

    @ModelProperty(label = "商品分类")
    private String productType;

    @ModelProperty(label = "小单位")
    private String smallUnitName;
    @ModelProperty(label = "规格(小)")
    private String smallUnitSpec;
    @ModelProperty(label = "批发价(小)")
    private String smallUnitTradePrice;

    @ModelProperty(label = "大小单位换算比例")
    private Double smallUnitScale;

    private Double bUnit;

    public Double getbUnit() {
        return bUnit;
    }

    public void setbUnit(Double bUnit) {
        this.bUnit = bUnit;
    }
}
