package com.qweib.cloud.core.domain;
/**
 *说明：道谢并告知下次拜访日期
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfgzxc {
	private Integer id;//道谢并告知下次拜访日期id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String bcbfzj;//本次拜访总结
	private String dbsx;//代办事项
	private String dqdate;//当前日期
	private String xcdate;//下次拜访日期
	private String ddtime;//当前时间
	private String longitude;//经度
	private String latitude;//纬度
	private String address;//地址
	private String voiceUrl;//语音地址
	private Integer voiceTime;//语音时长
	
	
	public String getVoiceUrl() {
		return voiceUrl;
	}
	public void setVoiceUrl(String voiceUrl) {
		this.voiceUrl = voiceUrl;
	}
	public Integer getVoiceTime() {
		return voiceTime;
	}
	public void setVoiceTime(Integer voiceTime) {
		this.voiceTime = voiceTime;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
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
	public String getBcbfzj() {
		return bcbfzj;
	}
	public void setBcbfzj(String bcbfzj) {
		this.bcbfzj = bcbfzj;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getDbsx() {
		return dbsx;
	}
	public void setDbsx(String dbsx) {
		this.dbsx = dbsx;
	}
	public String getDdtime() {
		return ddtime;
	}
	public void setDdtime(String ddtime) {
		this.ddtime = ddtime;
	}
	public String getDqdate() {
		return dqdate;
	}
	public void setDqdate(String dqdate) {
		this.dqdate = dqdate;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getXcdate() {
		return xcdate;
	}
	public void setXcdate(String xcdate) {
		this.xcdate = xcdate;
	}
	
	

}
