package com.qweib.cloud.core.domain;
//日报文字长度限制设置
public class SysReportCd {
	private Integer id;//主键id
	private Integer gzNrcd;//工作内容字长度
	private Integer gzZjcd;//工作总结字长度
	private Integer gzJhcd;//工作计划字长度
	private Integer gzBzcd;//帮助与支持字长度
	private Integer remocd;//备注字长度
	
	
	public Integer getGzBzcd() {
		return gzBzcd;
	}
	public void setGzBzcd(Integer gzBzcd) {
		this.gzBzcd = gzBzcd;
	}
	public Integer getGzJhcd() {
		return gzJhcd;
	}
	public void setGzJhcd(Integer gzJhcd) {
		this.gzJhcd = gzJhcd;
	}
	public Integer getGzNrcd() {
		return gzNrcd;
	}
	public void setGzNrcd(Integer gzNrcd) {
		this.gzNrcd = gzNrcd;
	}
	public Integer getGzZjcd() {
		return gzZjcd;
	}
	public void setGzZjcd(Integer gzZjcd) {
		this.gzZjcd = gzZjcd;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getRemocd() {
		return remocd;
	}
	public void setRemocd(Integer remocd) {
		this.remocd = remocd;
	}
	
	
}
