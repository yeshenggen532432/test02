package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class SysMemBind {
    private Integer bindId;//自增id
    private Integer memberId;//成员id
    private String bindTp;//成员关系:1.好友2.黑名单
    private Integer bindMemberId;//关系成员id
    private String isShield;//是否屏蔽:1.是0.否
    private String isUsed;//是否常用1.是2.否
    //--------------------不在数据库------------------
    private String memberNm;//好友名称
    private String firstChar;//好友名称首字母
    private String memberHead;//好友头像
    private String memberMobile;//手机号码


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberMobile() {
        return memberMobile;
    }

    public void setMemberMobile(String memberMobile) {
        this.memberMobile = memberMobile;
    }

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

    public String getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(String isUsed) {
        this.isUsed = isUsed;
    }

    public Integer getBindId() {
        return bindId;
    }

    public void setBindId(Integer bindId) {
        this.bindId = bindId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getBindTp() {
        return bindTp;
    }

    public void setBindTp(String bindTp) {
        this.bindTp = bindTp;
    }

    public Integer getBindMemberId() {
        return bindMemberId;
    }

    public void setBindMemberId(Integer bindMemberId) {
        this.bindMemberId = bindMemberId;
    }

    public String getIsShield() {
        return isShield;
    }

    public void setIsShield(String isShield) {
        this.isShield = isShield;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getFirstChar() {
        return firstChar;
    }

    public void setFirstChar(String firstChar) {
        this.firstChar = firstChar;
    }


}
