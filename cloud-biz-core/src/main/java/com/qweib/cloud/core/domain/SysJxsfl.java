package com.qweib.cloud.core.domain;
/**
 *说明：经销商分类
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysJxsfl {
	private Integer id;//经销商分类id
	private String coding;//编码
	private String flNm;//名称
	
	public String getCoding() {
		return coding;
	}
	public void setCoding(String coding) {
		this.coding = coding;
	}
	public String getFlNm() {
		return flNm;
	}
	public void setFlNm(String flNm) {
		this.flNm = flNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	
}
