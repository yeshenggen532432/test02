package com.qweib.cloud.core.domain;



/**
 * 员工位置上传
 * @author ysg
 */
public class SysAddressUpload {
	/**
	 * 备注：上传位置的逻辑
	 * 1）后台当设置不上传时，业务员自己设置不起作用；
	 * 2）后台当设置上传时，业务员自己可以设置上传还是不上传
	 */
	private Integer id;
	private Integer memId;//员工id
	private Integer upload;//上传方式：0不上传，1上传
	private Integer min;//上传间隔默认1分钟
	private Integer memUpload;//业务员自己修改上传方式：0不上传，1上传（默认）
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getMemId() {
		return memId;
	}
	public void setMemId(Integer memId) {
		this.memId = memId;
	}
	public Integer getUpload() {
		return upload;
	}
	public void setUpload(Integer upload) {
		this.upload = upload;
	}
	public Integer getMin() {
		return min;
	}
	public void setMin(Integer min) {
		this.min = min;
	}
	public Integer getMemUpload() {
		return memUpload;
	}
	public void setMemUpload(Integer memUpload) {
		this.memUpload = memUpload;
	}
	
	
}