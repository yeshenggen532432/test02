package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

public class SysQuestionnaire {
    private Integer qid;//增自id
    private Integer memberId;//发布人id
    private String stime;//发表时间
    private String title;//标题
    private String content;//内容
    private Integer dsck;//单双选项 0为不限制 1 单选 2以上 最多可选择的项数
    private String etime;//截止时间
    private Integer branchId;//所属部门
    //----------------不在数据库-------------------------
    private String memberNm;//发表人名称
    private String branchName;//部门名称
    
    /////
    private List<SysQuestionnaireDetail> detailList;   //选项数组
    
    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysQuestionnaireDetail> getDetailList() {
		return detailList;
	}
	public void setDetailList(List<SysQuestionnaireDetail> detailList) {
		this.detailList = detailList;
	}
	
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getDsck() {
		return dsck;
	}
	public void setDsck(Integer dsck) {
		this.dsck = dsck;
	}
	public String getEtime() {
		return etime;
	}
	public void setEtime(String etime) {
		this.etime = etime;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public Integer getQid() {
		return qid;
	}
	public void setQid(Integer qid) {
		this.qid = qid;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Integer getBranchId() {
		return branchId;
	}
	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}
	@TableAnnotation(insertAble = false, updateAble = false)
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
    
}
