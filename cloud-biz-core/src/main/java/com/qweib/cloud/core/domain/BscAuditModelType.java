package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 审批模板类型科目
 * @TableAnnotation(insertAble = false, updateAble = false)
 */
public class BscAuditModelType {
    private Integer id;//自定义id
    private Integer modelId;//审批模板id
    private String subjectType;//一级科目
    private String subjectItem;//二级科目

    //---------------不在数据库-------------------
    private String typeName;//一级科目名称
    private String itemName;//二级科目名称

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getModelId() {
        return modelId;
    }

    public void setModelId(Integer modelId) {
        this.modelId = modelId;
    }

    public String getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(String subjectType) {
        this.subjectType = subjectType;
    }

    public String getSubjectItem() {
        return subjectItem;
    }

    public void setSubjectItem(String subjectItem) {
        this.subjectItem = subjectItem;
    }

    //---------------不在数据库-------------------
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }


}
