package com.qweib.cloud.biz.customer.duplicate.dto;

import com.qweib.commons.StringUtils;

import java.util.EnumSet;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 11:12
 */
public enum CustomerTypeEnum {

    SysCustomer("sys_customer", "系统客户"),
    StkProvider("stk_provider", "供应商"),
    FinUnit("fin_unit", "往来单位"),
    SysMem("sys_mem", "员工管理"),
    ShopMember("shop_member", "会员管理");

    private final String type;
    private final String message;

    CustomerTypeEnum(String type, String message) {
        this.type = type;
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public String getMessage() {
        return message;
    }

    public static CustomerTypeEnum getByType(String type) {
        if (StringUtils.isBlank(type)) {
            return null;
        }

        return EnumSet.allOf(CustomerTypeEnum.class)
                .stream()
                .filter(e -> e.getType().equals(type))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("CustomerTypeEnum Unknown type:" + type));

    }
}
