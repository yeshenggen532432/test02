package com.qweib.cloud.core.domain;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.qweib.cloud.utils.TableAnnotation;

import java.io.Serializable;

/**
 * 移动端应用表
 *
 * @author Administrator
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SysApplyDTO implements Serializable {

    private static final long serialVersionUID = 1L;


    private Integer id;  //自增id
    private String applyName;//应用名称
    private String applyCode;//应用编码
    private String applyIcon;//应用图标
    private String applyDesc;//应用描述
    private String applyIfwap;//应用类型
    private String applyUrl;//URL访问地址
    private Integer applyNo;//排序
    @JsonProperty(value = "PId")
    private Integer pId;//父级应用
    private String menuTp;//菜单类型 0--功能菜单  1-功能按钮（最后一级）
    private String menuLeaf;//是否明细菜单  0--否  1--是
    private String createBy;//创建者
    private String createDate;//创建时间
    private String isUse;//是否启用 0否 1 是
    private Integer menuId;//菜单id
    private String specificTag; // 特殊标识
    private String sgtjz;//四个报表限权
    private String mids;//用户id组
    //////
    private String tp;//1 菜单  2 应用
    private String menuNm;//菜单名称
    private String dataTp;//关联类型 1 全部 2 部门及子部门 3 个人
    private String ifCheck;//0隐藏
    private Integer isMeApply;


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMids() {
        return mids;
    }

    public void setMids(String mids) {
        this.mids = mids;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSgtjz() {
        return sgtjz;
    }

    public void setSgtjz(String sgtjz) {
        this.sgtjz = sgtjz;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPId() {
        return pId;
    }

    public void setPId(Integer id) {
        pId = id;
    }

    public String getMenuTp() {
        return menuTp;
    }

    public void setMenuTp(String menuTp) {
        this.menuTp = menuTp;
    }

    public String getMenuLeaf() {
        return menuLeaf;
    }

    public void setMenuLeaf(String menuLeaf) {
        this.menuLeaf = menuLeaf;
    }

    public String getApplyName() {
        return applyName;
    }

    public void setApplyName(String applyName) {
        this.applyName = applyName;
    }

    public String getApplyCode() {
        return applyCode;
    }

    public void setApplyCode(String applyCode) {
        this.applyCode = applyCode;
    }

    public String getApplyIcon() {
        return applyIcon;
    }

    public void setApplyIcon(String applyIcon) {
        this.applyIcon = applyIcon;
    }

    public String getApplyDesc() {
        return applyDesc;
    }

    public void setApplyDesc(String applyDesc) {
        this.applyDesc = applyDesc;
    }

    public String getApplyIfwap() {
        return applyIfwap;
    }

    public void setApplyIfwap(String applyIfwap) {
        this.applyIfwap = applyIfwap;
    }

    public String getApplyUrl() {
        return applyUrl;
    }

    public void setApplyUrl(String applyUrl) {
        this.applyUrl = applyUrl;
    }

    public Integer getApplyNo() {
        return applyNo;
    }

    public void setApplyNo(Integer applyNo) {
        this.applyNo = applyNo;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public String getIsUse() {
        return isUse;
    }

    public void setIsUse(String isUse) {
        this.isUse = isUse;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public Integer getMenuId() {
        return menuId;
    }

    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    public String getSpecificTag() {
        return specificTag;
    }

    public void setSpecificTag(String specificTag) {
        this.specificTag = specificTag;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMenuNm() {
        return menuNm;
    }

    public void setMenuNm(String menuNm) {
        this.menuNm = menuNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getDataTp() {
        return dataTp;
    }

    public void setDataTp(String dataTp) {
        this.dataTp = dataTp;
    }

    public String getIfCheck() {
        return ifCheck;
    }

    public void setIfCheck(String ifCheck) {
        this.ifCheck = ifCheck;
    }

    public Integer getIsMeApply() {
        return isMeApply;
    }

    public void setIsMeApply(Integer isMeApply) {
        this.isMeApply = isMeApply;
    }
}
