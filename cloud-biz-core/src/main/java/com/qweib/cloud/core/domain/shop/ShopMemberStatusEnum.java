package com.qweib.cloud.core.domain.shop;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import java.util.EnumSet;
import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 11:27
 */
public enum ShopMemberStatusEnum {

    CANCEL_ATTENTION(-4, "取消关注"),
    APPLYING(-1, "申请中"),
    DISABLED(0, "不启用"),
    ENABLED(1, "已启用");

    private final int state;
    private final String message;

    ShopMemberStatusEnum(int state, String message) {
        this.state = state;
        this.message = message;
    }

    @JsonValue
    public int getState() {
        return state;
    }

    public String getMessage() {
        return message;
    }

    @JsonCreator
    public static ShopMemberStatusEnum getByState(Integer state) {
        if (state == null) {
            return null;
        }

        return EnumSet.allOf(ShopMemberStatusEnum.class)
                .stream()
                .filter(e -> Objects.equals(state, e.getState()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown shop member state:" + state));
    }
}
