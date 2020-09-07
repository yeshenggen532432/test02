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
public class TransOrderConfigUpdate {

    private String id;
    private TransferOrderEnum transferOrder;
    private String accountSubjectType;
    private String accountSubjectItem;
    private String paymentAccount;
    // 操作人员
    private Integer operatorId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public TransferOrderEnum getTransferOrder() {
        return transferOrder;
    }

    public void setTransferOrder(TransferOrderEnum transferOrder) {
        this.transferOrder = transferOrder;
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
        if (this.transferOrder == null) {
            throw new BizException("转单类型不能为空");
        }
        if (StringUtils.isBlank(this.accountSubjectType) || StringUtils.isBlank(this.accountSubjectItem)) {
            throw new BizException("科目选项不能为空");
        }
    }
}
