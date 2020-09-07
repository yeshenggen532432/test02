package com.qweib.cloud.biz.salesman.pojo.input;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import com.google.gson.annotations.SerializedName;

import java.util.EnumSet;
import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 16:37
 */
public enum PushMoneyTypeEnum {

    @SerializedName("1")
    QUANTITY(1, "YWTC00", "业务提成按数量"),
    @SerializedName("2")
    SALE_AMOUNT(2, "YWTC01", "业务提成按收入"),
    @SerializedName("3")
    GROSS_MARGIN(3, "YWTC02", "业务提成按毛利");

    private final int type;
    private final String code;
    private final String message;

    PushMoneyTypeEnum(int type, String code, String message) {
        this.type = type;
        this.code = code;
        this.message = message;
    }

    @JsonValue
    public int getType() {
        return type;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    @JsonCreator
    public static PushMoneyTypeEnum getByType(Integer type) {
        if (type == null) {
            return PushMoneyTypeEnum.QUANTITY;
        }

        return EnumSet.allOf(PushMoneyTypeEnum.class)
                .stream()
                .filter(e -> Objects.equals(e.getType(), type))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("PushMoneyTypeEnum Unknown type:" + type));
    }
}
