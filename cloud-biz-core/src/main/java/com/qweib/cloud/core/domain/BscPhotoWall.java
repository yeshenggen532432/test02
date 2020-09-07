package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * @说明：照片墙类
 * @创建者： 作者：llp 创建时间：2014-5-6
 */
public class BscPhotoWall {
    private Integer wallId; // id
    private Integer memberId; // 发表人id
    private String publishTime; // 发表时间
    private String publishContent; // 发表内容
    private Integer praiseNum; // 赞的条数默认0
    private Integer commentNum; // 评论数:默认0
    private String isTop;  //是否置顶

    public String getIsTop() {
        return isTop;
    }

    public void setIsTop(String isTop) {
        this.isTop = isTop;
    }


    // ------------不在数据库--------------------
    private String memberNm; // 发布人名称
    private String memberHead; // 发布人头像


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    private BscPhotoWallPic photoPic; // 瀑布流形式的图片形式展示

    @TableAnnotation(insertAble = false, updateAble = false)
    public BscPhotoWallPic getPhotoPic() {
        return photoPic;
    }

    public void setPhotoPic(BscPhotoWallPic photoPic) {
        photoPic.setPic(photoPic.getPic());
        photoPic.setPicMini(photoPic.getPicMini());
        this.photoPic = photoPic;
    }

    private List<BscPhotoWallComment> commentList; // 照片墙评论列表

    private List<BscPhotoWallPic> picList; // 照片墙图片列表

    private List<BscPhotoWallPraise> praiseList; // 照片墙点赞的集合

    private BscPhotoWallPraise praise;//赞

    @TableAnnotation(insertAble = false, updateAble = false)
    public BscPhotoWallPraise getPraise() {
        return praise;
    }

    public void setPraise(BscPhotoWallPraise praise) {
        this.praise = praise;
    }

    public List<BscPhotoWallPraise> getPraiseList() {
        return praiseList;
    }

    public void setPraiseList(List<BscPhotoWallPraise> praiseList) {
        this.praiseList = praiseList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscPhotoWallComment> getCommentList() {
        return commentList;
    }

    public void setCommentList(List<BscPhotoWallComment> commentList) {
        this.commentList = commentList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<BscPhotoWallPic> getPicList() {
        return picList;
    }

    public void setPicList(List<BscPhotoWallPic> picList) {
        for (int i = 0; i < picList.size(); i++) {
            picList.get(i).setPic(
                    picList.get(i).getPic());
            picList.get(i).setPicMini(
                    picList.get(i).getPicMini());
        }
        this.picList = picList;
    }

    public Integer getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(Integer commentNum) {
        this.commentNum = commentNum;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getPraiseNum() {
        return praiseNum;
    }

    public void setPraiseNum(Integer praiseNum) {
        this.praiseNum = praiseNum;
    }

    public String getPublishContent() {
        return publishContent;
    }

    public void setPublishContent(String publishContent) {
        this.publishContent = publishContent;
    }

    public String getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(String publishTime) {
        this.publishTime = publishTime;
    }

    public Integer getWallId() {
        return wallId;
    }

    public void setWallId(Integer wallId) {
        this.wallId = wallId;
    }

}
