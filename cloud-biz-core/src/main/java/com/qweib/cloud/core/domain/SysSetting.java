package com.qweib.cloud.core.domain;
/**
 *消息设置表
 */
public class SysSetting {
	   private Integer nID;//自增id
	   private String sKey;//键名
	   private String sKeyValue;//键值
	   private Integer memberId;//用户id
	public Integer getnID() {
		return nID;
	}
	public void setnID(Integer nID) {
		this.nID = nID;
	}
	public String getsKey() {
		return sKey;
	}
	public void setsKey(String sKey) {
		this.sKey = sKey;
	}
	public String getsKeyValue() {
		return sKeyValue;
	}
	public void setsKeyValue(String sKeyValue) {
		this.sKeyValue = sKeyValue;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	   
	   
	   

}
