package com.qweib.cloud.core.domain;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

/**
 *说明：销售类型
 *@创建：作者:llp		创建时间：2016-4-13
 *@修改历史：
 *		[序号](llp	2016-4-13)<修改说明>
 */
@NoArgsConstructor
@AllArgsConstructor
public class SysXstype {
	private Integer id;//销售类型id
	private String xstpNm;//销售类型名称
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getXstpNm() {
		return xstpNm;
	}
	public void setXstpNm(String xstpNm) {
		this.xstpNm = xstpNm;
	}
	
	
}
