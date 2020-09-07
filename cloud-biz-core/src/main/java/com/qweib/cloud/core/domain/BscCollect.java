package com.qweib.cloud.core.domain;

/**
 * 个人收藏表
 */
public class BscCollect {
    private Integer collectId;//自增id
    private Integer memberId;
    private Integer topicId;
    private String collecTime;

    public Integer getCollectId() {
        return collectId;
    }

    public void setCollectId(Integer collectId) {
        this.collectId = collectId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getTopicId() {
        return topicId;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
    }

    public String getCollecTime() {
        return collecTime;
    }

    public void setCollecTime(String collecTime) {
        this.collecTime = collecTime;
    }


}
