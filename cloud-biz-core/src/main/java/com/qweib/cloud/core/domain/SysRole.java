package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：角色模型
 *@创建：作者:yxy		创建时间：2012-3-19
 *@修改历史：
 *		[序号](yxy	2012-3-19)<修改说明>
 */
public class SysRole {
	private Integer idKey;				//角色主键id
	private String roleNm;				//角色名称
	private String createDt;			//创建时间
	private Integer createId;			//创建人id
	private String remo;				//备注
	private String roleCd;               //角色编码
	private Integer status;             //状态
	
	@TableAnnotation(updateAble=false)
	public String getCreateDt() {
		return createDt;
	}
	public void setCreateDt(String createDt) {
		this.createDt = createDt;
	}
	@TableAnnotation(updateAble=false)
	public Integer getCreateId() {
		return createId;
	}
	public void setCreateId(Integer createId) {
		this.createId = createId;
	}
	public Integer getIdKey() {
		return idKey;
	}
	public void setIdKey(Integer idKey) {
		this.idKey = idKey;
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public String getRoleCd() {
		return roleCd;
	}
	public void setRoleCd(String roleCd) {
		this.roleCd = roleCd;
	}
	public Integer getStatus(){
		return status;
	}
	public void setStatus(Integer status){
		this.status = status;
	}
}

