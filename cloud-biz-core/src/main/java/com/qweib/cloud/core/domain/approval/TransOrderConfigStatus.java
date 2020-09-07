package com.qweib.cloud.core.domain.approval;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 14:46
 */
public class TransOrderConfigStatus {

    private String id;
    private StatusEnum status;
    // 操作人员
    private Integer operatorId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public StatusEnum getStatus() {
        return status;
    }

    public void setStatus(StatusEnum status) {
        this.status = status;
    }

    public Integer getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Integer operatorId) {
        this.operatorId = operatorId;
    }
}
