package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：计划线路详情
 *@创建：作者:llp		创建时间：2016-8-15
 *@修改历史：
 *		[序号](llp	2016-8-15)<修改说明>
 */
public class BscPlanxlDetail {
	private Integer id;//计划线路详情id
	private Integer xlId;//计划线路id
	private Integer cid;//客户id
	//-----------------------不在数据库---------------
	private String khNm;//客户名称
	private String scbfDate;//上次拜访日期
	private String longitude;
	private String latitude;

	
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getScbfDate() {
		return scbfDate;
	}
	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}
	public Integer getXlId() {
		return xlId;
	}
	public void setXlId(Integer xlId) {
		this.xlId = xlId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
}
