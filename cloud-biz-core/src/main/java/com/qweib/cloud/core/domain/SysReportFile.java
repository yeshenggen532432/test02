package com.qweib.cloud.core.domain;
/**
 *说明：报文件
 *@创建：作者:llp		创建时间：2016-12-16
 *@修改历史：
 *		[序号](llp	2016-12-16)<修改说明>
 */
public class SysReportFile {
	private Integer bid;//报id
	private Integer tp;//文件类型（1图片；2附件）
	private String picMini;//小图
	private String pic;//大图
	private String wj;//附件
	
	
	public Integer getBid() {
		return bid;
	}
	public void setBid(Integer bid) {
		this.bid = bid;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
	public String getPicMini() {
		return picMini;
	}
	public void setPicMini(String picMini) {
		this.picMini = picMini;
	}
	public Integer getTp() {
		return tp;
	}
	public void setTp(Integer tp) {
		this.tp = tp;
	}
	public String getWj() {
		return wj;
	}
	public void setWj(String wj) {
		this.wj = wj;
	}
	
	

}
