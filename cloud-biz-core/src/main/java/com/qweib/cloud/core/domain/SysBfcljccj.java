package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 *说明：陈列检查采集
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfcljccj {
	private Integer id;//陈列检查采集id
	private Integer mid;//务业员id
	private Integer cid;//客户id
	private Integer mdid;//模板id
	private String hjpms;//货架排面数
	private String djpms;//端架排面数
	private String sytwl;//收银台围栏
	private String bds;//冰点数
	private String remo;//摘要
	private String cjdate;//日期
	private List<SysBfxgPic> bfxgPicLs;
	private String mdNm;//模板名称
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMdNm() {
		return mdNm;
	}
	public void setMdNm(String mdNm) {
		this.mdNm = mdNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysBfxgPic> getBfxgPicLs() {
		return bfxgPicLs;
	}
	public void setBfxgPicLs(List<SysBfxgPic> bfxgPicLs) {
		this.bfxgPicLs = bfxgPicLs;
	}
	public String getBds() {
		return bds;
	}
	public void setBds(String bds) {
		this.bds = bds;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getCjdate() {
		return cjdate;
	}
	public void setCjdate(String cjdate) {
		this.cjdate = cjdate;
	}
	public String getDjpms() {
		return djpms;
	}
	public void setDjpms(String djpms) {
		this.djpms = djpms;
	}
	public String getHjpms() {
		return hjpms;
	}
	public void setHjpms(String hjpms) {
		this.hjpms = hjpms;
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
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public String getSytwl() {
		return sytwl;
	}
	public void setSytwl(String sytwl) {
		this.sytwl = sytwl;
	}
	public Integer getMdid() {
		return mdid;
	}
	public void setMdid(Integer mdid) {
		this.mdid = mdid;
	}
	
	
	

}
