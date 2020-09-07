package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.ArrayList;
import java.util.List;

/**
 * 基础话题评论
 */
public class BscTopicComment {

    private Integer commentId;//评论id
    private Integer topicId;//所属话题
    private Integer memberId;//评论人
    private String commentTime;//评论时间
    private String content;//评论内容
    private Integer belongId;//回复的对象id 0 为评论 其他为回复的对应评论id
    private Integer rcId;//被回复人id
    private String rcNm;//被回复人用户名


    /////不在数据库//////
    private String memberNm;
    private List<BscTopicComment> rcList = new ArrayList<BscTopicComment>();

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscTopicComment> getRcList() {
        return rcList;
    }

    public void setRcList(List<BscTopicComment> rcList) {
        this.rcList = rcList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getCommentId() {
        return commentId;
    }

    public void setCommentId(Integer commentId) {
        this.commentId = commentId;
    }

    public Integer getTopicId() {
        return topicId;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
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

    public String getRcNm() {
        return rcNm;
    }

    public void setRcNm(String rcNm) {
        this.rcNm = rcNm;
    }

    public Integer getRcId() {
        return rcId;
    }

    public void setRcId(Integer rcId) {
        this.rcId = rcId;
    }


}
