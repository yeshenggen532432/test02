package com.qweib.cloud.core.domain.product;

import lombok.Data;

/**
 * Description: 批量导入产品数据
 *
 * @author zeng.gui
 * Created on 2019/4/23 - 11:11
 */
@Data
public class ProductData {

    private Integer typeId;
    private String productCode;
    private String productName;
    private String productPinYin;

    private String bigUnitName;
    private String bigUnitSpec;
    private Double bigUnitScale;

    private String smallUnitName;
    private String smallUnitSpec;
    private Double smallUnitScale;
    /**
     * 换算比例
     */
    private Double conversionProportion;

    private String publishTime;
}
