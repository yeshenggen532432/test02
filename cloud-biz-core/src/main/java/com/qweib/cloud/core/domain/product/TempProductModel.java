package com.qweib.cloud.core.domain.product;

import com.qweibframework.excel.annotation.ModelProperty;
import com.qweibframework.excel.metadata.BaseModel;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 15:58
 */
@Data
public class TempProductModel extends BaseModel {

    /**
     * category_name
     */
    @ModelProperty(label = "所属分类")
    private String categoryName;
    /**
     * ware_code
     */
    @ModelProperty(label = "商品编号")
    private String productCode;
    /**
     * ware_nm
     */
    @ModelProperty(label = "商品名称")
    private String productName;
    /**
     * ware_dw
     */
    @ModelProperty(label = "大单位")
    private String bigUnitName;
    /**
     * ware_gg
     */
    @ModelProperty(label = "规格")
    private String bigUnitSpec;
    /**
     * b_Unit
     */
    @ModelProperty(label = "大单位换算基数")
    private Double bigUnitScale;
    /**
     * pack_bar_code
     */
    @ModelProperty(label = "大单位条码")
    private String bigBarCode;
    /**
     * in_price
     */
    @ModelProperty(label = "采购价格")
    private Double bigPurchasePrice;
    /**
     * ware_dj
     */
    @ModelProperty(label = "销售单价")
    private Double bigSalePrice;

    /**
     * min_unit
     */
    @ModelProperty(label = "小单位")
    private String smallUnitName;
    /**
     * min_Ware_Gg
     */
    @ModelProperty(label = "小单位规格")
    private String smallUnitSpec;
    /**
     * s_Unit
     */
    @ModelProperty(label = "小单位换算基数")
    private Double smallUnitScale;
    /**
     * be_bar_code
     */
    @ModelProperty(label = "小条码")
    private String smallBarCode;
    /**
     * sunit_price
     */
    @ModelProperty(label = "小单位销售价")
    private Double smallSalePrice;
    /**
     * quality_Days
     */
    @ModelProperty(label = "保质期")
    private String expirationDate;
    /**
     * provider_name
     */
    @ModelProperty(label = "生产厂家")
    private String providerName;
    /**
     * remark
     */
    @ModelProperty(label = "商品备注")
    private String remark;

    private Integer updatedBy;
}
