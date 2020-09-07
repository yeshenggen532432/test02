package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class StkBaseSub {
	private String beUnit;//计量单位
	private Double hsNum;
	@TableAnnotation(insertAble=false,updateAble=false)
	public Double getHsNum() {
		return hsNum;
	}
	public void setHsNum(Double hsNum) {
		this.hsNum = hsNum;
	}
	public String getBeUnit() {
		return beUnit;
	}
	public void setBeUnit(String beUnit) {
		this.beUnit = beUnit;
	}
}
