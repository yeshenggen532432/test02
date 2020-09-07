package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.Date;
import java.util.List;

/**
 * 客户信息导入主表
 */
public class SysCustomerImportMain {
	private Integer id;
	private String title;//名称
	private Date importTime;
	private Integer operId;//操作人
	private String operName;//操作人

	private List<SysCustomerImportSub> list;//详情集合
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Date getImportTime() {
		return importTime;
	}
	public void setImportTime(Date importTime) {
		this.importTime = importTime;
	}

	public Integer getOperId() {
		return operId;
	}

	public void setOperId(Integer operId) {
		this.operId = operId;
	}

	public String getOperName() {
		return operName;
	}

	public void setOperName(String operName) {
		this.operName = operName;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysCustomerImportSub> getList() {
		return list;
	}

	public void setList(List<SysCustomerImportSub> list) {
		this.list = list;
	}
}
