package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 基础讨论区话题主题表
 */
public class BscTopic {
    private Integer topicId;//话题id
    private Integer tpType;//0 员工圈话题 1 真心话话题 2 外部来源(发帖)
    private Integer tpId;//tp为0，对应员工圈id    tp为1，对应真心话id
    private String topicTitle;//标题
    private Integer memberId;//发表人
    private String topiContent;//发表内容
    private String topicTime;//发表时间
    private Integer topicNum;//评论数:默认0
    private Integer praiseNum;//赞数 默认0
    private String isTop;//是否置顶:1.是0.否 默认0
    private String isAnonymity;//是否匿名（0 否 1 是）
    private String url;//外部链接地址

    private List<BscTopicPic> picList;
    /****************页面显示*****************/
    private String pic; //图片
    private String memberNm; //名称
    private String memberHead; //头像

    /****************页面显示*****************/


    public Integer getTopicId() {
        return topicId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
    }

    public Integer getTpType() {
        return tpType;
    }

    public void setTpType(Integer tpType) {
        this.tpType = tpType;
    }

    public Integer getTpId() {
        return tpId;
    }

    public void setTpId(Integer tpId) {
        this.tpId = tpId;
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

    public Integer getPraiseNum() {
        return praiseNum;
    }

    public void setPraiseNum(Integer praiseNum) {
        this.praiseNum = praiseNum;
    }

    public String getIsTop() {
        return isTop;
    }

    public void setIsTop(String isTop) {
        this.isTop = isTop;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscTopicPic> getPicList() {
        return picList;
    }

    public void setPicList(List<BscTopicPic> picList) {
        this.picList = picList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getIsAnonymity() {
        return isAnonymity;
    }

    public void setIsAnonymity(String isAnonymity) {
        this.isAnonymity = isAnonymity;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }
}
