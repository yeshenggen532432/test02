package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 说明：订单详情
 *
 * @创建：作者:llp 创建时间：2016-3-23
 * @修改历史： [序号](llp 2016 - 3 - 23)<修改说明>
 */
public class SysThorderDetail extends StkBaseSub {
    private Integer id;//订单详情id
    private Integer orderId;//订单id
    private Integer wareId;//商品id
    private Double wareNum;//数量
    private Double wareDj;//单价
    private Double wareZj;//总价
    private String xsTp;//销售类型
    private String wareDw;//单位
    private String remark;//备注
    private String productDate;//生产日期
    //-------------------不在数据库--------------

    private String wareNm;//商品名称
    private String wareGg;//规格
    private String maxUnitCode;//B
    private String minUnitCode;//S
    private String minUnit;//小单位
    private String maxUnit;//大单位
    private Double hsNum;// 换算数量(包装单位到单品单位的转换系数)




    public String getProductDate() {
        return productDate;
    }

    public void setProductDate(String productDate) {
        this.productDate = productDate;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getXsTp() {
        return xsTp;
    }

    public void setXsTp(String xsTp) {
        this.xsTp = xsTp;
    }

    public String getWareDw() {
        return wareDw;
    }

    public void setWareDw(String wareDw) {
        this.wareDw = wareDw;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Double getWareDj() {
        return wareDj;
    }

    public void setWareDj(Double wareDj) {
        this.wareDj = wareDj;
    }

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public Double getWareNum() {
        return wareNum;
    }

    public void setWareNum(Double wareNum) {
        this.wareNum = wareNum;
    }

    public Double getWareZj() {
        return wareZj;
    }

    public void setWareZj(Double wareZj) {
        this.wareZj = wareZj;
    }

    //------------------------------------------------------------------
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareGg() {
        return wareGg;
    }

    public void setWareGg(String wareGg) {
        this.wareGg = wareGg;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMaxUnitCode() {
        return maxUnitCode;
    }

    public void setMaxUnitCode(String maxUnitCode) {
        this.maxUnitCode = maxUnitCode;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMinUnitCode() {
        return minUnitCode;
    }

    public void setMinUnitCode(String minUnitCode) {
        this.minUnitCode = minUnitCode;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMinUnit() {
        return minUnit;
    }

    public void setMinUnit(String minUnit) {
        this.minUnit = minUnit;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMaxUnit() {
        return maxUnit;
    }

    public void setMaxUnit(String maxUnit) {
        this.maxUnit = maxUnit;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    @Override
    public Double getHsNum() {
        return hsNum;
    }

    @Override
    public void setHsNum(Double hsNum) {
        this.hsNum = hsNum;
    }
}
