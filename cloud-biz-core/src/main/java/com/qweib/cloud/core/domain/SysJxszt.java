package com.qweib.cloud.core.domain;
/**
 *说明：经销商状态
 *@创建：作者:llp		创建时间：2016-2-16
 *@修改历史：
 *		[序号](llp	2016-2-16)<修改说明>
 */
public class SysJxszt {
	private Integer id;//经销商状态id
	private String coding;//编码
	private String ztNm;//名称
	
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
	public String getZtNm() {
		return ztNm;
	}
	public void setZtNm(String ztNm) {
		this.ztNm = ztNm;
	}
	
}
