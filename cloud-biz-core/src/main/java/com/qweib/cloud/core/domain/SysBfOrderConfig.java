package com.qweib.cloud.core.domain;

public class SysBfOrderConfig {

    private String  autoPrice;//1.历史价; 其他为执行价
    private Boolean editPrice;//价格是否可以编辑

    public String getAutoPrice() {
        return autoPrice;
    }

    public void setAutoPrice(String autoPrice) {
        this.autoPrice = autoPrice;
    }

    public Boolean getEditPrice() {
        return editPrice;
    }

    public void setEditPrice(Boolean editPrice) {
        this.editPrice = editPrice;
    }
}
