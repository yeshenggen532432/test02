package com.qweib.cloud.core.domain.vo;

import com.qweib.cloud.core.domain.SysBforderDetail;

/**
 * 说明：订单详情
 *
 * @创建：作者:llp 创建时间：2016-3-23
 * @修改历史： [序号](llp 2016 - 3 - 23)<修改说明>
 */
public class ShopBforderDetail extends SysBforderDetail {
    //-------------------最新商品规格和单位--------------

    private String newWareDw;//大单位名称
    private String newWareGg;//大单位规格

    private String newMinUnit;//小单位名称
    private String newMinWareGg;//小单位规格


    private Double shopWarePrice;//自营商城商品大单位批发价
    private Double shopWareLsPrice;//自营商城商品大单位零售价

    private Double shopWareSmallPrice;//自营商城商品小单位批发价
    private Double shopWareSmallLsPrice;//自营商城商品小单位零售价

    public String getNewWareDw() {
        return newWareDw;
    }

    public void setNewWareDw(String newWareDw) {
        this.newWareDw = newWareDw;
    }

    public String getNewWareGg() {
        return newWareGg;
    }

    public void setNewWareGg(String newWareGg) {
        this.newWareGg = newWareGg;
    }

    public String getNewMinUnit() {
        return newMinUnit;
    }

    public void setNewMinUnit(String newMinUnit) {
        this.newMinUnit = newMinUnit;
    }

    public String getNewMinWareGg() {
        return newMinWareGg;
    }

    public void setNewMinWareGg(String newMinWareGg) {
        this.newMinWareGg = newMinWareGg;
    }

    public Double getShopWarePrice() {
        return shopWarePrice;
    }

    public void setShopWarePrice(Double shopWarePrice) {
        this.shopWarePrice = shopWarePrice;
    }

    public Double getShopWareLsPrice() {
        return shopWareLsPrice;
    }

    public void setShopWareLsPrice(Double shopWareLsPrice) {
        this.shopWareLsPrice = shopWareLsPrice;
    }

    public Double getShopWareSmallPrice() {
        return shopWareSmallPrice;
    }

    public void setShopWareSmallPrice(Double shopWareSmallPrice) {
        this.shopWareSmallPrice = shopWareSmallPrice;
    }

    public Double getShopWareSmallLsPrice() {
        return shopWareSmallLsPrice;
    }

    public void setShopWareSmallLsPrice(Double shopWareSmallLsPrice) {
        this.shopWareSmallLsPrice = shopWareSmallLsPrice;
    }
}
