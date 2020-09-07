package com.qweib.cloud.core.domain.vo;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 订单会员类型，（业务员或客户）
 */
public enum OrderMemberType {

    //类型：0供应商  1员工  2客户 3其他往外  4：会员（商城）
    supplier(0),
    staff(1),
    customer(2),
    otherContacts(3),
    member(4);

    private int code;

    private OrderMemberType(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }

    public static Map<Integer, String> getOrderProTypeMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        map.put(OrderMemberType.supplier.getCode(), "供应商");
        map.put(OrderMemberType.staff.getCode(), "员工");
        map.put(OrderMemberType.customer.getCode(), "客户");
        map.put(OrderMemberType.otherContacts.getCode(), "其他往外");
        map.put(OrderMemberType.member.getCode(), "会员");
        return map;
    }

    public static Map<Integer, String> getOrderEmpTypeMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        map.put(OrderMemberType.supplier.getCode(), "供应商");
        map.put(OrderMemberType.staff.getCode(), "员工");
        map.put(OrderMemberType.customer.getCode(), "客户(负责业务员)");
        map.put(OrderMemberType.otherContacts.getCode(), "其他往外");
        map.put(OrderMemberType.member.getCode(), "会员");
        return map;
    }
}
