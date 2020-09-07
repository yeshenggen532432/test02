package com.qweib.cloud.core.domain;

/**
 * @说明：功能菜单
 * @创建：作者:yxy		创建时间：2011-4-13
 * @修改历史：
 *		[序号](yxy	2011-4-13)<修改说明>
 */
public class SysMenu {
	private Integer idKey;		//主键(必填)
	private String menuNm;		//菜单名称(必填)
	private String menuCd;		//菜单编号(必填)(唯一)
	private String menuUrl;		//连接地址
	private String menuCls;		//菜单样式
	private Integer pId;		//父菜单(必填) 0为第一级菜单
	private String menuTp;		//菜单类型(必填)  0--功能菜单  1-功能按钮
	private String menuSeq;		//菜单排序
	private String isUse;		//是否启用(必填)  0--停用   1--使用
	private String menuLeaf;	//是否明细菜单  0--否  1--是
	private String menuRemo;	//备注
	public Integer getIdKey() {
		return idKey;
	}
	public void setIdKey(Integer idKey) {
		this.idKey = idKey;
	}
	public Integer getPId() {
		return pId;
	}
	public void setPId(Integer id) {
		pId = id;
	}
	public String getMenuLeaf() {
		return menuLeaf;
	}
	public void setMenuLeaf(String menuLeaf) {
		this.menuLeaf = menuLeaf;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
	public String getMenuRemo() {
		return menuRemo;
	}
	public void setMenuRemo(String menuRemo) {
		this.menuRemo = menuRemo;
	}
	public String getMenuTp() {
		return menuTp;
	}
	public void setMenuTp(String menuTp) {
		this.menuTp = menuTp;
	}
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public String getMenuCls() {
		return menuCls;
	}
	public void setMenuCls(String menuCls) {
		this.menuCls = menuCls;
	}
	public String getMenuSeq() {
		return menuSeq;
	}
	public void setMenuSeq(String menuSeq) {
		this.menuSeq = menuSeq;
	}
}

