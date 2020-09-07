package com.qweib.cloud.core.domain;
/**
 *说明：图片
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfxgPic {
	private Integer id;//图片id
	private Integer ssId;//所属板块id
	private Integer xxId;//详细id
	private Integer type;//1拜访签到拍照；2生动化；3堆头；4陈列检查采集；5道谢并告知下次拜访日期
	private String picMini;//小图
	private String pic;//大图
	
	
	public Integer getXxId() {
		return xxId;
	}
	public void setXxId(Integer xxId) {
		this.xxId = xxId;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
	public String getPicMini() {
		return picMini;
	}
	public void setPicMini(String picMini) {
		this.picMini = picMini;
	}
	public Integer getSsId() {
		return ssId;
	}
	public void setSsId(Integer ssId) {
		this.ssId = ssId;
	}
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	
	

}
