package com.qweib.cloud.core.domain.product;

import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import lombok.Data;
import org.apache.commons.beanutils.PropertyUtils;

import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/24 - 19:12
 */
@Data
public class BaseProduct {

    private Integer id;
    private String name;

    //大单位名称和规格
    private String wareDw;
    private String wareGg;

    //小单位名称和规格
    private String minUnit;
    private String minWareGg;

    //大单位换算比例
    private Double bUnit;
    //小单位换算比例
    private Double sUnit;
    //分类ID
    private Integer typeId;

    public BaseProduct() {

    }

    public BaseProduct(Integer id, Object t) {
        this.id = id;

        try {
            if (PropertyUtils.isReadable(t, "productName"))
                this.name = emptyToSpace(PropertyUtils.getProperty(t, "productName"));
            if (PropertyUtils.isReadable(t, "bigUnitName"))
                this.wareDw = emptyToSpace(PropertyUtils.getProperty(t, "bigUnitName"));
            if (PropertyUtils.isReadable(t, "bigUnitSpec"))
                this.wareGg = emptyToSpace(PropertyUtils.getProperty(t, "bigUnitSpec"));
            if (PropertyUtils.isReadable(t, "smallUnitName"))
                this.minUnit = emptyToSpace(PropertyUtils.getProperty(t, "smallUnitName"));
            if (PropertyUtils.isReadable(t, "smallUnitSpec"))
                this.minWareGg = emptyToSpace(PropertyUtils.getProperty(t, "smallUnitSpec"));
            if (PropertyUtils.isReadable(t, "smallUnitScale"))
                this.sUnit = StringUtils.toDouble(PropertyUtils.getProperty(t, "smallUnitScale"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /* */

    /**
     * 验证是否和数据库有变动
     *
     * @param productData
     * @param baseProduct
     * @return
     */
    public static boolean isChange(ProductData productData, BaseProduct baseProduct) {
        try {
            if (productData.getTypeId() != null && !Objects.equals(productData.getTypeId(), baseProduct.getTypeId()))
                return true;
            if (StringUtils.isNotBlank(productData.getBigUnitName()) && !emptyToSpace(productData.getBigUnitName()).equals(baseProduct.getWareDw()))
                return true;
            if (StringUtils.isNotBlank(productData.getBigUnitSpec()) && !emptyToSpace(productData.getBigUnitSpec()).equals(baseProduct.getWareGg()))
                return true;
            if (StringUtils.isNotBlank(productData.getSmallUnitName()) && !emptyToSpace(productData.getSmallUnitName()).equals(baseProduct.getMinUnit()))
                return true;
            if (StringUtils.isNotBlank(productData.getSmallUnitSpec()) && !emptyToSpace(productData.getSmallUnitSpec()).equals(baseProduct.getMinWareGg()))
                return true;
            Double smallUnitScale = productData.getSmallUnitScale();
            Double sunit = baseProduct.getsUnit();
            if (smallUnitScale != null && !Objects.equals(smallUnitScale, sunit))
                return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static String emptyToSpace(Object str) {
        return StrUtil.isNull(str) ? "" : str.toString().trim();
    }

    public Double getbUnit() {
        return bUnit;
    }

    public void setbUnit(Double bUnit) {
        this.bUnit = bUnit;
    }

    public Double getsUnit() {
        return sUnit;
    }

    public void setsUnit(Double sUnit) {
        this.sUnit = sUnit;
    }
}
