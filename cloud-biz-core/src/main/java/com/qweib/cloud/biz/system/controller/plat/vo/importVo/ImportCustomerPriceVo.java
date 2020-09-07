package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.Pattern;

/**
 * 客户价格导入
 * CustomerPriceModel转移过来
 */
@Data
public class ImportCustomerPriceVo extends ImportBaseVo {

    @NotEmpty(message = "客户名称不能为空")
    @ModelProperty(label = "客户名称")
    private String customerName;

    //暂时无用
    //@ModelProperty(label = "客户地址")
    //private String customerAddress;
    @NotEmpty(message = "商品名称不能为空")
    @ModelProperty(label = "商品名称")
    private String productName;

    @Length(max = 20, message = "规格(大)长度超出限制20位")
    @ModelProperty(label = "规格(大)")
    private String bigUnitSpec;
    @ModelProperty(label = "大单位")
    private String bigUnitName;
    @ModelProperty(label = "批发价(大)")
    private String bigUnitTradePrice;

    @ModelProperty(label = "商品分类")
    private String productType;

    @Length(max = 20, message = "规格(小)长度超出限制20位")
    @ModelProperty(label = "规格(小)")
    private String smallUnitSpec;
    @ModelProperty(label = "小单位")
    private String smallUnitName;
    @ModelProperty(label = "批发价(小)")
    private String smallUnitTradePrice;

    @Pattern(regexp = "^\\s||\\d+(\\.\\d+)?$", message = "换算比例错误")
    @ModelProperty(label = "大小单位换算比例(1:n)")
    private String smallUnitScale;

}
