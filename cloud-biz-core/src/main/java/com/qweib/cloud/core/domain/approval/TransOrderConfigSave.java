package com.qweib.cloud.core.domain.approval;

import com.qweib.cloud.service.basedata.common.TransferOrderEnum;
import com.qweib.commons.exceptions.BizException;
import org.apache.commons.lang3.StringUtils;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 14:46
 */
public class TransOrderConfigSave {

    private ApprovalTypeEnum approvalType;
    private TransferOrderEnum transferOrder;
    private String approvalId;
    private String accountSubjectType;
    private String accountSubjectItem;
    private String paymentAccount;
    // 操作人员
    private Integer operatorId;

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

    public Integer getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Integer operatorId) {
        this.operatorId = operatorId;
    }

    public void validation() {
        if (this.approvalType == null) {
            throw new BizException("审批类型不能为空");
        }
        if (this.transferOrder == null) {
            throw new BizException("转单类型不能为空");
        }
        if (this.approvalType.equals(ApprovalTypeEnum.CUSTOM) && StringUtils.isBlank(this.approvalId)) {
            throw new BizException("来源审批id不能为空");
        }
        if (StringUtils.isBlank(this.accountSubjectType) || StringUtils.isBlank(this.accountSubjectItem)) {
            throw new BizException("科目选项不能为空");
        }
    }
}
