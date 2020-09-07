package com.qweib.cloud.core.domain.approval.dto;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.qweib.cloud.core.domain.approval.ApprovalTypeEnum;
import com.qweib.cloud.core.domain.approval.StatusEnum;
import com.qweib.cloud.service.basedata.common.TransferOrderEnum;

import java.sql.Timestamp;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 15:30
 */
public class TransOrderConfigDTO {

    private String id;
    private String no;
    private String approvalName;
    private ApprovalTypeEnum approvalType;
    private String approvalTypeLabel;
    private TransferOrderEnum transferOrder;
    private String transferOrderLabel;
    private StatusEnum status;
    private String statusLabel;
    private Boolean systemApproval;
    private String approvalId;
    private Integer modelId;//模板id
    private String accountSubjectType;
    private String accountSubjectItem;
    private String subjectTypeLabel;
    private String paymentAccount;
    private String updatedName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Timestamp updatedTime;
    private Integer isNormal;//是否预设默认的科目：0.否；1.是

    public Integer getIsNormal() {
        return isNormal;
    }

    public void setIsNormal(Integer isNormal) {
        this.isNormal = isNormal;
    }

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

    public String getApprovalName() {
        return approvalName;
    }

    public void setApprovalName(String approvalName) {
        this.approvalName = approvalName;
    }

    public ApprovalTypeEnum getApprovalType() {
        return approvalType;
    }

    public void setApprovalType(ApprovalTypeEnum approvalType) {
        this.approvalType = approvalType;
    }

    public String getApprovalTypeLabel() {
        return approvalTypeLabel;
    }

    public void setApprovalTypeLabel(String approvalTypeLabel) {
        this.approvalTypeLabel = approvalTypeLabel;
    }

    public TransferOrderEnum getTransferOrder() {
        return transferOrder;
    }

    public void setTransferOrder(TransferOrderEnum transferOrder) {
        this.transferOrder = transferOrder;
    }

    public String getTransferOrderLabel() {
        return transferOrderLabel;
    }

    public void setTransferOrderLabel(String transferOrderLabel) {
        this.transferOrderLabel = transferOrderLabel;
    }

    public StatusEnum getStatus() {
        return status;
    }

    public void setStatus(StatusEnum status) {
        this.status = status;
    }

    public String getStatusLabel() {
        return statusLabel;
    }

    public void setStatusLabel(String statusLabel) {
        this.statusLabel = statusLabel;
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

    public String getSubjectTypeLabel() {
        return subjectTypeLabel;
    }

    public void setSubjectTypeLabel(String subjectTypeLabel) {
        this.subjectTypeLabel = subjectTypeLabel;
    }

    public String getPaymentAccount() {
        return paymentAccount;
    }

    public void setPaymentAccount(String paymentAccount) {
        this.paymentAccount = paymentAccount;
    }

    public String getUpdatedName() {
        return updatedName;
    }

    public void setUpdatedName(String updatedName) {
        this.updatedName = updatedName;
    }

    public Timestamp getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(Timestamp updatedTime) {
        this.updatedTime = updatedTime;
    }

    public Integer getModelId() {
        return modelId;
    }

    public void setModelId(Integer modelId) {
        this.modelId = modelId;
    }

    public void transEnumLabel() {
        if (this.approvalType != null) {
            if(this.approvalTypeLabel == null){
                this.approvalTypeLabel = this.approvalType.getMessage();
            }
            if (!this.approvalType.equals(ApprovalTypeEnum.CUSTOM)) {
                this.approvalName = this.approvalType.getMessage();
            }
        }
        if (this.transferOrder != null) {
            this.transferOrderLabel = this.transferOrder.getMessage();
        }
        if (this.status != null) {
            this.statusLabel = this.status.getMessage();
        } else {
            this.statusLabel = StatusEnum.UNCONFIGURED.getMessage();
        }
    }
}
