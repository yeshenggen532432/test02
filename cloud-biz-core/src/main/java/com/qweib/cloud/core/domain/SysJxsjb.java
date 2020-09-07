package com.qweib.cloud.core.domain;
/**
 *说明：经销商级别
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysJxsjb {
	private Integer id;//经销商级别id
	private String coding;//编码
	private String jbNm;//名称
	
	public String getCoding() {
		return coding;
	}
	public void setCoding(String coding) {
		this.coding = coding;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getJbNm() {
		return jbNm;
	}
	public void setJbNm(String jbNm) {
		this.jbNm = jbNm;
	}
	
}
