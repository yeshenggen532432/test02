package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 企业端设置的快捷菜单
 */
public class SysQuickMenu {
    private Integer id;
    private Integer menuId;//关联菜单ID
    private Integer memberId;//员工ID
    private String  customName;//自定义菜单名称
    private String createTime;//创建日期;

    private String menuName;
    private String applyIcon;
    private String applyUrl;
    private Integer sort;//排序

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMenuId() {
        return menuId;
    }

    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getCustomName() {
        return customName;
    }

    public void setCustomName(String customName) {
        this.customName = customName;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getApplyIcon() {
        return applyIcon;
    }

    public void setApplyIcon(String applyIcon) {
        this.applyIcon = applyIcon;
    }
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getApplyUrl() {
        return applyUrl;
    }

    public void setApplyUrl(String applyUrl) {
        this.applyUrl = applyUrl;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

}
