package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * @说明：照片墙评论类
 * @创建者： 作者：llp 创建时间：2014-5-6
 */
public class BscPhotoWallComment {

    private Integer commentId; // id
    private Integer wallId; // 所属照片墙id
    private Integer memberId; // 评论者id
    private String addtime; // 评论时间
    private String comment; // 评论内容

    private Integer isrc;    //是否为回复:0:评论1:回复
    private Integer recomment; //回复人ID如果该条信息类型为回复该值为回复人的ID，如果为评论改条为0

    public Integer getIsrc() {
        return isrc;
    }

    public void setIsrc(Integer isrc) {
        this.isrc = isrc;
    }

    public Integer getRecomment() {
        return recomment;
    }

    public void setRecomment(Integer recomment) {
        this.recomment = recomment;
    }

    // ------------------不在数据库--------------
    private String memberNm; // 评论者名称
    private String memberHead; // 评论者头像
    private String recomNm; //回复者姓名

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getRecomNm() {
        return recomNm;
    }

    public void setRecomNm(String recomNm) {
        this.recomNm = recomNm;
    }

    private BscPhotoWall bp; //评论的照片墙

    @TableAnnotation(insertAble = false, updateAble = false)
    public BscPhotoWall getBp() {
        return bp;
    }

    public void setBp(BscPhotoWall bp) {
        this.bp = bp;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getCommentId() {
        return commentId;
    }

    public void setCommentId(Integer commentId) {
        this.commentId = commentId;
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

    public Integer getWallId() {
        return wallId;
    }

    public void setWallId(Integer wallId) {
        this.wallId = wallId;
    }
}
