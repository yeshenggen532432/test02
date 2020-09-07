package com.qweib.cloud.core.domain.product;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 10:04
 */
@Data
public class TempProductDTO extends TempProductBaseDTO {

    /**
     * 所属分类
     * category
     */
    private String categoryName;
    /**
     * 商品编号
     * ware_code
     */
    private String productCode;
    /**
     * 大单位名称
     * ware_dw
     */
    private String bigUnitName;
    /**
     * 大单位规格
     * ware_gg
     */
    private String bigUnitSpec;
    /**
     * 大单位换算基数
     * b_Unit
     */
    private Double bigUnitScale;
    /**
     * 大单位条码
     * pack_bar_code
     */
    private String bigBarCode;
    /**
     * 大单位采购价格
     * in_price
     */
    private Double bigPurchasePrice;
    /**
     * 大单位销售单价
     * ware_dj
     */
    private Double bigSalePrice;

    /**
     * 小单位名称
     * min_unit
     */
    private String smallUnitName;
    /**
     * 小单位规格
     * min_Ware_Gg
     */
    private String smallUnitSpec;
    /**
     * 小单位换算基数
     * s_Unit
     */
    private Double smallUnitScale;
    /**
     * 小单位条码
     * be_bar_code
     */
    private String smallBarCode;
    /**
     * 小单位销售价
     * sunit_price
     */
    private Double smallSalePrice;
    /**
     * 保质期
     * quality_Days
     */
    private String expirationDate;
    /**
     * 生产厂家
     * provider_name
     */
    private String providerName;
    /**
     * 备注
     * remark
     */
    private String remark;
    /**
     * 更新人
     */
    private String updatedName;
}
