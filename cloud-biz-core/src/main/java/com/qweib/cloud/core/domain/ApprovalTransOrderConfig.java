package com.qweib.cloud.core.domain;


import com.qweib.cloud.core.domain.approval.ApprovalTypeEnum;
import com.qweib.cloud.core.domain.approval.StatusEnum;
import com.qweib.cloud.service.basedata.common.TransferOrderEnum;

import java.sql.Timestamp;

/**
 * Description:审批转单配置
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 11:56
 */
public class ApprovalTransOrderConfig {

    private String id;
    private String no;
    private ApprovalTypeEnum approvalType;
    private TransferOrderEnum transferOrder;
    private StatusEnum status;
    private Boolean systemApproval;
    private String approvalId;
    private String accountSubjectType;
    private String accountSubjectItem;
    /**
     * 收款帐户
     */
    private String paymentAccount;
    private Integer createdBy;
    private Timestamp createdTime;
    private Integer updatedBy;
    private Timestamp updatedTime;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public ApprovalTypeEnum getApprovalType() {
        return approvalType;
    }

    public void setApprovalType(ApprovalTypeEnum approvalType) {
        this.approvalType = approvalType;
    }

    public TransferOrderEnum getTransferOrder() {
        return transferOrder;
    }

    public void setTransferOrder(TransferOrderEnum transferOrder) {
        this.transferOrder = transferOrder;
    }

    public StatusEnum getStatus() {
        return status;
    }

    public void setStatus(StatusEnum status) {
        this.status = status;
    }

    public Boolean getSystemApproval() {
        return systemApproval;
    }

    public void setSystemApproval(Boolean systemApproval) {
        this.systemApproval = systemApproval;
    }

    public String getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(String approvalId) {
        this.approvalId = approvalId;
    }

    public String getAccountSubjectType() {
        return accountSubjectType;
    }

    public void setAccountSubjectType(String accountSubjectType) {
        this.accountSubjectType = accountSubjectType;
    }

    public String getAccountSubjectItem() {
        return accountSubjectItem;
    }

    public void setAccountSubjectItem(String accountSubjectItem) {
        this.accountSubjectItem = accountSubjectItem;
    }

    public String getPaymentAccount() {
        return paymentAccount;
    }

    public void setPaymentAccount(String paymentAccount) {
        this.paymentAccount = paymentAccount;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Timestamp getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(Timestamp updatedTime) {
        this.updatedTime = updatedTime;
    }
}
