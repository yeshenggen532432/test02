package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class BscKnowledgePraise {

    private Integer knowledgeId;//知识点id
    private Integer memberId;//赞的人

    ///不在数据库////
    private String memberHead;//头像
    private String memberNm;//用户名

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
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

    public BscKnowledgePraise(Integer knowledgeId, Integer memberId) {
        super();
        this.knowledgeId = knowledgeId;
        this.memberId = memberId;
    }

    public BscKnowledgePraise() {
        super();
        // TODO Auto-generated constructor stub
    }


}
