package com.qweib.cloud.core.domain;
/**
  *@说明：部门和成员关系表
  *@创建：作者:yxy		创建时间：2014-4-10
  *@param  
  *@修改历史：
  *		[序号](yxy	2014-4-10)<修改说明>
 */
public class SysDeptMember {
	private Integer idKey;				//主键自增id
	private Integer deptId;				//所属部门id
	private String deptPath;			//所属部门关系
	private Integer memberId;			//所属成员
	private String post;				//职务
	private String isAdmin;				//是否管理员
	public Integer getDeptId() {
		return deptId;
	}
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	public String getDeptPath() {
		return deptPath;
	}
	public void setDeptPath(String deptPath) {
		this.deptPath = deptPath;
	}
	public Integer getIdKey() {
		return idKey;
	}
	public void setIdKey(Integer idKey) {
		this.idKey = idKey;
	}
	public String getIsAdmin() {
		return isAdmin;
	}
	public void setIsAdmin(String isAdmin) {
		this.isAdmin = isAdmin;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getPost() {
		return post;
	}
	public void setPost(String post) {
		this.post = post;
	}
}
