package com.qweib.cloud.core.domain.vo;


import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.utils.TableAnnotation;

/**
 * @author Administrator
 *
 */
public class SysRoleVO extends SysRole {

	private String nms;

	@TableAnnotation(updateAble=false,insertAble=false)
	public String getNms() {
		return nms;
	}

	public void setNms(String nms) {
		this.nms = nms;
	}



}
