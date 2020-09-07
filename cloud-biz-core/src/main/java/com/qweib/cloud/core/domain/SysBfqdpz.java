package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：拜访签到拍照
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfqdpz {
	private Integer id;//拜访签到拍照id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String longitude;//经度
	private String latitude;//纬度
	private String address;//地址
	private String hbzt;//及时更换外观破损，肮脏的海报招贴
	private String ggyy;//拆除过时的附有旧广告用语的宣传品
	private String isXy;//是否显眼（1有，2无）
	private String remo;//摘要
	private String qddate;//签到日期
	private String qdtime;//签到时间
	//-----------------------不在数据库-------------------
	private String khNm;//客户名称
	private String memberNm;//业务员名称
	private String branchName;//部门名称
	private String khdjNm;//客户等级
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getKhdjNm() {
		return khdjNm;
	}
	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getGgyy() {
		return ggyy;
	}
	public void setGgyy(String ggyy) {
		this.ggyy = ggyy;
	}
	public String getHbzt() {
		return hbzt;
	}
	public void setHbzt(String hbzt) {
		this.hbzt = hbzt;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getIsXy() {
		return isXy;
	}
	public void setIsXy(String isXy) {
		this.isXy = isXy;
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
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getQddate() {
		return qddate;
	}
	public void setQddate(String qddate) {
		this.qddate = qddate;
	}
	public String getQdtime() {
		return qdtime;
	}
	public void setQdtime(String qdtime) {
		this.qdtime = qdtime;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	
	

}
