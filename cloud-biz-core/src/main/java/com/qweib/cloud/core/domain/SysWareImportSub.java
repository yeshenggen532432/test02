package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.List;

/**
 * 商品信息导入细表
 */
public class SysWareImportSub {
	private Integer id;
	private Integer mastId;//主表ID
	private Integer wareId;//商品id
	private Integer waretype;//所属分类
	private String wareCode;//编码
	private String wareNm;//名称

	private String fbtime;//发布时间
	private Integer isCy;//是否常用（1是；2否）
	private Integer sunitFront;//开单默认显示辅单位
	private String py;//拼音
	//add by guojr
	private BigDecimal tranAmt;//运输费用
	private BigDecimal tcAmt;//提成费用
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
	private String status;
	private String aliasName;//别名
	private String asnNo;//标示码

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

	//--------商城相关-----
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


	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Double getPosPfPrice() {
		return posPfPrice;
	}

	public void setPosPfPrice(Double posPfPrice) {
		this.posPfPrice = posPfPrice;
	}

	public Integer getShopWarePriceSource() {
		return shopWarePriceSource;
	}

	public void setShopWarePriceSource(Integer shopWarePriceSource) {
		this.shopWarePriceSource = shopWarePriceSource;
	}

	public Integer getShopWareLsPriceSource() {
		return shopWareLsPriceSource;
	}

	public void setShopWareLsPriceSource(Integer shopWareLsPriceSource) {
		this.shopWareLsPriceSource = shopWareLsPriceSource;
	}

	public Integer getShopWareCxPriceSource() {
		return shopWareCxPriceSource;
	}

	public void setShopWareCxPriceSource(Integer shopWareCxPriceSource) {
		this.shopWareCxPriceSource = shopWareCxPriceSource;
	}

	public Integer getShopWareSmallPriceSource() {
		return shopWareSmallPriceSource;
	}

	public void setShopWareSmallPriceSource(Integer shopWareSmallPriceSource) {
		this.shopWareSmallPriceSource = shopWareSmallPriceSource;
	}

	public Integer getShopWareSmallLsPriceSource() {
		return shopWareSmallLsPriceSource;
	}

	public void setShopWareSmallLsPriceSource(Integer shopWareSmallLsPriceSource) {
		this.shopWareSmallLsPriceSource = shopWareSmallLsPriceSource;
	}

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
	private String waretypePath;
	private String waretypeNm;//分类名称
	private List<SysWarePic> warePicList;
	private BigDecimal occQty;//占用库存
	private Integer isFavorite;//收藏        1：收藏 0：未收藏

	private String bbUnit;
	private String ssUnit;
	
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

	public Integer getMastId() {
		return mastId;
	}

	public void setMastId(Integer mastId) {
		this.mastId = mastId;
	}
}
