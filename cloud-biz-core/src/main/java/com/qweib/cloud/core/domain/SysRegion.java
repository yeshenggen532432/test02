package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 区域基础数量
 */
public class SysRegion {
	
	private Integer regionId;//分类id
	private String regionNm;//分类名称
	private Integer regionPid;//所属分类
	private String regionPath;//分类路径
	private String regionLeaf;//分类末级
	 /************************不在数据库*******************************/
	private String upRegionNm;
	private List<SysRegion> list2;


	@TableAnnotation(insertAble = false, updateAble = false)
	public List<SysRegion> getList2() {
		return list2;
	}
	public void setList2(List<SysRegion> list2) {
		this.list2 = list2;
	}

	public Integer getRegionId() {
		return regionId;
	}

	public void setRegionId(Integer regionId) {
		this.regionId = regionId;
	}

	public String getRegionNm() {
		return regionNm;
	}

	public void setRegionNm(String regionNm) {
		this.regionNm = regionNm;
	}

	public Integer getRegionPid() {
		return regionPid;
	}

	public void setRegionPid(Integer regionPid) {
		this.regionPid = regionPid;
	}

	public String getRegionPath() {
		return regionPath;
	}

	public void setRegionPath(String regionPath) {
		this.regionPath = regionPath;
	}

	public String getRegionLeaf() {
		return regionLeaf;
	}

	public void setRegionLeaf(String regionLeaf) {
		this.regionLeaf = regionLeaf;
	}

	@TableAnnotation(insertAble = false, updateAble = false)
	public String getUpRegionNm() {
		return upRegionNm;
	}

	public void setUpRegionNm(String upRegionNm) {
		this.upRegionNm = upRegionNm;
	}
}
