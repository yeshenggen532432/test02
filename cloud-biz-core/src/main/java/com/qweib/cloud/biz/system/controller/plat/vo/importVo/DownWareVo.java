package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 商品导出
 */
@Data
public class DownWareVo extends ImportBaseVo {
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

    //小单位基础
    @ModelProperty(label = "规格(小)")
    private String minWareGg;
    @ModelProperty(label = "小单位")
    private String minUnit;
    @ModelProperty(label = "单位条码(小)")
    private String beBarCode;
    @ModelProperty(label = "销售原价(小)")
    private Double minLsPrice;
    @ModelProperty(label = "批发价(小)")
    private BigDecimal sunitPrice;
    @ModelProperty(label = "采购价(小)")
    private Double minInPrice;
    @ModelProperty(label = "大小单位换算比例")
    private Double sUnit;

    //其它
    @ModelProperty(label = "保质期")
    private String qualityDays;
    @ModelProperty(label = "生产厂家")
    private String providerName;
    @ModelProperty(label = "商品备注")
    private String remark;

    @ModelProperty(label = "排序")
    private Integer sort;
    //以下暂无实际用处
    private Double bUnit;

    public Double getsUnit() {
        return sUnit;
    }

    public void setsUnit(Double sUnit) {
        this.sUnit = sUnit;
    }

    public Double getbUnit() {
        return bUnit;
    }

    public void setbUnit(Double bUnit) {
        this.bUnit = bUnit;
    }
}
