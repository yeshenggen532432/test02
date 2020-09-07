package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

public class SysQuestionnaireDetail {
	private Integer id;//自增id
	private Integer qid;//问卷id
	private String no;//排序
	private String content;//内容
	
	/********************************/
	private Double ratio;//比率
	private Integer isCheck;
	@TableAnnotation(insertAble=false,updateAble=false,nullToUpdate=false)
	public Double getRatio() {
		return ratio;
	}
	public void setRatio(Double ratio) {
		this.ratio = ratio;
	}
	@TableAnnotation(insertAble=false,updateAble=false,nullToUpdate=false)
	public Integer getIsCheck() {
		return isCheck;
	}
	public void setIsCheck(Integer isCheck) {
		this.isCheck = isCheck;
	}
	/********************************/
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public Integer getQid() {
		return qid;
	}
	public void setQid(Integer qid) {
		this.qid = qid;
	}
	
	
}
