package com.qweib.cloud.core.domain;

/**
 * 商品分类图片
 */
public class SysWaretypePic {
	private Integer id;//图片id
	private Integer type;
	private String picMini;//小图
	private String pic;//大图
	private Integer waretypeId;//商品分类id
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
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public Integer getWaretypeId() {
		return waretypeId;
	}
	public void setWaretypeId(Integer waretypeId) {
		this.waretypeId = waretypeId;
	}
	
	
	
	

}
