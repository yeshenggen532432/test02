package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 客户类型对应商品信息价格设置
 */
public class SysQdTypePrice {
    private Integer id;//
    private Integer relaId;
    private Integer wareId;
    private String price;//大单位批发价
    private String status;

    private BigDecimal rate;

    private Double lsPrice; //零售价--进销存：大单位零售价
    private Double fxPrice;//分销价--进销存:大单位分销价
    private Double cxPrice;//促销价--进销存:大单位促销价
    private Double sunitPrice;//小单位销售价--进销存：小单位批发价
    private Double minLsPrice;//小单位零售价--进销存：小单位零售价
    private Double minFxPrice;//小单位分销价--进销存：小单位分销价
    private Double minCxPrice;//小单位促销价--进销存：小单位促销价

    private String wareNm;
    private String relaIds;//等级IDS

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getRelaIds() {
        return relaIds;
    }

    public void setRelaIds(String relaIds) {
        this.relaIds = relaIds;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getRelaId() {
        return relaId;
    }

    public void setRelaId(Integer relaId) {
        this.relaId = relaId;
    }

    public Double getLsPrice() {
        return lsPrice;
    }

    public void setLsPrice(Double lsPrice) {
        this.lsPrice = lsPrice;
    }

    public Double getFxPrice() {
        return fxPrice;
    }

    public void setFxPrice(Double fxPrice) {
        this.fxPrice = fxPrice;
    }

    public Double getCxPrice() {
        return cxPrice;
    }

    public void setCxPrice(Double cxPrice) {
        this.cxPrice = cxPrice;
    }

    public Double getSunitPrice() {
        return sunitPrice;
    }

    public void setSunitPrice(Double sunitPrice) {
        this.sunitPrice = sunitPrice;
    }

    public Double getMinLsPrice() {
        return minLsPrice;
    }

    public void setMinLsPrice(Double minLsPrice) {
        this.minLsPrice = minLsPrice;
    }

    public Double getMinFxPrice() {
        return minFxPrice;
    }

    public void setMinFxPrice(Double minFxPrice) {
        this.minFxPrice = minFxPrice;
    }

    public Double getMinCxPrice() {
        return minCxPrice;
    }

    public void setMinCxPrice(Double minCxPrice) {
        this.minCxPrice = minCxPrice;
    }

    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }
}
