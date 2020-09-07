package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 申请加入公司
 */
public class SysCompanyJoin {
    private Integer id;
    private Integer memberId; //申请人id
    private String memberName; //申请人名称
    private String memberMobile; //申请人手机号
    private String createTime;//创建时间
    private Integer status; //同意状态：1.同意  2：不同意
    private Integer userId;//操作人id

    //--------------------不在数据库中--------------------------------
    private String userName;//审批人
    private String edate;//结束时间
    private String sdate;//开始时间

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberMobile() {
        return memberMobile;
    }

    public void setMemberMobile(String memberMobile) {
        this.memberMobile = memberMobile;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    //--------------------不在数据库中--------------------------------
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getEdate() {
        return edate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }
}
