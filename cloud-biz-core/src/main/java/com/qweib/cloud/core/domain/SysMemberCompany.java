package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

/**
 * 会员对应的企业
 */
public class SysMemberCompany {

    private Integer fdId;
    /**
     * 对应会员ID
     */
    private Integer memberId;

    /**
     * 会员手机号
     */
    private String memberMobile;

    /**
     * 姓名
     */
    private String memberNm;
    /**
     * 性别 1：男 2：女
     */
    private String sex;
    /**
     * 邮箱
     */
    private String email;
    /**
     * 职业
     */
    private String memberJob;
    /**
     * 行业
     */
    private String memberTrade;

    /**
     * 毕业院校
     */
    private String memberGraduated;
    /**
     * 公司名称
     */
    private String memberCompany;

    /**
     * 公司ID
     */
    private Integer companyId;
    /**
     * 是否离职
     */
    private Boolean dimission;
    /**
     * 入职时间
     */
    private String inTime;
    /**
     * 离职时间
     */
    private String outTime;

    private String deptNm;

    public Integer getFdId() {
        return fdId;
    }

    public void setFdId(Integer fdId) {
        this.fdId = fdId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberJob() {
        return memberJob;
    }

    public void setMemberJob(String memberJob) {
        this.memberJob = memberJob;
    }

    public String getMemberTrade() {
        return memberTrade;
    }

    public void setMemberTrade(String memberTrade) {
        this.memberTrade = memberTrade;
    }

    public String getMemberMobile() {
        return memberMobile;
    }

    public void setMemberMobile(String memberMobile) {
        this.memberMobile = memberMobile;
    }

    public String getMemberGraduated() {
        return memberGraduated;
    }

    public void setMemberGraduated(String memberGraduated) {
        this.memberGraduated = memberGraduated;
    }

    public String getMemberCompany() {
        return memberCompany;
    }

    public void setMemberCompany(String memberCompany) {
        this.memberCompany = memberCompany;
    }

    public Integer getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Integer companyId) {
        this.companyId = companyId;
    }

    public Boolean getDimission() {
        return dimission;
    }

    public void setDimission(Boolean dimission) {
        this.dimission = dimission;
    }

    public String getInTime() {
        return inTime;
    }

    public void setInTime(String inTime) {
        this.inTime = inTime;
    }

    public String getOutTime() {
        return outTime;
    }

    public void setOutTime(String outTime) {
        this.outTime = outTime;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
}
