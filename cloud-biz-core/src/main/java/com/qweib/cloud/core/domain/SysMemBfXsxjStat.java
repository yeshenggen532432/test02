package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

public class SysMemBfXsxjStat {
    private Integer wareId;
    private String wareNm;
    private Integer kcNum;
    private BigDecimal wareRate;
    private BigDecimal saleRate;
    private Integer cstQty;
    //////////////////////////////////
    private  String sdate;
    private  String edate;
    private  String customerType;
    private Integer noCompany;//是否公司产品
    private String hzfsNm;
    private  Integer waretype;

    public Integer getWaretype() {
        return waretype;
    }

    public void setWaretype(Integer waretype) {
        this.waretype = waretype;
    }

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    public Integer getKcNum() {
        return kcNum;
    }

    public void setKcNum(Integer kcNum) {
        this.kcNum = kcNum;
    }

    public BigDecimal getWareRate() {
        return wareRate;
    }

    public void setWareRate(BigDecimal wareRate) {
        this.wareRate = wareRate;
    }

    public BigDecimal getSaleRate() {
        return saleRate;
    }

    public void setSaleRate(BigDecimal saleRate) {
        this.saleRate = saleRate;
    }

    public Integer getCstQty() {
        return cstQty;
    }

    public void setCstQty(Integer cstQty) {
        this.cstQty = cstQty;
    }

    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    public String getEdate() {
        return edate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

    public Integer getNoCompany() {
        return noCompany;
    }

    public void setNoCompany(Integer noCompany) {
        this.noCompany = noCompany;
    }

    public String getHzfsNm() {
        return hzfsNm;
    }

    public void setHzfsNm(String hzfsNm) {
        this.hzfsNm = hzfsNm;
    }
}
