package com.qweib.cloud.core.domain.approval;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 11:57
 */
public enum ApprovalTypeEnum {

//    LEAVE("1", "请假", "system_leave"),
    REIMBURSE("2", "报销", "system_reimburse"),
//    BUSINESS_TRIP("3", "出差", "system_business_trip"),
//    ITEM_RECIPIENT("4", "物品领用", "system_item_recipient"),
//    COMMON("5", "通用审批", "system_common"),
    CUSTOM("6", "自定义审批", "");

    private final String type;
    private final String message;
    /**
     * 默认id，因为前面5种在数据库没有保存，为了关联，直接设置默认id
     */
    private final String defaultId;

    ApprovalTypeEnum(String type, String message, String defaultId) {
        this.type = type;
        this.message = message;
        this.defaultId = defaultId;
    }

    @JsonValue
    public String getType() {
        return type;
    }

    public String getMessage() {
        return message;
    }

    public String getDefaultId() {
        return defaultId;
    }

    @JsonCreator
    public static ApprovalTypeEnum getByType(String type) {
        for (ApprovalTypeEnum approvalType : ApprovalTypeEnum.values()) {
            if (approvalType.getType().equals(type)) {
                return approvalType;
            }
        }

        throw new IllegalArgumentException("unknown type:" + type);
    }
}
