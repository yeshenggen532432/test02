package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 真心话
 *
 * @author guojp
 */
public class BscTrue {
    /**
     * 自增id
     */
    private Integer trueId;
    /**
     * 发表人id
     */
    private Integer memberId;
    /**
     * 发表时间
     */
    private String trueTime;
    /**
     * 标题
     */
    private String title;
    /**
     * 内容
     */
    private String content;
    /**
     * 跟帖人数
     */
    private Integer trueCount;
    /********************页面显示*****************/
    /**
     * 开始时间
     */
    private String startTime;
    /**
     * 结束时间
     */
    private String endTime;
    /**
     * 发表人名称
     */
    private String memberNm;

    /********************页面显示*****************/
    public Integer getTrueId() {
        return trueId;
    }

    public void setTrueId(Integer trueId) {
        this.trueId = trueId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getTrueTime() {
        return trueTime;
    }

    public void setTrueTime(String trueTime) {
        this.trueTime = trueTime;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getTrueCount() {
        return trueCount;
    }

    public void setTrueCount(Integer trueCount) {
        this.trueCount = trueCount;
    }

    @TableAnnotation(updateAble = false)
    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    @TableAnnotation(updateAble = false)
    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    @TableAnnotation(updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }
}	
