package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;


public class SysDepart {
    private Integer branchId;//部门ID
    private String branchName; //部门名称
    private Integer parentId; //父部门ID
    private String branchMemo;//备注
    private String branchLeaf; //末级分类(末级1;不是末级0)
    private String branchPath;//部门ID路径（如：-1-2-）
    private String swSb;//上午上班时间
    private String swXb;//上午下班时间
    private String xwSb;//下午上班时间
    private String xwXb;//下午下班时间
    //---------------------不在数据库-------------------
    private String branchPName;
    private String branchName1;
    private List<SysDepart> departls2;
    private List<SysMemDTO> memls2;
    private List<SysMemDTO> memls3;

    private String ischild;//是否有子部门 1 有 2 无
    private Integer num; //人员数

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public String getSwSb() {
        return swSb;
    }

    public void setSwSb(String swSb) {
        this.swSb = swSb;
    }

    public String getSwXb() {
        return swXb;
    }

    public void setSwXb(String swXb) {
        this.swXb = swXb;
    }

    public String getXwSb() {
        return xwSb;
    }

    public void setXwSb(String xwSb) {
        this.xwSb = xwSb;
    }

    public String getXwXb() {
        return xwXb;
    }

    public void setXwXb(String xwXb) {
        this.xwXb = xwXb;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getIschild() {
        return ischild;
    }

    public void setIschild(String ischild) {
        this.ischild = ischild;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysDepart> getDepartls2() {
        return departls2;
    }

    public void setDepartls2(List<SysDepart> departls2) {
        this.departls2 = departls2;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysMemDTO> getMemls3() {
        return memls3;
    }

    public void setMemls3(List<SysMemDTO> memls3) {
        this.memls3 = memls3;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysMemDTO> getMemls2() {
        return memls2;
    }

    public void setMemls2(List<SysMemDTO> memls2) {
        this.memls2 = memls2;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getBranchName1() {
        return branchName1;
    }

    public void setBranchName1(String branchName1) {
        this.branchName1 = branchName1;
    }

    public String getBranchPath() {
        return branchPath;
    }

    public void setBranchPath(String branchPath) {
        this.branchPath = branchPath;
    }

    public String getBranchLeaf() {
        return branchLeaf;
    }

    public void setBranchLeaf(String branchLeaf) {
        this.branchLeaf = branchLeaf;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getBranchPName() {
        return branchPName;
    }

    public void setBranchPName(String branchPName) {
        this.branchPName = branchPName;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getBranchId() {
        return branchId;
    }

    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }

    public String getBranchMemo() {
        return branchMemo;
    }

    public void setBranchMemo(String branchMemo) {
        this.branchMemo = branchMemo;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }


}
