package com.qweib.cloud.core.domain;
/**
 *说明：云文件密码
 *@创建：作者:llp		创建时间：2016-11-18
 *@修改历史：
 *		[序号](llp	2016-11-18)<修改说明>
 */
public class SysYfilepwd {
	private Integer memberId;//用户id
	private String yfPwd;//云文件密码
	
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getYfPwd() {
		return yfPwd;
	}
	public void setYfPwd(String yfPwd) {
		this.yfPwd = yfPwd;
	}
	
	

}
