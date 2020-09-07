package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class BscCheck {
    public static final String IS_APPROVAL = "1";//是最终审核人

    private Integer id;//自增id
    private String auditNo;//申请编号
    private Integer memberId;//审核人id
    private String checkTime;//审核时间
    private String dsc;//描述
    private String checkTp;//1发起申请 2 同意 3 拒绝 4 转发 5撤销  6退回到上个（过滤转交人）
    private String isCheck;//0 未走到该流程(默认) 1 走到该流程 2 完成流程
    private String checkNum;//流程编号（撤销时100）
    // private String auditTp;//1 请假 2 报销 3 出差 4 物品领用5 通用审批',
    private String isApprover;//1最后审批人
    private String isZr;//1转交

    //不在数据库
    private String memberNm;//成员名称
    private String memberHead;//成员头像


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAuditNo() {
        return auditNo;
    }

    public void setAuditNo(String auditNo) {
        this.auditNo = auditNo;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(String checkTime) {
        this.checkTime = checkTime;
    }

    public String getDsc() {
        return dsc;
    }

    public void setDsc(String dsc) {
        this.dsc = dsc;
    }

    public String getCheckTp() {
        return checkTp;
    }

    public void setCheckTp(String checkTp) {
        this.checkTp = checkTp;
    }

    public String getIsCheck() {
        return isCheck;
    }

    public void setIsCheck(String isCheck) {
        this.isCheck = isCheck;
    }

    public String getCheckNum() {
        return checkNum;
    }

    public void setCheckNum(String checkNum) {
        this.checkNum = checkNum;
    }

    public String getIsApprover() {
        return isApprover;
    }

    public void setIsApprover(String isApprover) {
        this.isApprover = isApprover;
    }

    public String getIsZr() {
        return isZr;
    }

    public void setIsZr(String isZr) {
        this.isZr = isZr;
    }

    public BscCheck(String auditNo, Integer memberId, String checkTime,
                    String checkTp, String isCheck, String checkNum) {
        super();
        this.auditNo = auditNo;
        this.memberId = memberId;
        this.checkTime = checkTime;
        this.checkTp = checkTp;
        this.isCheck = isCheck;
        this.checkNum = checkNum;
    }

    public BscCheck() {
        super();
    }


}
