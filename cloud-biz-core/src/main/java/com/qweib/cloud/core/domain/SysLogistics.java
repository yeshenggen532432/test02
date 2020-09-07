package com.qweib.cloud.core.domain;
/**
 *说明：物流公司信息
 *@创建：作者:llp		创建时间：2016-2-17
 *@修改历史：
 *		[序号](llp	2016-2-17)<修改说明>
 */
public class SysLogistics {
	private Integer id;//物流公司id
	private String wlNm;//名称
	private String dcode;//代码
	private String linkman;//联系人
	private String tel;//联系电话
	private String address;//地址
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getDcode() {
		return dcode;
	}
	public void setDcode(String dcode) {
		this.dcode = dcode;
	}
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getWlNm() {
		return wlNm;
	}
	public void setWlNm(String wlNm) {
		this.wlNm = wlNm;
	}
	
	
	
	
}
