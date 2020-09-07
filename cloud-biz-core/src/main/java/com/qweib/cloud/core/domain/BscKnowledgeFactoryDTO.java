package com.qweib.cloud.core.domain;

import java.util.List;

/**
 * @author YYP
 */
public class BscKnowledgeFactoryDTO {
    private Integer KnowledgeId;
    private Integer memberId;
    private String memberHead;
    private String memberNm;
    private String topicTitle;
    private String topicTime;
    private String topiContent;
    private List<BscKnowledgePic> picList;
    //	private List<BscKnowledgePraise> praiseList;
//	private List<BscKnowledgeComment> commentList;
    private String tp;//类型 1 圈帖子 2 url 3 文件

    //增加文件字段用于查询包含文件的知识点详情
    private List<SysTaskAttachment> fileList;


    private String operateNm;//操作人


    public String getOperateNm() {
        return operateNm;
    }

    public void setOperateNm(String operateNm) {
        this.operateNm = operateNm;
    }

    public List<SysTaskAttachment> getFileList() {
        return fileList;
    }

    public void setFileList(List<SysTaskAttachment> fileList) {
        this.fileList = fileList;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public Integer getKnowledgeId() {
        return KnowledgeId;
    }

    public void setKnowledgeId(Integer knowledgeId) {
        KnowledgeId = knowledgeId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getTopicTitle() {
        return topicTitle;
    }

    public void setTopicTitle(String topicTitle) {
        this.topicTitle = topicTitle;
    }

    public String getTopicTime() {
        return topicTime;
    }

    public void setTopicTime(String topicTime) {
        this.topicTime = topicTime;
    }

    public List<BscKnowledgePic> getPicList() {
        return picList;
    }

    public void setPicList(List<BscKnowledgePic> picList) {
        this.picList = picList;
    }

    //	public List<BscKnowledgePraise> getPraiseList() {
//		return praiseList;
//	}
//	public void setPraiseList(List<BscKnowledgePraise> praiseList) {
//		this.praiseList = praiseList;
//	}
//	public List<BscKnowledgeComment> getCommentList() {
//		return commentList;
//	}
//	public void setCommentList(List<BscKnowledgeComment> commentList) {
//		this.commentList = commentList;
//	}
    public String getTopiContent() {
        return topiContent;
    }

    public void setTopiContent(String topiContent) {
        this.topiContent = topiContent;
    }


}
