package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

public class SysMemBfStat {
    private Integer memberId;
    private String memberNm;
    private  Integer cstQty;
    private Integer bfQty;
    private Integer bfQty1;
    private BigDecimal bfRate;
    private  Integer wbfQty;
    private  BigDecimal wbfRate;
    private  String sdate;
    private  String edate;
    private  String customerType;
    private Integer noCompany;//是否公司产品
    private String hzfsNm;
    private  String khNm;
    private String regionNm;
    private Integer otherQty;

    private String sort;
    private String order;

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public Integer getOtherQty() {
        return otherQty;
    }

    public void setOtherQty(Integer otherQty) {
        this.otherQty = otherQty;
    }

    public Integer getBfQty1() {
        return bfQty1;
    }

    public void setBfQty1(Integer bfQty1) {
        this.bfQty1 = bfQty1;
    }

    public String getRegionNm() {
        return regionNm;
    }

    public void setRegionNm(String regionNm) {
        this.regionNm = regionNm;
    }

    public String getKhNm() {
        return khNm;
    }

    public void setKhNm(String khNm) {
        this.khNm = khNm;
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

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getCstQty() {
        return cstQty;
    }

    public void setCstQty(Integer cstQty) {
        this.cstQty = cstQty;
    }

    public Integer getBfQty() {
        return bfQty;
    }

    public void setBfQty(Integer bfQty) {
        this.bfQty = bfQty;
    }

    public BigDecimal getBfRate() {
        return bfRate;
    }

    public void setBfRate(BigDecimal bfRate) {
        this.bfRate = bfRate;
    }

    public Integer getWbfQty() {
        return wbfQty;
    }

    public void setWbfQty(Integer wbfQty) {
        this.wbfQty = wbfQty;
    }

    public BigDecimal getWbfRate() {
        return wbfRate;
    }

    public void setWbfRate(BigDecimal wbfRate) {
        this.wbfRate = wbfRate;
    }
}
