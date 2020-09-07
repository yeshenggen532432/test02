package com.qweib.cloud.utils;

import com.qweibframework.commons.MathUtils;

import java.math.BigDecimal;

/**
 * @author zzx
 * @version 1.1 2020/4/3
 * @description:
 */
public class ShopWareUtil {

    /**
     * 商城基础大单位零售价04-03
     *
     * @param lsPrice              大单位零售价（进）
     * @param minLsPrice           小单位零售价（进）
     * @param shopWareLsPrice      大单位零售价（商城）
     * @param shopWareSmallLsPrice 小单位零售价（商城）
     * @param hsNum                换算比例
     * @param baseLsRate           零售系数
     * @return
     */
    public static BigDecimal getShopBaseMaxLsPrice(Double lsPrice, Double minLsPrice, Double shopWareLsPrice, Double shopWareSmallLsPrice, Double hsNum, BigDecimal baseLsRate) {
        if (MathUtils.valid(shopWareLsPrice) || MathUtils.valid(shopWareSmallLsPrice)) {//商城大小单位零售价不为空时
            return MathUtils.valid(shopWareLsPrice) ? BigDecimal.valueOf(shopWareLsPrice) : MathUtils.multiply(shopWareSmallLsPrice, hsNum);
        } else if (MathUtils.valid(lsPrice) || MathUtils.valid(minLsPrice)) {
            if (MathUtils.valid(baseLsRate)) {
                if (MathUtils.valid(lsPrice)) {
                    return MathUtils.divideByScale(MathUtils.multiply(lsPrice, baseLsRate), 100, 2);
                } else {
                    return MathUtils.multiply(minLsPrice, hsNum, 2);
                    //return MathUtils.divideByScale(MathUtils.multiply(lsPrice, baseLsRate), 100, 2);
                }
            } else {
                return lsPrice == null ? null : BigDecimal.valueOf(lsPrice);
            }
        }
        return null;

    }

    /**
     *
     * @param wareDj 大单位批发价
     * @param sunitPrice 小单价批发价
     * @param shopWarePrice 商城大单位批发价
     * @param shopWareSmallPrice 商城小单位批发价
     * @param hsNum 换算系数
     * @return
     */

    public static BigDecimal getShopBaseMaxPfPrice(Double wareDj, Double sunitPrice, Double shopWarePrice, Double shopWareSmallPrice, Double hsNum,BigDecimal basePfRate) {
        if (MathUtils.valid(shopWarePrice) || MathUtils.valid(shopWareSmallPrice)) {//商城大小单位零售价不为空时
            return MathUtils.valid(shopWarePrice) ? BigDecimal.valueOf(shopWarePrice) : MathUtils.multiply(shopWareSmallPrice, hsNum);
        } else if (MathUtils.valid(wareDj) || MathUtils.valid(sunitPrice)) {
            if (MathUtils.valid(basePfRate)) {
                if (MathUtils.valid(wareDj)) {
                    return MathUtils.divideByScale(MathUtils.multiply(wareDj, basePfRate), 100, 2);
                } else {
                    return MathUtils.multiply(sunitPrice, hsNum, 2);
                    //return MathUtils.divideByScale(MathUtils.multiply(lsPrice, baseLsRate), 100, 2);
                }
            } else {
                return wareDj == null ? null : BigDecimal.valueOf(wareDj);
            }
        }
        return null;

    }

    public static BigDecimal getShopBaseMinLsPrice(Double lsPrice, Double minLsPrice, Double shopWareLsPrice, Double shopWareSmallLsPrice, Double hsNum, BigDecimal baseLsRate) {
        if (MathUtils.valid(shopWareLsPrice) || MathUtils.valid(shopWareSmallLsPrice)) {
            return MathUtils.valid(shopWareSmallLsPrice) ? BigDecimal.valueOf(shopWareSmallLsPrice) : MathUtils.divideByScale(shopWareLsPrice, hsNum, 2);
        } else if (MathUtils.valid(lsPrice) || MathUtils.valid(minLsPrice)) {
            if (MathUtils.valid(baseLsRate)) {
                if (MathUtils.valid(lsPrice)) {
                    return MathUtils.divideByScale(MathUtils.divideByScale(MathUtils.multiply(lsPrice, baseLsRate), 100, 2), hsNum, 2);
                } else {
                    return BigDecimal.valueOf(minLsPrice);
                    //lsPrice = MathUtils.divideByScale(minLsPrice, hsNum, 2).doubleValue();
                    //return MathUtils.divideByScale(MathUtils.divideByScale(MathUtils.multiply(lsPrice, baseLsRate), 100, 2), hsNum, 2);
                }
            } else {
                return minLsPrice == null ? null : BigDecimal.valueOf(minLsPrice);
            }
        }
        return null;
    }

    /**
     * 获取查找商城基础零售价时需要的字段
     *
     * @param pix
     * @return
     */
    public static String getShopBasePriceSqlField(String pix) {
        return " " + pix + ".ls_price," + pix + ".shop_ware_ls_price," + pix + ".min_Ls_Price," + pix + ".shop_ware_small_ls_price," + pix + ".hs_num";
    }
}
