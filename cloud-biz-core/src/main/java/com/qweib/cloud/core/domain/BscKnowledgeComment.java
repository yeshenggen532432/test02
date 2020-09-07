package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.ArrayList;
import java.util.List;

/**
 * 知识点评论
 */
public class BscKnowledgeComment {

    private Integer commentId;//评论id
    private Integer knowledgeId;//所属知识点
    private Integer memberId;//评论人
    private String commentTime;//评论时间
    private String content;//评论内容
    private Integer belongId;//回复的对象id 0 为评论 其他为回复的对应评论id
    private Integer rcId;//被回复人id
    private String rcNm;//被回复人用户名


    //不在数据库
    private String memberNm;
    private List<BscKnowledgeComment> rcList = new ArrayList<BscKnowledgeComment>();

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscKnowledgeComment> getRcList() {
        return rcList;
    }

    public void setRcList(List<BscKnowledgeComment> rcList) {
        this.rcList = rcList;
    }

    public Integer getCommentId() {
        return commentId;
    }

    public void setCommentId(Integer commentId) {
        this.commentId = commentId;
    }

    public Integer getKnowledgeId() {
        return knowledgeId;
    }

    public void setKnowledgeId(Integer knowledgeId) {
        this.knowledgeId = knowledgeId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(String commentTime) {
        this.commentTime = commentTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getBelongId() {
        return belongId;
    }

    public void setBelongId(Integer belongId) {
        this.belongId = belongId;
    }

    public Integer getRcId() {
        return rcId;
    }

    public void setRcId(Integer rcId) {
        this.rcId = rcId;
    }

    public String getRcNm() {
        return rcNm;
    }

    public void setRcNm(String rcNm) {
        this.rcNm = rcNm;
    }

    public BscKnowledgeComment(Integer knowledgeId,
                               BscTopicComment comment) {
        this.knowledgeId = knowledgeId;
        this.memberId = comment.getMemberId();
        this.commentTime = comment.getCommentTime();
        this.content = comment.getContent();
        this.belongId = comment.getBelongId();
        this.rcId = comment.getRcId();
        this.rcNm = comment.getRcNm();
    }

    public BscKnowledgeComment() {
        super();
        // TODO Auto-generated constructor stub
    }


}
