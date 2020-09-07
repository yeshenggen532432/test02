package com.qweib.cloud.core.domain.approval.dto;

import java.sql.Timestamp;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 16:01
 */
public class TransOrderConfigDetailDTO extends TransOrderConfigDTO {

    private String createdName;
    private Timestamp createdTime;

    public String getCreatedName() {
        return createdName;
    }

    public void setCreatedName(String createdName) {
        this.createdName = createdName;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }
}
