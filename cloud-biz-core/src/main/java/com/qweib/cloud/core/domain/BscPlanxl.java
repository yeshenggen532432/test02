package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 说明：计划线路
 */
public class BscPlanxl {
    private Integer id;//线路id
    private Integer mid;//业务id
    private String xlNm;//线路名称

    //------------------------不在数据库---------------------------
    private Integer num;//客户数
    private List<BscPlanxlDetail> children;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMid() {
        return mid;
    }

    public void setMid(Integer mid) {
        this.mid = mid;
    }

    public String getXlNm() {
        return xlNm;
    }

    public void setXlNm(String xlNm) {
        this.xlNm = xlNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscPlanxlDetail> getChildren() {
        return children;
    }

    public void setChildren(List<BscPlanxlDetail> children) {
        this.children = children;
    }
}
