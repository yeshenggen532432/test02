package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * @author Administrator
 *
 */
public class SysRoleMenu {

	private Integer idKey;//自增id
	private Integer roleId;//角色id
	private Integer menuId;//菜单id
	private String tp;//类型 1 menu 2 应用
	private String dataTp;//关联类型 1 全部 2 部门及子部门 3 个人
	private String sgtjz;//四个报表限权
	private String mids;//用户id组
	
	/////////
	private Integer bindId;//菜单或应用绑定id
	private String ifChecked;//是否选中
	
	
	
	public String getMids() {
		return mids;
	}
	public void setMids(String mids) {
		this.mids = mids;
	}
	public String getSgtjz() {
		return sgtjz;
	}
	public void setSgtjz(String sgtjz) {
		this.sgtjz = sgtjz;
	}
	public Integer getIdKey() {
		return idKey;
	}
	public void setIdKey(Integer idKey) {
		this.idKey = idKey;
	}
	public Integer getRoleId() {
		return roleId;
	}
	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}
	public Integer getMenuId() {
		return menuId;
	}
	public void setMenuId(Integer menuId) {
		this.menuId = menuId;
	}
	public String getTp() {
		return tp;
	}
	public void setTp(String tp) {
		this.tp = tp;
	}
	public String getDataTp() {
		return dataTp;
	}
	public void setDataTp(String dataTp) {
		this.dataTp = dataTp;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getBindId() {
		return bindId;
	}
	public void setBindId(Integer bindId) {
		this.bindId = bindId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getIfChecked() {
		return ifChecked;
	}
	public void setIfChecked(String ifChecked) {
		this.ifChecked = ifChecked;
	}
	
	
	
	
	
}
