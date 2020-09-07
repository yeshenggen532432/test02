package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;

/**
 * 商品导入(大单位模版)
 */
@Data
public class ImportWareBigUnitVo extends ImportBaseVo {
    //商品基本
    @ModelProperty(label = "商品编号")
    private String wareCode;
    @ModelProperty(label = "商品名称")
    private String wareNm;
    @ModelProperty(label = "所属分类")
    private String waretypeNm;

    //大单位基础
    @ModelProperty(label = "规格(大)")
    private String wareGg;
    @ModelProperty(label = "大单位")
    private String wareDw;
    @ModelProperty(label = "单位条码(大)")
    private String packBarCode;
    @ModelProperty(label = "销售原价(大)")
    private Double lsPrice;
    @ModelProperty(label = "批发价(大)")
    private Double wareDj;
    @ModelProperty(label = "采购价(大)")
    private Double inPrice;

    //其它
    @ModelProperty(label = "保质期")
    private String qualityDays;
    @ModelProperty(label = "生产厂家")
    private String providerName;
    @ModelProperty(label = "商品备注")
    private String remark;

    @ModelProperty(label = "排序")
    private Integer sort;

    //等级价格...........从数据读取
    //private Map<String, Object> levelPrice;
}
