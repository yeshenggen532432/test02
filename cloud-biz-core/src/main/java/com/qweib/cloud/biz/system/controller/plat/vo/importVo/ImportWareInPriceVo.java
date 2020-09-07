package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;

/**
 * 商品导入(采购模版)
 */
@Data
public class ImportWareInPriceVo extends ImportBaseVo {
    //商品基本
    @ModelProperty(label = "商品名称")
    private String wareNm;

    //大单位基础
    @ModelProperty(label = "规格(大)")
    private String wareGg;
    @ModelProperty(label = "大单位")
    private String wareDw;
    @ModelProperty(label = "采购价(大)")
    private Double inPrice;

    //小单位基础
    @ModelProperty(label = "规格(小)")
    private String minWareGg;
    @ModelProperty(label = "小单位")
    private String minUnit;
    @ModelProperty(label = "采购价(小)")
    private Double minInPrice;

}
