package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 *
 */
public class SysFixedField {
	private Integer id;
	private String name;
	private String status;
	private String fdModel;
	private String fdWay;//
	private String fdCode;//

	private Integer costTypeId;//科目类别ID
	private Integer costItemId;//科目明细ID
	private Integer mergeToRec;//是否合并到收付款 0：否 1：是

	private String costTypeName;
	private String costItemName;

	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getFdModel() {
		return fdModel;
	}
	public void setFdModel(String fdModel) {
		this.fdModel = fdModel;
	}

	public String getFdWay() { return fdWay; }
	public void setFdWay(String fdWay) { this.fdWay = fdWay; }

	public String getFdCode() {
		return fdCode;
	}

	public void setFdCode(String fdCode) {
		this.fdCode = fdCode;
	}

	public Integer getCostTypeId() {
		return costTypeId;
	}

	public void setCostTypeId(Integer costTypeId) {
		this.costTypeId = costTypeId;
	}

	public Integer getCostItemId() {
		return costItemId;
	}

	public void setCostItemId(Integer costItemId) {
		this.costItemId = costItemId;
	}

	public Integer getMergeToRec() {
		return mergeToRec;
	}

	public void setMergeToRec(Integer mergeToRec) {
		this.mergeToRec = mergeToRec;
	}

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getCostTypeName() {
		return costTypeName;
	}

	public void setCostTypeName(String costTypeName) {
		this.costTypeName = costTypeName;
	}

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getCostItemName() {
		return costItemName;
	}

	public void setCostItemName(String costItemName) {
		this.costItemName = costItemName;
	}
}
