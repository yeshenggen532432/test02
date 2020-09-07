package com.qweib.cloud.core.domain;

import com.google.common.collect.Lists;
import com.qweib.cloud.utils.TableAnnotation;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * shop_area 地区表
 */
@Data
@ToString
public class SysArea implements Serializable {
    /**
     * 主键ID
     */
    private Integer areaId;
    /**
     * 地区名称
     */
    private String areaName;
    /**
     * 地区父ID
     */
    private Integer areaParentId;
    /**
     * 排序
     */
    private Integer areaSort;
    /**
     * 地区深度，从1开始
     */
    private Integer areaDeep;

    /**
     * 0:未删除;1.已删除
     */
    private int isDel;


    private Integer isShow;

    /**
     * 当前地区的下级地区集合
     */
    private List<SysArea> children = Lists.newArrayList();

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysArea> getChildren() {
        return children;
    }

    public void setChildren(List<SysArea> children) {
        this.children = children;
    }
}
