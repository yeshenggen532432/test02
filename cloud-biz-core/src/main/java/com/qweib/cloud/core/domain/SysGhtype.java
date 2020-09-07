package com.qweib.cloud.core.domain;
/**
 *说明：供货类型
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysGhtype {
	private Integer id;//供货类型id
	private String coding;//编码
	private String ghtpNm;//名称
	
	public String getCoding() {
		return coding;
	}
	public void setCoding(String coding) {
		this.coding = coding;
	}
	public String getGhtpNm() {
		return ghtpNm;
	}
	public void setGhtpNm(String ghtpNm) {
		this.ghtpNm = ghtpNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	
}
