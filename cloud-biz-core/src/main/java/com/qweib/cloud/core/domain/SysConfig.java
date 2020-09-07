package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

public class SysConfig {
    private Integer id;
    private String code;//关键健值
    private String name;//名称
    private String status;//状态 0:不启用 1:启用
    private String fdModel;//所属模块

    private String systemGroupCode; // 系统分组 code

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getFdModel() {
        return fdModel;
    }

    public void setFdModel(String fdModel) {
        this.fdModel = fdModel;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSystemGroupCode() {
        return systemGroupCode;
    }

    public void setSystemGroupCode(String systemGroupCode) {
        this.systemGroupCode = systemGroupCode;
    }
}
