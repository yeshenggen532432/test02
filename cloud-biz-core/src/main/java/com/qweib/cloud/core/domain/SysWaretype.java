package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 说明：商品分类
 *
 * @创建：作者:llp 创建时间：2016-3-22
 * @修改历史： [序号](llp 2016 - 3 - 22)<修改说明>
 */
public class SysWaretype {

    private Integer waretypeId;//分类id
    private String waretypeNm;//分类名称
    private Integer waretypePid;//所属分类
    private String waretypePath;//分类路径
    private String waretypeLeaf;//分类末级
    private Integer noCompany;//是否非公司产品类别   1:非公司产品类别
    private Integer shopQy;//该商品分类是否在商城启用：0不启动，1启用 2:部分选中
    private Integer isType;//类别属性  0：库存商品   1:原辅材料 2:低值易耗品  3：固定资产
    private Integer sort;//排序
    /************************不在数据库*******************************/
    private String upWaretypeNm;
    private List<SysWaretype> list2;
    private List<SysWare> list3;
    private List<SysWaretypePic> waretypePicList;//商品列表图片

    public Integer getNoCompany() {
        return noCompany;
    }

    public void setNoCompany(Integer noCompany) {
        this.noCompany = noCompany;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysWaretype> getList2() {
        return list2;
    }

    public void setList2(List<SysWaretype> list2) {
        this.list2 = list2;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysWare> getList3() {
        return list3;
    }

    public void setList3(List<SysWare> list3) {
        this.list3 = list3;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getUpWaretypeNm() {
        return upWaretypeNm;
    }

    public void setUpWaretypeNm(String upWaretypeNm) {
        this.upWaretypeNm = upWaretypeNm;
    }

    public Integer getWaretypeId() {
        return waretypeId;
    }

    public void setWaretypeId(Integer waretypeId) {
        this.waretypeId = waretypeId;
    }

    @TableAnnotation(nullToUpdate = false, updateAble = false)
    public String getWaretypeLeaf() {
        return waretypeLeaf;
    }

    public void setWaretypeLeaf(String waretypeLeaf) {
        this.waretypeLeaf = waretypeLeaf;
    }

    public String getWaretypeNm() {
        return waretypeNm;
    }

    public void setWaretypeNm(String waretypeNm) {
        this.waretypeNm = waretypeNm;
    }

    @TableAnnotation(nullToUpdate = false, updateAble = false)
    public String getWaretypePath() {
        return waretypePath;
    }

    public void setWaretypePath(String waretypePath) {
        this.waretypePath = waretypePath;
    }

    @TableAnnotation(nullToUpdate = false, updateAble = false)
    public Integer getWaretypePid() {
        return waretypePid;
    }

    public void setWaretypePid(Integer waretypePid) {
        this.waretypePid = waretypePid;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysWaretypePic> getWaretypePicList() {
        return waretypePicList;
    }

    public void setWaretypePicList(List<SysWaretypePic> waretypePicList) {
        this.waretypePicList = waretypePicList;
    }

    public Integer getShopQy() {
        return shopQy;
    }

    public void setShopQy(Integer shopQy) {
        this.shopQy = shopQy;
    }

    public Integer getIsType() {
        return isType;
    }

    public void setIsType(Integer isType) {
        this.isType = isType;
    }

    //过滤不需要商品IDS
    private String noInWareTypeIds;

    private String waretypeIds;

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getNoInWareTypeIds() {
        return noInWareTypeIds;
    }

    public void setNoInWareTypeIds(String noInWareTypeIds) {
        this.noInWareTypeIds = noInWareTypeIds;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWaretypeIds() {
        return waretypeIds;
    }

    public void setWaretypeIds(String waretypeIds) {
        this.waretypeIds = waretypeIds;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}
