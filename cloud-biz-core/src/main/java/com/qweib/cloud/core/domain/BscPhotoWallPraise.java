package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * @说明：照片墙赞类
 * @创建者： 作者：llp   创建时间：2014-5-6
 */
public class BscPhotoWallPraise {
    private Integer wallId;              //所属照片墙id
    private Integer memberId;            //赞用户id
    private String clickTime;            //点击时间


    public String getClickTime() {
        return clickTime;
    }

    public void setClickTime(String clickTime) {
        this.clickTime = clickTime;
    }

    //-------------------不在数据库---------------------
    private String memberNm;             //赞用户名称
    private String memberHead;             //赞用户头像

    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
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
