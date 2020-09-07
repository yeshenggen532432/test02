package com.qweib.cloud.biz.attendance.model;

public class KqPrintConfig {
    private Integer id;
    private String fdFieldKey;//字段
    private String fdFieldName;//字段显示名称
    private String fdModel;//所属业务Model
    private Integer fdStatus;//是否启用
    private String fdTplId;//预留字段
    private Integer orderCd;//排序
    private Integer fdWidth;//长度
    private Integer fdHeight;
    private Integer fdFontsize;
    private Integer fdDecimals; //小数位
    private Integer fdAlign; //对其方式 0/null: center; 1: left 2:right;

    public Integer getOrderCd() {
        return orderCd;
    }
    public void setOrderCd(Integer orderCd) {
        this.orderCd = orderCd;
    }
    public Integer getFdWidth() {
        return fdWidth;
    }
    public void setFdWidth(Integer fdWidth) {
        this.fdWidth = fdWidth;
    }
    public KqPrintConfig() {
    }
    public String getFdFieldKey() {
        return fdFieldKey;
    }
    public void setFdFieldKey(String fdFieldKey) {
        this.fdFieldKey = fdFieldKey;
    }
    public String getFdFieldName() {
        return fdFieldName;
    }
    public void setFdFieldName(String fdFieldName) {
        this.fdFieldName = fdFieldName;
    }
    public String getFdModel() {
        return fdModel;
    }
    public void setFdModel(String fdModel) {
        this.fdModel = fdModel;
    }
    public Integer getFdStatus() {
        return fdStatus;
    }
    public void setFdStatus(Integer fdStatus) {
        this.fdStatus = fdStatus;
    }
    public String getFdTplId() {
        return fdTplId;
    }
    public void setFdTplId(String fdTplId) {
        this.fdTplId = fdTplId;
    }
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFdHeight() {
        return fdHeight;
    }

    public void setFdHeight(Integer fdHeight) {
        this.fdHeight = fdHeight;
    }

    public Integer getFdFontsize() {
        return fdFontsize;
    }

    public void setFdFontsize(Integer fdFontsize) {
        this.fdFontsize = fdFontsize;
    }

    public Integer getFdDecimals() {
        return fdDecimals;
    }

    public void setFdDecimals(Integer fdDecimals) {
        this.fdDecimals = fdDecimals;
    }

    public Integer getFdAlign() {
        return fdAlign;
    }

    public void setFdAlign(Integer fdAlign) {
        this.fdAlign = fdAlign;
    }
}
