package com.qweib.cloud.core.domain;

public class SysMemDTO {


    /**
     * 主键自增id
     */
    private Integer memberId;
    /**
     * 成员姓名
     */
    private String memberNm;
    /**
     * 头像
     */
    private String memberHead;
    /**
     * 首字母
     */
    private String firstChar;

    private String memberMobile;//手机号码

    private String datasource;

    private String remindFlag;//查询权成员时是否屏蔽消息字段

    private Integer cy;//判断是否是常用联系人
    private String role;//成员角色

    /**
     * 所属分组ID
     */
    private Integer branchId;

    public Integer getBranchId() {
        return branchId;
    }

    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getCy() {
        return cy;
    }

    public void setCy(Integer cy) {
        this.cy = cy;
    }

    public String getMemberMobile() {
        return memberMobile;
    }

    public void setMemberMobile(String memberMobile) {
        this.memberMobile = memberMobile;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public String getFirstChar() {
        return firstChar;
    }

    public void setFirstChar(String firstChar) {
        this.firstChar = firstChar;
    }

    public String getDatasource() {
        return datasource;
    }

    public void setDatasource(String datasource) {
        this.datasource = datasource;
    }

    public String getRemindFlag() {
        return remindFlag;
    }

    public void setRemindFlag(String remindFlag) {
        this.remindFlag = remindFlag;
    }

    public SysMemDTO(Integer memberId, String memberNm) {
        this.memberId = memberId;
        this.memberNm = memberNm;
    }

    public SysMemDTO() {
        super();
        // TODO Auto-generated constructor stub
    }


}
