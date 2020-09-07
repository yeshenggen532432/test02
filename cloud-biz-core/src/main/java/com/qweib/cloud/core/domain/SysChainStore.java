package com.qweib.cloud.core.domain;

/**
 * @author: yueji.hu
 * @time: 2019-09-06 14:57
 * @description:
 */
public class SysChainStore {
    private Integer id;
    private String storeName;
    private String remark;
    private Integer status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
