package com.qweib.cloud.core.domain.approval;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 14:26
 */
public enum StatusEnum {

    UNCONFIGURED("0", "未配置"),
    CONFIGURED("1", "已配置"),
    DISABLED("2", "已禁用");

    private final String status;
    private final String message;

    StatusEnum(String status, String message) {
        this.status = status;
        this.message = message;
    }

    @JsonValue
    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }

    @JsonCreator
    public static StatusEnum getByStatus(String status) {
        for (StatusEnum statusEnum : StatusEnum.values()) {
            if (statusEnum.getStatus().equals(status)) {
                return statusEnum;
            }
        }

        throw new IllegalArgumentException("unknown status:" + status);
    }
}
