package com.qweib.cloud.core.domain;
/**
 * 签到图片
 * @author guojp
 */
public class SysCheckinPic {
	/**
	 * 自增id
	 */
	private Integer id;
	/**
	 * 签到id
	 */
	private Integer checkinId;
	/**
	 * 图片
	 */
	private String pic;
	private String picMini;//小图片
	
	
	
	public String getPicMini() {
		return picMini;
	}
	public void setPicMini(String picMini) {
		this.picMini = picMini;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getCheckinId() {
		return checkinId;
	}
	public void setCheckinId(Integer checkinId) {
		this.checkinId = checkinId;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
}
