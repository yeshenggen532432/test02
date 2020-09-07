package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

//考勤规则
public class BscCheckRule {
	private Integer id;//考勤规则id
	private Integer memberId;//用户id
	private String kqgjNm;//规则名称
	private String tp;//类型(固定班制；外勤制)
	private String checkWeeks;//考勤时间（周）
	private String checkTimes;//考勤时间（时间段）
	private String address;//考勤地址
	private String longitude;//经度
	private String latitude;//纬度
	private Integer yxMeter;//有效范围几米
	private Integer zzsbTime;//最早上班签到时间几个小时
	private Integer zwxbTime;//最晚下班签退时间几个小时
	private Integer sxbtxTime;//上下班弹性时间几分钟
	private Integer isQd;//在考勤范围以外允许签到/签退（1允许；2不允许）
	private String syMids1;//适用人员id组（1,2,3）
	private String syMids2;//适用人员id组（-1-2-3-）
	private String glMids1;//管理人员id组（1,2,3）
	private String glMids2;//管理人员id组（-1-2-3-）
	private String ckMids1;//查看人员id组（1,2,3）
	private String ckMids2;//查看人员id组（-1-2-3-）
	private String fbTime;//发布时间
	//------------------不在数据库--------------------
	private Integer mnum1;//人数
	private String mids;//用户id组
	private Integer isMy;//是否是我的（1是；2否）
	
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getIsMy() {
		return isMy;
	}
	public void setIsMy(Integer isMy) {
		this.isMy = isMy;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMids() {
		return mids;
	}
	public void setMids(String mids) {
		this.mids = mids;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getMnum1() {
		return mnum1;
	}
	public void setMnum1(Integer mnum1) {
		this.mnum1 = mnum1;
	}
	public String getFbTime() {
		return fbTime;
	}
	public void setFbTime(String fbTime) {
		this.fbTime = fbTime;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCheckTimes() {
		return checkTimes;
	}
	public void setCheckTimes(String checkTimes) {
		this.checkTimes = checkTimes;
	}
	public String getCheckWeeks() {
		return checkWeeks;
	}
	public void setCheckWeeks(String checkWeeks) {
		this.checkWeeks = checkWeeks;
	}
	public String getCkMids1() {
		return ckMids1;
	}
	public void setCkMids1(String ckMids1) {
		this.ckMids1 = ckMids1;
	}
	public String getCkMids2() {
		return ckMids2;
	}
	public void setCkMids2(String ckMids2) {
		this.ckMids2 = ckMids2;
	}
	public String getGlMids1() {
		return glMids1;
	}
	public void setGlMids1(String glMids1) {
		this.glMids1 = glMids1;
	}
	public String getGlMids2() {
		return glMids2;
	}
	public void setGlMids2(String glMids2) {
		this.glMids2 = glMids2;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getIsQd() {
		return isQd;
	}
	public void setIsQd(Integer isQd) {
		this.isQd = isQd;
	}
	public String getKqgjNm() {
		return kqgjNm;
	}
	public void setKqgjNm(String kqgjNm) {
		this.kqgjNm = kqgjNm;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public Integer getSxbtxTime() {
		return sxbtxTime;
	}
	public void setSxbtxTime(Integer sxbtxTime) {
		this.sxbtxTime = sxbtxTime;
	}
	public String getSyMids1() {
		return syMids1;
	}
	public void setSyMids1(String syMids1) {
		this.syMids1 = syMids1;
	}
	public String getSyMids2() {
		return syMids2;
	}
	public void setSyMids2(String syMids2) {
		this.syMids2 = syMids2;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public Integer getYxMeter() {
		return yxMeter;
	}
	public void setYxMeter(Integer yxMeter) {
		this.yxMeter = yxMeter;
	}
	public Integer getZwxbTime() {
		return zwxbTime;
	}
	public void setZwxbTime(Integer zwxbTime) {
		this.zwxbTime = zwxbTime;
	}
	public Integer getZzsbTime() {
		return zzsbTime;
	}
	public void setZzsbTime(Integer zzsbTime) {
		this.zzsbTime = zzsbTime;
	}
	
	

}
