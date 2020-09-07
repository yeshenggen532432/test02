package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 知识点
 */
public class BscKnowledge {

    private Integer knowledgeId;//知识库id
    private Integer topicId;//员工圈id
    private String topicTitle;//标题
    private Integer memberId;//发表人
    private String topiContent;//发表内容
    private String topicTime;//发表时间
    private Integer topicNum;//评论数:默认0
    private Integer sortId;//所属分类
    private String tp;//类型 1 圈帖子 2 url 3 文件
    private Integer operateId;//操作人

    //不在数据库
    private String memberNm;
    private String operateNm;//操作人


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getOperateNm() {
        return operateNm;
    }

    public void setOperateNm(String operateNm) {
        this.operateNm = operateNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getOperateId() {
        return operateId;
    }

    public void setOperateId(Integer operateId) {
        this.operateId = operateId;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public Integer getKnowledgeId() {
        return knowledgeId;
    }

    public void setKnowledgeId(Integer knowledgeId) {
        this.knowledgeId = knowledgeId;
    }

    public Integer getTopicId() {
        return topicId;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
    }

    public String getTopicTitle() {
        return topicTitle;
    }

    public void setTopicTitle(String topicTitle) {
        this.topicTitle = topicTitle;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getTopiContent() {
        return topiContent;
    }

    public void setTopiContent(String topiContent) {
        this.topiContent = topiContent;
    }

    public String getTopicTime() {
        return topicTime;
    }

    public void setTopicTime(String topicTime) {
        this.topicTime = topicTime;
    }

    public Integer getTopicNum() {
        return topicNum;
    }

    public void setTopicNum(Integer topicNum) {
        this.topicNum = topicNum;
    }

    public Integer getSortId() {
        return sortId;
    }

    public void setSortId(Integer sortId) {
        this.sortId = sortId;
    }

    public BscKnowledge(BscTopic topic, Integer sortId, String tp, Integer memId) {
        this.topicId = topic.getTopicId();
        this.topicTitle = topic.getTopicTitle();
        this.memberId = topic.getMemberId();
        this.topiContent = topic.getTopiContent();
        this.topicTime = topic.getTopicTime();
        this.topicNum = topic.getTopicNum();
        this.sortId = sortId;
        this.tp = tp;
        this.operateId = memId;
    }

    public BscKnowledge() {
        super();
        // TODO Auto-generated constructor stub
    }

    //外部链接的知识库构造函数
    public BscKnowledge(BscTopic topic, Integer sortId, String tp,
                        String str, Integer memId) {
        this.topicId = topic.getTopicId();
        this.topicTitle = topic.getTopicTitle();
        this.memberId = topic.getMemberId();
        this.topiContent = topic.getUrl();
        this.topicTime = topic.getTopicTime();
        this.topicNum = topic.getTopicNum();
        this.sortId = sortId;
        this.tp = tp;
        this.operateId = memId;
    }


}
