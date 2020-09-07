package com.qweib.cloud.core.domain;
/**
 *说明：系统参数
 *@创建：作者:llp		创建时间：2016-10-24
 *@修改历史：
 *		[序号](llp	2016-10-24)<修改说明>
 */
public class SysXtcs {
	private Integer id;//系统参数id
	private String xtNm;//名称
	private Integer xtCsz;//数值
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getXtCsz() {
		return xtCsz;
	}
	public void setXtCsz(Integer xtCsz) {
		this.xtCsz = xtCsz;
	}
	public String getXtNm() {
		return xtNm;
	}
	public void setXtNm(String xtNm) {
		this.xtNm = xtNm;
	}
	
	

}
