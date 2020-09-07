package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.ShopWareUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.List;

/**
 * 说明：商品信息
 */
public class SysWare {
    private Integer wareId;//商品id
    private Integer waretype;//所属分类
    private String waretypePath;//分类路径
    private Integer isType;//类别属性  0：库存商品   1:原辅材料 2:低值易耗品  3：固定资产
    private Integer noCompany;//
    private String wareCode;//编码
    private String wareNm;//名称

    private String fbtime;//发布时间
    private Integer isCy;//是否常用（1是；2否）
    private Integer sunitFront;//开单默认显示辅单位
    private String py;//拼音
    //add by guojr
    private BigDecimal tranAmt;//运输费用
    private BigDecimal tcAmt;//提成费用
    private BigDecimal saleProTc;//销售利润提成
    private BigDecimal saleGroTc;//销售毛利提成

    private String qualityDays;// 保质期,单位是天
    private String remark;//备注

    private String produceDate;//生产日期
    private Double lowerLimit; // 库存下限

    private Long orderCd; // 排序码

    //大小单位换算比例*		bUnit*maxUnitCode=sUnit*minUnit
    private Double bUnit;//主单位乘数
    private Double sUnit;//辅单位乘数
    private Double hsNum;// 换算数量(包装单位到单品单位的转换系数)

    private String providerName;//生产商
    private String status;//启用状态 （1是；2否）
    private String aliasName;//别名
    private String asnNo;//标示码

    private Integer multiSpecId;//所属多规格ID
    private String multiSpecNm;//所属多规格名称
    private Integer groupId;
    private String groupName;
    private String attribute;//商品属性
    private Integer sort;//排序

    public String getAttribute() {
        return attribute;
    }

    public void setAttribute(String attribute) {
        this.attribute = attribute;
    }

    /**
     * 是否有更新
     */
    private Boolean hasSync;

    //---------进销存商品相关设置-----------------


    private String wareDw;//单位--进销存：大单位名称
    private String wareGg;//规格--进销存：大单位规格
    private Integer brandId;//品牌ID
    private String brandNm;//品牌名称
    private String packBarCode; // 包装条码--进销存：大单位条码
    private Double inPrice; // 采购价--进销存：大单位采购价
    private Double wareDj;//单价--进销存：大单位批发价
    private Double lsPrice; //零售价--进销存：大单位零售价
    private Double fxPrice;//分销价--进销存:大单位分销价 ????
    private Double cxPrice;//促销价--进销存:大单位促销价 ????
    private String maxUnitCode;//B 固定
    private String maxUnit; // 包装单位--进销存：大单位名称 目前已wareDw为准
    private Double warnQty; //预警数量--进销存：大单位预警数量

    private String minUnit;//计量单位名称--进销存：小单位名称
    private String minWareGg;//小单位规格--进销存：小单位规格 ????
    private String beBarCode; // 单品条码--进销存：小单位条码
    private Double minInPrice; //  小单位采购价--进销存：小单位采购价 ????
    private BigDecimal sunitPrice;//小单位销售价--进销存：小单位批发价
    private Double minLsPrice;//小单位零售价--进销存：小单位零售价 ????
    private Double minFxPrice;//小单位分销价--进销存：小单位分销价 ????
    private Double minCxPrice;//小单位促销价--进销存：小单位促销价 ????
    private Double minWarnQty;//小单位预警最低库存数量--进销存：预警最低库存数量 ????
    private String minUnitCode;//S 固定


    //只设计字段 还未设计到数据库
    private String customerLevelWareSale;//客户等级商品销售价设置--进销存 ????
    private String customerTypeWareSale;//客户类型商品销售价设置--进销存 ????
    private String wareSaleInput;//商品销售投入费用项目设置--进销存 ????
    private String costUnionCal;//费用项目设置关联设置--进销存 ????
    private String costInputCal;//费用项目投入计算--进销存 ????
    private Integer groupSort;//分组排序


    //--------门店相关设置-------------
    private String posWareNm;//门店--门店商品别称 ????
    private Double posInPrice;//门店--门店大单位采购价  ????
    private Double posPrice1;//门店零售价1 --门店：大单位零售价
    private Double posPrice2;//门店零售价2 --门店：小单位零售价
    private Double posPfPrice;//门店大单位批发价--门店：大单位批发价 ????
    private Double posCxPrice;//门店大单位促销价--门店：大单位促销价 ????
    private Double posMinInPrice;//门店小单位采购价--门店：小单位采购价 ????
    private Double posMinPfPrice;//门店小单位批发价--门店：小单位批发价 ????
    private Double posMinLsPrice;//不使用
    private Double posMinCxPrice;//门店小单位促销价--门店：小单位促销价 ????

    private Integer isUseStk;//使用库存否
    private Double shopAlarm;//门店库存预警
    private Double defaultQty;//默认补货数量
    private Double initQty;//初始货库存数量
    private Integer posId;//门店商品ID，在脱机状态下无法和服务器保持一致


    //--------商城相关-----
    private String wareResume;//商品简述
    private String wareDesc;//商品描述
    private String shopWareAlias;//自营商城商品别称
    private Double shopWarePrice;//自营商城商品大单位批发价
    private Double shopWareLsPrice;//自营商城商品大单位零售价
    private Double shopWareCxPrice;//自营商城商品大单位促销价
    private Double shopWareSmallPrice;//自营商城商品小单位批发价
    private Double shopWareSmallLsPrice;//自营商城商品小单位零售价
    private Double shopWareSmallCxPrice;//自营商城商品小单位促销价
    private String groupIds;//商品分组
    private String groupNms;//分组名称
    private Integer shopSort;//排序
    private Integer shopWarePriceShow;//大单位是否显示0否1是
    private Integer shopWareSmallPriceShow;//小单位是否显示0否1是
    private Integer shopWarePriceDefault;//价格显示默认0大单位,1小单位
    private Double shopMaxStorage;//商城大单位库存
    private BigDecimal baseLsRate;//零售基础比例
    private BigDecimal lowestSalePrice;

    private Integer orderBy;//以什么排序
    private String sortType;
    private String sourcePrice;
    private String sourcePrice1;

    public Double getPosPfPrice() {
        return posPfPrice;
    }

    public void setPosPfPrice(Double posPfPrice) {
        this.posPfPrice = posPfPrice;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWarePriceSource() {
        return shopWarePriceSource;
    }

    public void setShopWarePriceSource(Integer shopWarePriceSource) {
        this.shopWarePriceSource = shopWarePriceSource;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWareLsPriceSource() {
        return shopWareLsPriceSource;
    }

    public void setShopWareLsPriceSource(Integer shopWareLsPriceSource) {
        this.shopWareLsPriceSource = shopWareLsPriceSource;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWareCxPriceSource() {
        return shopWareCxPriceSource;
    }

    public void setShopWareCxPriceSource(Integer shopWareCxPriceSource) {
        this.shopWareCxPriceSource = shopWareCxPriceSource;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWareSmallPriceSource() {
        return shopWareSmallPriceSource;
    }

    public void setShopWareSmallPriceSource(Integer shopWareSmallPriceSource) {
        this.shopWareSmallPriceSource = shopWareSmallPriceSource;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWareSmallLsPriceSource() {
        return shopWareSmallLsPriceSource;
    }

    public void setShopWareSmallLsPriceSource(Integer shopWareSmallLsPriceSource) {
        this.shopWareSmallLsPriceSource = shopWareSmallLsPriceSource;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShopWareSmallCxPriceSource() {
        return shopWareSmallCxPriceSource;
    }

    public void setShopWareSmallCxPriceSource(Integer shopWareSmallCxPriceSource) {
        this.shopWareSmallCxPriceSource = shopWareSmallCxPriceSource;
    }

    private Integer putOn;//上架  1:上架 0:未上架
    private Integer shopWarePriceSource;//自营商城商品大单位批发价
    private Integer shopWareLsPriceSource;//自营商城商品大单位零售价
    private Integer shopWareCxPriceSource;//自营商城商品大单位促销价
    private Integer shopWareSmallPriceSource;//自营商城商品小单位批发价
    private Integer shopWareSmallLsPriceSource;//自营商城商品小单位零售价
    private Integer shopWareSmallCxPriceSource;//自营商城商品小单位促销价


    //--------平台商城相关-----
    private String platshopWareNm;//平台商城商品名称 ????
    private String platshopWareType;//平台商品类别
    private Double platshopWarePfPrice;//平台商城商品大单位批发价 ????
    private Double platshopWareLsPrice;//平台商城商品大单位零售价 ????
    private Double platshopWareCxPrice;//平台商城商品大单位促销价 ????
    private Double platshopWareMinPfPrice;//平台商城商品小单位批发价 ????
    private Double platshopWareMinLsPrice;//平台商城商品小单位零售价 ????
    private Double platshopWareMinCxPrice;//平台商城商品小单位促销价 ????

    //---------------------不在数据库----------------
    private String waretypeNm;//分类名称
    private List<SysWarePic> warePicList;
    private BigDecimal occQty;//占用库存
    private Integer isFavorite;//收藏        1：收藏 0：未收藏

    private String bbUnit;
    private String ssUnit;

    private Integer showAllProducts;//显示全部商品

    private Integer sswId;

    private BigDecimal saleQty;//商城销售数量，可修改

    public String getPy() {
        return py;
    }

    public void setPy(String py) {
        this.py = py;
    }

    public Double getbUnit() {
        return bUnit;
    }

    public void setbUnit(Double bUnit) {
        this.bUnit = bUnit;
    }

    public Double getsUnit() {
        return sUnit;
    }

    public void setsUnit(Double sUnit) {
        this.sUnit = sUnit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMinUnit() {
        return minUnit;
    }

    public void setMinUnit(String minUnit) {
        this.minUnit = minUnit;
    }

    public String getMaxUnitCode() {
        return maxUnitCode;
    }

    public void setMaxUnitCode(String maxUnitCode) {
        this.maxUnitCode = maxUnitCode;
    }

    public String getMinUnitCode() {
        return minUnitCode;
    }

    public void setMinUnitCode(String minUnitCode) {
        this.minUnitCode = minUnitCode;
    }


    public String getQualityDays() {
        return qualityDays;
    }

    public void setQualityDays(String qualityDays) {
        this.qualityDays = qualityDays;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getMaxUnit() {
        return maxUnit;
    }

    public void setMaxUnit(String maxUnit) {
        this.maxUnit = maxUnit;
    }

    public String getProduceDate() {
        return produceDate;
    }

    public String getBeBarCode() {
        return beBarCode;
    }

    public void setBeBarCode(String beBarCode) {
        this.beBarCode = beBarCode;
    }

    public String getPackBarCode() {
        return packBarCode;
    }

    public void setPackBarCode(String packBarCode) {
        this.packBarCode = packBarCode;
    }

    public void setProduceDate(String produceDate) {
        this.produceDate = produceDate;
    }

    public Double getLowerLimit() {
        return lowerLimit;
    }

    public void setLowerLimit(Double lowerLimit) {
        this.lowerLimit = lowerLimit;
    }

    public Double getInPrice() {
        return inPrice;
    }

    public void setInPrice(Double inPrice) {
        this.inPrice = inPrice;
    }

    public Long getOrderCd() {
        return orderCd;
    }

    public void setOrderCd(Long orderCd) {
        this.orderCd = orderCd;
    }

    public Double getHsNum() {
        return hsNum;
    }

    public void setHsNum(Double hsNum) {
        this.hsNum = hsNum;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public BigDecimal getTranAmt() {
        return tranAmt;
    }

    public void setTranAmt(BigDecimal tranAmt) {
        this.tranAmt = tranAmt;
    }

    public Integer getIsCy() {
        return isCy;
    }

    public void setIsCy(Integer isCy) {
        this.isCy = isCy;
    }

    public String getFbtime() {
        return fbtime;
    }

    public void setFbtime(String fbtime) {
        this.fbtime = fbtime;
    }

    public String getWareCode() {
        return wareCode;
    }

    public void setWareCode(String wareCode) {
        this.wareCode = wareCode;
    }

    public Double getWareDj() {
        return wareDj;
    }

    public void setWareDj(Double wareDj) {
        this.wareDj = wareDj;
    }

    public String getWareDw() {
        return wareDw;
    }

    public void setWareDw(String wareDw) {
        this.wareDw = wareDw;
    }

    public String getWareGg() {
        return wareGg;
    }

    public void setWareGg(String wareGg) {
        this.wareGg = wareGg;
    }

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    public Integer getWaretype() {
        return waretype;
    }

    public void setWaretype(Integer waretype) {
        this.waretype = waretype;
    }

    public BigDecimal getTcAmt() {
        return tcAmt;
    }

    public void setTcAmt(BigDecimal tcAmt) {
        this.tcAmt = tcAmt;
    }

    public BigDecimal getSunitPrice() {
        return sunitPrice;
    }

    public void setSunitPrice(BigDecimal sunitPrice) {
        this.sunitPrice = sunitPrice;
    }

    public String getGroupIds() {
        return groupIds;
    }

    public void setGroupIds(String groupIds) {
        this.groupIds = groupIds;
    }

    public String getGroupNms() {
        return groupNms;
    }

    public void setGroupNms(String groupNms) {
        this.groupNms = groupNms;
    }

    public Integer getPutOn() {
        return putOn;
    }

    public void setPutOn(Integer putOn) {
        this.putOn = putOn;
    }

    public Integer getSunitFront() {
        return sunitFront;
    }

    public void setSunitFront(Integer sunitFront) {
        this.sunitFront = sunitFront;
    }

    public Double getLsPrice() {
        return lsPrice;
    }

    public void setLsPrice(Double lsPrice) {
        this.lsPrice = lsPrice;
    }

    public String getWareDesc() {
        return wareDesc;
    }

    public void setWareDesc(String wareDesc) {
        this.wareDesc = wareDesc;
    }

    public String getWareResume() {
        return wareResume;
    }

    public void setWareResume(String wareResume) {
        this.wareResume = wareResume;
    }

    //=========================不在数据库中=========================
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWaretypePath() {
        return waretypePath;
    }

    public void setWaretypePath(String waretypePath) {
        this.waretypePath = waretypePath;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWaretypeNm() {
        return waretypeNm;
    }

    public void setWaretypeNm(String waretypeNm) {
        this.waretypeNm = waretypeNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getIsFavorite() {
        return isFavorite;
    }

    public void setIsFavorite(Integer isFavorite) {
        this.isFavorite = isFavorite;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysWarePic> getWarePicList() {
        return warePicList;
    }

    public void setWarePicList(List<SysWarePic> warePicList) {
        this.warePicList = warePicList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getOccQty() {
        return occQty;
    }

    public void setOccQty(BigDecimal occQty) {
        this.occQty = occQty;
    }

    public Double getWarnQty() {
        return warnQty;
    }

    public void setWarnQty(Double warnQty) {
        this.warnQty = warnQty;
    }

    public String getAliasName() {
        return aliasName;
    }

    public void setAliasName(String aliasName) {
        this.aliasName = aliasName;
    }

    public String getAsnNo() {
        return asnNo;
    }

    public void setAsnNo(String asnNo) {
        this.asnNo = asnNo;
    }

    public Double getPosPrice1() {
        return posPrice1;
    }

    public void setPosPrice1(Double posPrice1) {
        this.posPrice1 = posPrice1;
    }

    public Double getPosPrice2() {
        return posPrice2;
    }

    public void setPosPrice2(Double posPrice2) {
        this.posPrice2 = posPrice2;
    }

    public Integer getIsUseStk() {
        return isUseStk;
    }

    public void setIsUseStk(Integer isUseStk) {
        this.isUseStk = isUseStk;
    }

    public Double getShopAlarm() {
        return shopAlarm;
    }

    public void setShopAlarm(Double shopAlarm) {
        this.shopAlarm = shopAlarm;
    }

    public Double getDefaultQty() {
        return defaultQty;
    }

    public void setDefaultQty(Double defaultQty) {
        this.defaultQty = defaultQty;
    }

    public Double getInitQty() {
        return initQty;
    }

    public void setInitQty(Double initQty) {
        this.initQty = initQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getBbUnit() {
        return bbUnit;
    }

    public void setBbUnit(String bbUnit) {
        this.bbUnit = bbUnit;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSsUnit() {
        return ssUnit;
    }

    public void setSsUnit(String ssUnit) {
        this.ssUnit = ssUnit;
    }

    public String getShopWareAlias() {
        return shopWareAlias;
    }

    public void setShopWareAlias(String shopWareAlias) {
        this.shopWareAlias = shopWareAlias;
    }

    public Double getShopWarePrice() {
        return shopWarePrice;
    }

    public void setShopWarePrice(Double shopWarePrice) {
        this.shopWarePrice = shopWarePrice;
    }

    public Double getShopWareLsPrice() {
        return shopWareLsPrice;
    }

    public void setShopWareLsPrice(Double shopWareLsPrice) {
        this.shopWareLsPrice = shopWareLsPrice;
    }

    public Double getShopWareCxPrice() {
        return shopWareCxPrice;
    }

    public void setShopWareCxPrice(Double shopWareCxPrice) {
        this.shopWareCxPrice = shopWareCxPrice;
    }

    public Double getShopWareSmallPrice() {
        return shopWareSmallPrice;
    }

    public void setShopWareSmallPrice(Double shopWareSmallPrice) {
        this.shopWareSmallPrice = shopWareSmallPrice;
    }

    public Double getShopWareSmallLsPrice() {
        return shopWareSmallLsPrice;
    }

    public void setShopWareSmallLsPrice(Double shopWareSmallLsPrice) {
        this.shopWareSmallLsPrice = shopWareSmallLsPrice;
    }

    public Double getShopWareSmallCxPrice() {
        return shopWareSmallCxPrice;
    }

    public void setShopWareSmallCxPrice(Double shopWareSmallCxPrice) {
        this.shopWareSmallCxPrice = shopWareSmallCxPrice;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getBrandNm() {
        return brandNm;
    }

    public void setBrandNm(String brandNm) {
        this.brandNm = brandNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public Double getFxPrice() {
        return fxPrice;
    }

    public void setFxPrice(Double fxPrice) {
        this.fxPrice = fxPrice;
    }

    public Double getCxPrice() {
        return cxPrice;
    }

    public void setCxPrice(Double cxPrice) {
        this.cxPrice = cxPrice;
    }

    public String getMinWareGg() {
        return minWareGg;
    }

    public void setMinWareGg(String minWareGg) {
        this.minWareGg = minWareGg;
    }

    public Double getMinInPrice() {
        return minInPrice;
    }

    public void setMinInPrice(Double minInPrice) {
        this.minInPrice = minInPrice;
    }

    public Double getMinLsPrice() {
        return minLsPrice;
    }

    public void setMinLsPrice(Double minLsPrice) {
        this.minLsPrice = minLsPrice;
    }

    public Double getMinFxPrice() {
        return minFxPrice;
    }

    public void setMinFxPrice(Double minFxPrice) {
        this.minFxPrice = minFxPrice;
    }

    public Double getMinCxPrice() {
        return minCxPrice;
    }

    public void setMinCxPrice(Double minCxPrice) {
        this.minCxPrice = minCxPrice;
    }

    public Double getMinWarnQty() {
        return minWarnQty;
    }

    public void setMinWarnQty(Double minWarnQty) {
        this.minWarnQty = minWarnQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getCustomerLevelWareSale() {
        return customerLevelWareSale;
    }

    public void setCustomerLevelWareSale(String customerLevelWareSale) {
        this.customerLevelWareSale = customerLevelWareSale;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getCustomerTypeWareSale() {
        return customerTypeWareSale;
    }

    public void setCustomerTypeWareSale(String customerTypeWareSale) {
        this.customerTypeWareSale = customerTypeWareSale;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareSaleInput() {
        return wareSaleInput;
    }

    public void setWareSaleInput(String wareSaleInput) {
        this.wareSaleInput = wareSaleInput;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getCostUnionCal() {
        return costUnionCal;
    }

    public void setCostUnionCal(String costUnionCal) {
        this.costUnionCal = costUnionCal;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getCostInputCal() {
        return costInputCal;
    }

    public void setCostInputCal(String costInputCal) {
        this.costInputCal = costInputCal;
    }

    public String getPosWareNm() {
        return posWareNm;
    }

    public void setPosWareNm(String posWareNm) {
        this.posWareNm = posWareNm;
    }

    public Double getPosInPrice() {
        return posInPrice;
    }

    public void setPosInPrice(Double posInPrice) {
        this.posInPrice = posInPrice;
    }

    public Double getPosCxPrice() {
        return posCxPrice;
    }

    public void setPosCxPrice(Double posCxPrice) {
        this.posCxPrice = posCxPrice;
    }

    public Double getPosMinInPrice() {
        return posMinInPrice;
    }

    public void setPosMinInPrice(Double posMinInPrice) {
        this.posMinInPrice = posMinInPrice;
    }

    public Double getPosMinPfPrice() {
        return posMinPfPrice;
    }

    public void setPosMinPfPrice(Double posMinPfPrice) {
        this.posMinPfPrice = posMinPfPrice;
    }

    public Double getPosMinLsPrice() {
        return posMinLsPrice;
    }

    public void setPosMinLsPrice(Double posMinLsPrice) {
        this.posMinLsPrice = posMinLsPrice;
    }

    public Double getPosMinCxPrice() {
        return posMinCxPrice;
    }

    public void setPosMinCxPrice(Double posMinCxPrice) {
        this.posMinCxPrice = posMinCxPrice;
    }

    public String getPlatshopWareNm() {
        return platshopWareNm;
    }

    public void setPlatshopWareNm(String platshopWareNm) {
        this.platshopWareNm = platshopWareNm;
    }

    public String getPlatshopWareType() {
        return platshopWareType;
    }

    public void setPlatshopWareType(String platshopWareType) {
        this.platshopWareType = platshopWareType;
    }

    public Double getPlatshopWarePfPrice() {
        return platshopWarePfPrice;
    }

    public void setPlatshopWarePfPrice(Double platshopWarePfPrice) {
        this.platshopWarePfPrice = platshopWarePfPrice;
    }

    public Double getPlatshopWareLsPrice() {
        return platshopWareLsPrice;
    }

    public void setPlatshopWareLsPrice(Double platshopWareLsPrice) {
        this.platshopWareLsPrice = platshopWareLsPrice;
    }

    public Double getPlatshopWareCxPrice() {
        return platshopWareCxPrice;
    }

    public void setPlatshopWareCxPrice(Double platshopWareCxPrice) {
        this.platshopWareCxPrice = platshopWareCxPrice;
    }

    public Double getPlatshopWareMinPfPrice() {
        return platshopWareMinPfPrice;
    }

    public void setPlatshopWareMinPfPrice(Double platshopWareMinPfPrice) {
        this.platshopWareMinPfPrice = platshopWareMinPfPrice;
    }

    public Double getPlatshopWareMinLsPrice() {
        return platshopWareMinLsPrice;
    }

    public void setPlatshopWareMinLsPrice(Double platshopWareMinLsPrice) {
        this.platshopWareMinLsPrice = platshopWareMinLsPrice;
    }

    public Double getPlatshopWareMinCxPrice() {
        return platshopWareMinCxPrice;
    }

    public void setPlatshopWareMinCxPrice(Double platshopWareMinCxPrice) {
        this.platshopWareMinCxPrice = platshopWareMinCxPrice;
    }


    private int pfPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int lsPriceType; //0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int fxPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int cxPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int minPfPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int minLsPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int minFxPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价
    private int minCxPriceType;//0:商品价 1:客户类型价 2:客户等级价 3:客户商品价

    private BigDecimal rate;
    private BigDecimal saleQtyTcRate;//单件提成比例
    private BigDecimal saleProTcRate;//利润提成比例
    private BigDecimal saleGroTcRate;//毛利提成比例

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getPfPriceType() {
        return pfPriceType;
    }

    public void setPfPriceType(int pfPriceType) {
        this.pfPriceType = pfPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getLsPriceType() {
        return lsPriceType;
    }

    public void setLsPriceType(int lsPriceType) {
        this.lsPriceType = lsPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getFxPriceType() {
        return fxPriceType;
    }

    public void setFxPriceType(int fxPriceType) {
        this.fxPriceType = fxPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getCxPriceType() {
        return cxPriceType;
    }

    public void setCxPriceType(int cxPriceType) {
        this.cxPriceType = cxPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getMinPfPriceType() {
        return minPfPriceType;
    }

    public void setMinPfPriceType(int minPfPriceType) {
        this.minPfPriceType = minPfPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getMinLsPriceType() {
        return minLsPriceType;
    }

    public void setMinLsPriceType(int minLsPriceType) {
        this.minLsPriceType = minLsPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getMinFxPriceType() {
        return minFxPriceType;
    }

    public void setMinFxPriceType(int minFxPriceType) {
        this.minFxPriceType = minFxPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public int getMinCxPriceType() {
        return minCxPriceType;
    }

    public void setMinCxPriceType(int minCxPriceType) {
        this.minCxPriceType = minCxPriceType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getIsType() {
        return isType;
    }

    public void setIsType(Integer isType) {
        this.isType = isType;
    }

    public Integer getShopSort() {
        return shopSort;
    }

    public void setShopSort(Integer shopSort) {
        this.shopSort = shopSort;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getGroupSort() {
        return groupSort;
    }

    public void setGroupSort(Integer groupSort) {
        this.groupSort = groupSort;
    }

    public Integer getMultiSpecId() {
        return multiSpecId;
    }

    public void setMultiSpecId(Integer multiSpecId) {
        this.multiSpecId = multiSpecId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMultiSpecNm() {
        return multiSpecNm;
    }

    public void setMultiSpecNm(String multiSpecNm) {
        this.multiSpecNm = multiSpecNm;
    }

    public Boolean getHasSync() {
        return hasSync;
    }

    public void setHasSync(Boolean hasSync) {
        this.hasSync = hasSync;
    }

    private Double maxHisPfPrice;//最新大单位历史批发价;
    private String maxHisPfPrices;//大单位历史批发价;
    private Double minHisPfPrice;//最新小单位历史批发价;
    private String minHisPfPrices;//小单位历史批发价;

    private Double maxHisGyPrice;//最大历史干预价
    private Double minHisGyPrice;//最小历史干预价

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getMaxHisPfPrice() {
        return maxHisPfPrice;
    }

    public void setMaxHisPfPrice(Double maxHisPfPrice) {
        this.maxHisPfPrice = maxHisPfPrice;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMaxHisPfPrices() {
        return maxHisPfPrices;
    }

    public void setMaxHisPfPrices(String maxHisPfPrices) {
        this.maxHisPfPrices = maxHisPfPrices;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getMinHisPfPrice() {
        return minHisPfPrice;
    }

    public void setMinHisPfPrice(Double minHisPfPrice) {
        this.minHisPfPrice = minHisPfPrice;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMinHisPfPrices() {
        return minHisPfPrices;
    }

    public void setMinHisPfPrices(String minHisPfPrices) {
        this.minHisPfPrices = minHisPfPrices;
    }

    public Integer getShopWarePriceShow() {
        return shopWarePriceShow;
    }

    public void setShopWarePriceShow(Integer shopWarePriceShow) {
        this.shopWarePriceShow = shopWarePriceShow;
    }

    public Integer getShopWareSmallPriceShow() {
        return shopWareSmallPriceShow;
    }

    public void setShopWareSmallPriceShow(Integer shopWareSmallPriceShow) {
        this.shopWareSmallPriceShow = shopWareSmallPriceShow;
    }

    public Integer getShopWarePriceDefault() {
        return shopWarePriceDefault;
    }

    public void setShopWarePriceDefault(Integer shopWarePriceDefault) {
        this.shopWarePriceDefault = shopWarePriceDefault;
    }

    private BigDecimal stkQty;
    private BigDecimal minStkQty;
    private Integer userId;
    private BigDecimal sumQty;
    private String productDate;
    private BigDecimal minOccQty;
    private BigDecimal inPrice2;

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getInPrice2() {
        return inPrice2;
    }

    public void setInPrice2(BigDecimal inPrice2) {
        this.inPrice2 = inPrice2;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getStkQty() {
        return stkQty;
    }

    public void setStkQty(BigDecimal stkQty) {
        this.stkQty = stkQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getSumQty() {
        return sumQty;
    }

    public void setSumQty(BigDecimal sumQty) {
        this.sumQty = sumQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getProductDate() {
        return productDate;
    }

    public void setProductDate(String productDate) {
        this.productDate = productDate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getSaleQtyTcRate() {
        return saleQtyTcRate;
    }

    public void setSaleQtyTcRate(BigDecimal saleQtyTcRate) {
        this.saleQtyTcRate = saleQtyTcRate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getSaleProTcRate() {
        return saleProTcRate;
    }

    public void setSaleProTcRate(BigDecimal saleProTcRate) {
        this.saleProTcRate = saleProTcRate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getSaleGroTcRate() {
        return saleGroTcRate;
    }

    public void setSaleGroTcRate(BigDecimal saleGroTcRate) {
        this.saleGroTcRate = saleGroTcRate;
    }

    private Double tempWareDj;//单价--进销存：大单位批发价
    private BigDecimal tempSunitPrice;//小单位销售价--进销存：小单位批发价

    private BigDecimal tempTcAmt;//提成费用
    private BigDecimal tempSaleProTc;//销售利润提成
    private BigDecimal tempSaleGroTc;//销售毛利提成

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getTempWareDj() {
        return tempWareDj;
    }

    public void setTempWareDj(Double tempWareDj) {
        this.tempWareDj = tempWareDj;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getTempSunitPrice() {
        return tempSunitPrice;
    }

    public void setTempSunitPrice(BigDecimal tempSunitPrice) {
        this.tempSunitPrice = tempSunitPrice;
    }

    public BigDecimal getSaleProTc() {
        return saleProTc;
    }

    public void setSaleProTc(BigDecimal saleProTc) {
        this.saleProTc = saleProTc;
    }

    public BigDecimal getSaleGroTc() {
        return saleGroTc;
    }

    public void setSaleGroTc(BigDecimal saleGroTc) {
        this.saleGroTc = saleGroTc;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getTempTcAmt() {
        return tempTcAmt;
    }

    public void setTempTcAmt(BigDecimal tempTcAmt) {
        this.tempTcAmt = tempTcAmt;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getTempSaleProTc() {
        return tempSaleProTc;
    }

    public void setTempSaleProTc(BigDecimal tempSaleProTc) {
        this.tempSaleProTc = tempSaleProTc;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getTempSaleGroTc() {
        return tempSaleGroTc;
    }

    public void setTempSaleGroTc(BigDecimal tempSaleGroTc) {
        this.tempSaleGroTc = tempSaleGroTc;
    }

    //过滤不需要商品IDS
    private String noInWareIds;

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getNoInWareIds() {
        return noInWareIds;
    }

    public void setNoInWareIds(String noInWareIds) {
        this.noInWareIds = noInWareIds;
    }

    public Integer getPosId() {
        return posId;
    }

    public void setPosId(Integer posId) {
        this.posId = posId;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getSort() {
        return sort;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getShowAllProducts() {
        return showAllProducts;
    }

    public void setShowAllProducts(Integer showAllProducts) {
        this.showAllProducts = showAllProducts;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getSswId() {
        return sswId;
    }

    public void setSswId(Integer sswId) {
        this.sswId = sswId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getShopMaxStorage() {
        return shopMaxStorage;
    }

    public void setShopMaxStorage(Double shopMaxStorage) {
        this.shopMaxStorage = shopMaxStorage;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getMinStkQty() {
        return minStkQty;
    }

    public void setMinStkQty(BigDecimal minStkQty) {
        this.minStkQty = minStkQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getMinOccQty() {
        return minOccQty;
    }

    public void setMinOccQty(BigDecimal minOccQty) {
        this.minOccQty = minOccQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getMaxHisGyPrice() {
        return maxHisGyPrice;
    }

    public void setMaxHisGyPrice(Double maxHisGyPrice) {
        this.maxHisGyPrice = maxHisGyPrice;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Double getMinHisGyPrice() {
        return minHisGyPrice;
    }

    public void setMinHisGyPrice(Double minHisGyPrice) {
        this.minHisGyPrice = minHisGyPrice;
    }

    public void calLsPrice() {
        BigDecimal rate = new BigDecimal(1);
        if (!StrUtil.isNumberNullOrZero(this.addRate)) {
            rate = addRate.divide(new BigDecimal(100));
            if (!StrUtil.isNumberNullOrZero(getInPrice())) {
                Double price = getInPrice() * (rate.doubleValue()) + getInPrice();
                setLsPrice(price);
            }
            if (!StrUtil.isNumberNullOrZero(getMinInPrice())) {
                Double price = getMinLsPrice() * (rate.doubleValue()) + getMinLsPrice();
                setMinLsPrice(getMinLsPrice() * (rate.doubleValue()) + getMinInPrice());
            }
        }

    }

    private BigDecimal addRate;//加价比例

    public BigDecimal getAddRate() {
        return addRate;
    }

    public void setAddRate(BigDecimal addRate) {
        this.addRate = addRate;
    }

    private BigDecimal autoFee;//变动费用

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getAutoFee() {
        return autoFee;
    }

    public void setAutoFee(BigDecimal autoFee) {
        this.autoFee = autoFee;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getBaseLsRate() {
        return baseLsRate;
    }

    public void setBaseLsRate(BigDecimal baseLsRate) {
        this.baseLsRate = baseLsRate;
    }

    //商城基础大单位零售价03-28
    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getShopBaseMaxLsPrice() {
        return ShopWareUtil.getShopBaseMaxLsPrice(lsPrice, minLsPrice, shopWareLsPrice, shopWareSmallLsPrice, hsNum, baseLsRate);
    }

    //商城基础小单位零售价
    @TableAnnotation(insertAble = false, updateAble = false)
    public BigDecimal getShopBaseMinLsPrice() {
        return ShopWareUtil.getShopBaseMinLsPrice(lsPrice, minLsPrice, shopWareLsPrice, shopWareSmallLsPrice, hsNum, baseLsRate);
    }

    public Integer getNoCompany() {
        return noCompany;
    }

    public void setNoCompany(Integer noCompany) {
        this.noCompany = noCompany;
    }

    public BigDecimal getLowestSalePrice() {
        return lowestSalePrice;
    }

    public void setLowestSalePrice(BigDecimal lowestSalePrice) {
        this.lowestSalePrice = lowestSalePrice;
    }

    public BigDecimal getSaleQty() {
        return saleQty;
    }

    public void setSaleQty(BigDecimal saleQty) {
        this.saleQty = saleQty;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(Integer orderBy) {
        this.orderBy = orderBy;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSortType() {
        return sortType;
    }

    public void setSortType(String sortType) {
        this.sortType = sortType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSourcePrice() {
        return sourcePrice;
    }

    public void setSourcePrice(String sourcePrice) {
        this.sourcePrice = sourcePrice;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSourcePrice1() {
        return sourcePrice1;
    }

    public void setSourcePrice1(String sourcePrice1) {
        this.sourcePrice1 = sourcePrice1;
    }
}
