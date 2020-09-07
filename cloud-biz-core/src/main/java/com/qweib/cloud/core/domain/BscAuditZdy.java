package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

//审批自定义
public class BscAuditZdy {
    private Integer id;//自定义id
    private Integer memberId;//用户id
    private String zdyNm;//自定义名称
    private String tp;//1.类型 2.时间 3.详情 4.备注 5.金额 6.对象 7.账户 8.关联单
    private String memIds;//审核人id
    private String isSy;//1私用;2共用
    private String sendIds;//发起人
    private String execIds;//执行人
    private Integer approverId;//审批人
    private Integer modelId;//审批模板id
    private Integer status;//0或空.启用 1.禁用
    private String isMobile;//0或空：已同步 2.
    private Integer sort; //排序
    private Integer isUpdateAudit; //是否可以修改审批人 0:不可以 1：可以（默认）
    private Integer isUpdateApprover; //是否可以修改最终审批人 0:不可修改 0:不可以 1：可以（默认）
    private Long systemId; //平台同步id
    private Integer isNormal; //平台预设默认（0：否 1：是）
    //-------------------------不在数据库------------------
    private List<SysMember> mlist;//用户组
    private List<SysMember> sendList;//用户组
    private List<SysMember> execList;//用户组
    private SysMember approver;//最终审批人
    //审批模板
    private String modelName;//模板名称
    private String detailName;//详情
    private String amountName;//金额
    private String timeName;//时间
    private String typeName;//类型
    private String objectName;//对象
    private String remarkName;//备注
    private Integer accountId;//付款账户id
    private String accountName;//账号

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getIsMobile() {
        return isMobile;
    }

    public void setIsMobile(String isMobile) {
        this.isMobile = isMobile;
    }

    public String getIsSy() {
        return isSy;
    }

    public void setIsSy(String isSy) {
        this.isSy = isSy;
    }

    public String getMemIds() {
        return memIds;
    }

    public void setMemIds(String memIds) {
        this.memIds = memIds;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

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

    public String getZdyNm() {
        return zdyNm;
    }

    public void setZdyNm(String zdyNm) {
        this.zdyNm = zdyNm;
    }

    public Integer getModelId() {
        return modelId;
    }

    public void setModelId(Integer modelId) {
        this.modelId = modelId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysMember> getMlist() {
        return mlist;
    }

    public void setMlist(List<SysMember> mlist) {
        this.mlist = mlist;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysMember> getSendList() {
        return sendList;
    }

    public void setSendList(List<SysMember> sendList) {
        this.sendList = sendList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysMember> getExecList() {
        return execList;
    }

    public void setExecList(List<SysMember> execList) {
        this.execList = execList;
    }

    public String getSendIds() {
        return sendIds;
    }

    public void setSendIds(String sendIds) {
        this.sendIds = sendIds;
    }

    public String getExecIds() {
        return execIds;
    }

    public void setExecIds(String execIds) {
        this.execIds = execIds;
    }

    public Integer getApproverId() {
        return approverId;
    }

    public void setApproverId(Integer approverId) {
        this.approverId = approverId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public SysMember getApprover() {
        return approver;
    }

    public void setApprover(SysMember approver) {
        this.approver = approver;
    }

    public Integer getIsUpdateAudit() {
        return isUpdateAudit;
    }

    public void setIsUpdateAudit(Integer isUpdateAudit) {
        this.isUpdateAudit = isUpdateAudit;
    }

    public Integer getIsUpdateApprover() {
        return isUpdateApprover;
    }

    public void setIsUpdateApprover(Integer isUpdateApprover) {
        this.isUpdateApprover = isUpdateApprover;
    }

    public Long getSystemId() {
        return systemId;
    }

    public void setSystemId(Long systemId) {
        this.systemId = systemId;
    }

    public Integer getIsNormal() {
        return isNormal;
    }

    public void setIsNormal(Integer isNormal) {
        this.isNormal = isNormal;
    }

    //---------------------------不在数据库中-------------------------------------
    @TableAnnotation(insertAble = false, updateAble = false)
    public String getDetailName() {
        return detailName;
    }

    public void setDetailName(String detailName) {
        this.detailName = detailName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getAmountName() {
        return amountName;
    }

    public void setAmountName(String amountName) {
        this.amountName = amountName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getObjectName() {
        return objectName;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getRemarkName() {
        return remarkName;
    }

    public void setRemarkName(String remarkName) {
        this.remarkName = remarkName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getTimeName() {
        return timeName;
    }

    public void setTimeName(String timeName) {
        this.timeName = timeName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getAccountId() {
        return accountId;
    }

    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }
}
