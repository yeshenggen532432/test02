package com.qweib.cloud.core.domain;
/**
 *说明：陈列检查采集模板
 *@创建：作者:llp		创建时间：2016-3-24
 *@修改历史：
 *		[序号](llp	2016-3-24)<修改说明>
 */
public class SysCljccjMd {
	private Integer id;//陈列检查采集模板id
	private String mdNm;//名称
	private Integer isHjpms;//货架排面数（1显示；2不显示）
	private Integer isDjpms;//端架排面数（1显示；2不显示）
	private Integer isSytwl;//收银台围栏（1显示；2不显示）
	private Integer isBds;//冰点数（1显示；2不显示）
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getIsBds() {
		return isBds;
	}
	public void setIsBds(Integer isBds) {
		this.isBds = isBds;
	}
	public Integer getIsDjpms() {
		return isDjpms;
	}
	public void setIsDjpms(Integer isDjpms) {
		this.isDjpms = isDjpms;
	}
	public Integer getIsHjpms() {
		return isHjpms;
	}
	public void setIsHjpms(Integer isHjpms) {
		this.isHjpms = isHjpms;
	}
	public Integer getIsSytwl() {
		return isSytwl;
	}
	public void setIsSytwl(Integer isSytwl) {
		this.isSytwl = isSytwl;
	}
	public String getMdNm() {
		return mdNm;
	}
	public void setMdNm(String mdNm) {
		this.mdNm = mdNm;
	}
	
	

}
