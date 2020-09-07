package com.qweib.cloud.core.domain;

import java.util.List;

public class SysMallShopVo {
    private String companyId;
    private String shopName;
    private String shopLogo;
    private List<SysWare> wareList;
    private String datasource;
    private String address;
    private Integer wareQty;

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getShopLogo() {
        return shopLogo;
    }

    public void setShopLogo(String shopLogo) {
        this.shopLogo = shopLogo;
    }

    public List<SysWare> getWareList() {
        return wareList;
    }

    public void setWareList(List<SysWare> wareList) {
        this.wareList = wareList;
    }

    public String getDatasource() {
        return datasource;
    }

    public void setDatasource(String datasource) {
        this.datasource = datasource;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getWareQty() {
        return wareQty;
    }

    public void setWareQty(Integer wareQty) {
        this.wareQty = wareQty;
    }
}
