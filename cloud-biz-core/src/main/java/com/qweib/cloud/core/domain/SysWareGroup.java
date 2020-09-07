package com.qweib.cloud.core.domain;

/**
 * @author: yueji.hu
 * @time: 2019-09-05 11:37
 * @description:
 */
public class SysWareGroup {
    private Integer id;
    private String groupName;
    private String remark;
    private String wareNm;//商品名称
    private String attribute;//属性
    private Integer wareId;//商品id

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public String getAttribute() {
        return attribute;
    }

    public void setAttribute(String attribute) {
        this.attribute = attribute;
    }

    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}
