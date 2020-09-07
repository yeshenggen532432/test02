package com.qweib.cloud.core.domain;

import java.math.BigDecimal;

/**
 *说明：商品信息
 */
public class SysWareImport {
	private Integer wareId;//商品id
	private Integer waretype;//所属分类
	private String wareCode;//编码
	private String wareNm;//名称
	private String wareGg;//规格
	private String wareDw;//单位
	private Double wareDj;//单价
	private String fbtime;//发布时间
	private Integer isCy;//是否常用（1是；2否）
	//add by guojr
	private BigDecimal tranAmt;//运输费用
	private BigDecimal tcAmt;//提成费用
	
	
	
	private String qualityDays;//保质期,单位是天
	private String remark;//备注
	private String beBarCode; //单品条码
	private String packBarCode; //包装条码
	private String maxUnit; // 包装单位
	private String produceDate;//生产日期
	private String providerName;//生产商
	private Double lowerLimit; //库存预警
	private Double inPrice; //采购价
	private Integer orderCd; //排序码
	private Integer hsNum;//换算数量(包装单位到单品单位的转换系数)
	private Integer status1;//商品是否存在 0:未存在 1:已存在
	private Integer status2;//类别是否存在 0:未存在 1:已存在
	
	private Integer status3;//商品名称在Excel是否重复 0:未重复 1:已重复
	private Integer status4;//商品代码在Excel是否重复 0:未重复 1:已重复
	
	
	public Integer getStatus3() {
		return status3;
	}
	public void setStatus3(Integer status3) {
		this.status3 = status3;
	}
	public Integer getStatus4() {
		return status4;
	}
	public void setStatus4(Integer status4) {
		this.status4 = status4;
	}
	public Integer getStatus1() {
		return status1;
	}
	public void setStatus1(Integer status1) {
		this.status1 = status1;
	}
	
	public Integer getStatus2() {
		return status2;
	}
	public void setStatus2(Integer status2) {
		this.status2 = status2;
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
	public String getMaxUnit() {
		return maxUnit;
	}
	public void setMaxUnit(String maxUnit) {
		this.maxUnit = maxUnit;
	}
	public String getProduceDate() {
		return produceDate;
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
	
	public Integer getOrderCd() {
		return orderCd;
	}
	public void setOrderCd(Integer orderCd) {
		this.orderCd = orderCd;
	}
	public Integer getHsNum() {
		return hsNum;
	}
	public void setHsNum(Integer hsNum) {
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
	//---------------------不在数据库----------------
	private String waretypeNm;//分类名称
	
    public Integer getIsCy() {
		return isCy;
	}
	public void setIsCy(Integer isCy) {
		this.isCy = isCy;
	}
	
	public String getWaretypeNm() {
		return waretypeNm;
	}
	
	public void setWaretypeNm(String waretypeNm) {
		this.waretypeNm = waretypeNm;
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
	
	
}
