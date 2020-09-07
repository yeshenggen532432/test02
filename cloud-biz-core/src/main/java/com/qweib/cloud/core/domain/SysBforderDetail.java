package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.TableAnnotation;
import org.apache.commons.beanutils.PropertyUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * 说明：订单详情
 *
 * @创建：作者:llp 创建时间：2016-3-23
 * @修改历史： [序号](llp 2016 - 3 - 23)<修改说明>
 */
public class SysBforderDetail extends StkBaseSub {
    private Integer id;//订单详情id
    private Integer orderId;//订单id
    private Integer wareId;//商品id
    private Double wareNum;//数量
    private Double wareDj;//最终单价(如果存在促销或优惠卷时会扣减)
    private Double wareZj;//总价(最终单价*数量)
    private String xsTp;//销售类型
    private String wareDw;//单位
    private String remark;//备注

    private String detailWareNm;//商品名称zzx
    private String detailWareGg;//规格zzx
    private String detailShopWareAlias;//自营商城商品别称zzx
    private String detailWareDesc;//商品描述zzx
    private BigDecimal wareDjOriginal;//商品原价(如果不存在促销或优惠卷时这个价和wareDj相等)
    private BigDecimal detailPromotionCost;//商品促销总额
    private BigDecimal detailCouponCost;//商品低优惠卷总额

    //-------------------不在数据库--------------
    private String wareNm;//商品名称
    private String wareGg;//规格
    private Double orgPrice;//商品原始价
    private String maxUnitCode;//B
    private String minUnitCode;//S
    private String minUnit;//小单位
    private String maxUnit;//大单位
    private Double hsNum;// 换算数量(包装单位到单品单位的转换系数)
    private String wareDw2;
    private List<SysWarePic> warePicList;//商品图片（备注：微信公众号：订单详情商品有显示图片）

    private List<SysBforderPic> sysBforderPicList;//商品图片（备注：微信公众号：订单详情商品有显示图片）zzx
    private Integer cartId;//购物车ID使用在下单时

    @TableAnnotation(insertAble = false, updateAble = false)
    @Override
    public Double getHsNum() {
        return hsNum;
    }

    @Override
    public void setHsNum(Double hsNum) {
        this.hsNum = hsNum;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMaxUnit() {
        return maxUnit;
    }

    public void setMaxUnit(String maxUnit) {
        this.maxUnit = maxUnit;
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
    public String getWareDw2() {
        return wareDw2;
    }

    public void setWareDw2(String wareDw2) {
        this.wareDw2 = wareDw2;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getOrgPrice() {
        return orgPrice;
    }

    public void setOrgPrice(Double orgPrice) {
        this.orgPrice = orgPrice;
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

    //直接做快照zzx 05-15
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

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysBforderPic> getSysBforderPicList() {
        return sysBforderPicList;
    }

    public void setSysBforderPicList(List<SysBforderPic> sysBforderPicList) {
        this.sysBforderPicList = sysBforderPicList;
    }

    public void setSysWarePicList(List<SysWarePic> sysWarePicList) {
        if (Collections3.isEmpty(sysWarePicList)) return;
        List<SysBforderPic> sysBforderPicList = new ArrayList<>();
        SysBforderPic sysBforderPic = null;
        for (SysWarePic sysWarePic : sysWarePicList) {
            sysBforderPic = new SysBforderPic();
            try {
                PropertyUtils.copyProperties(sysBforderPic, sysWarePic);
                sysBforderPicList.add(sysBforderPic);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        this.sysBforderPicList = sysBforderPicList;
    }

    public String getDetailWareNm() {
        return detailWareNm;
    }

    public void setDetailWareNm(String detailWareNm) {
        this.detailWareNm = detailWareNm;
    }

    public String getDetailWareGg() {
        return detailWareGg;
    }

    public void setDetailWareGg(String detailWareGg) {
        this.detailWareGg = detailWareGg;
    }

    public String getDetailShopWareAlias() {
        return detailShopWareAlias;
    }

    public void setDetailShopWareAlias(String detailShopWareAlias) {
        this.detailShopWareAlias = detailShopWareAlias;
    }

    public String getDetailWareDesc() {
        return detailWareDesc;
    }

    public void setDetailWareDesc(String detailWareDesc) {
        this.detailWareDesc = detailWareDesc;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysWarePic> getWarePicList() {
        return warePicList;
    }

    public void setWarePicList(List<SysWarePic> warePicList) {
        this.warePicList = warePicList;
    }

    public BigDecimal getWareDjOriginal() {
        return wareDjOriginal;
    }

    public void setWareDjOriginal(BigDecimal wareDjOriginal) {
        this.wareDjOriginal = wareDjOriginal;
    }

    public BigDecimal getDetailPromotionCost() {
        return detailPromotionCost;
    }

    public void setDetailPromotionCost(BigDecimal detailPromotionCost) {
        this.detailPromotionCost = detailPromotionCost;
    }

    public BigDecimal getDetailCouponCost() {
        return detailCouponCost;
    }

    public void setDetailCouponCost(BigDecimal detailCouponCost) {
        this.detailCouponCost = detailCouponCost;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getCartId() {
        return cartId;
    }

    public void setCartId(Integer cartId) {
        this.cartId = cartId;
    }

    private Double minHisPrice;//小单位历史价

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getMinHisPrice() {
        return minHisPrice;
    }

    public void setMinHisPrice(Double minHisPrice) {
        this.minHisPrice = minHisPrice;
    }
}
