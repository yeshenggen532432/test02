package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.Date;

/**
 * 打印日志
 * @author apple
 */
public class SysPrintRecord {
	private Integer id;
	private String  fdModel;//所属模块
	private Integer fdSourceId;
	private String  fdSourceNo;
	private Integer createId;//创建人
	private String  createName;//创建人名称
	private Date    createTime;//创建时间
	private String fdSourceIds;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getCreateId() {
		return createId;
	}
	public void setCreateId(Integer createId) {
		this.createId = createId;
	}
	public String getCreateName() {
		return createName;
	}
	public void setCreateName(String createName) {
		this.createName = createName;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getFdModel() {
		return fdModel;
	}
	public void setFdModel(String fdModel) {
		this.fdModel = fdModel;
	}
	public Integer getFdSourceId() {
		return fdSourceId;
	}
	public void setFdSourceId(Integer fdSourceId) {
		this.fdSourceId = fdSourceId;
	}
	public String getFdSourceNo() {
		return fdSourceNo;
	}
	public void setFdSourceNo(String fdSourceNo) {
		this.fdSourceNo = fdSourceNo;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getFdSourceIds() { return fdSourceIds; }
	public void setFdSourceIds(String fdSourceIds) { this.fdSourceIds = fdSourceIds; }
}
