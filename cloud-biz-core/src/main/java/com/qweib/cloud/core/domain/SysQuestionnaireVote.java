package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 问卷答题答案
 * 
 * @author Administrator
 * 
 */
public class SysQuestionnaireVote {

	private Integer id; // 自增ID

	private Integer optionId;// 选项ID

	private Integer memberId;// 人员ID

	private Integer problemId;// 问卷ID
	
	private String addTime;//投票时间
	
	/*****************************************/
	private Integer isCheck; //是否已选择  1是 2否
	private String ids;//选项ids
	
	
	
	
	public String getAddTime() {
		return addTime;
	}

	public void setAddTime(String addTime) {
		this.addTime = addTime;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@TableAnnotation(insertAble=false,updateAble=false,nullToUpdate=false)
	public Integer getIsCheck() {
		return isCheck;
	}

	public void setIsCheck(Integer isCheck) {
		this.isCheck = isCheck;
	}

	/*****************************************/

	@TableAnnotation(insertAble=false,updateAble=false,nullToUpdate=false)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getOptionId() {
		return optionId;
	}

	public void setOptionId(Integer optionId) {
		this.optionId = optionId;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public Integer getProblemId() {
		return problemId;
	}

	public void setProblemId(Integer problemId) {
		this.problemId = problemId;
	}

}
