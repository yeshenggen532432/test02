package com.qweib.cloud.core.domain.vo;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 订单审核状态
 */
public enum OrderZt {

    //订单审核状态（审核，未审核，已作废) 使用中文存库
    audited("审核"),
    notAudited("未审核"),
    abandoned("已作废");

    private String code;

    private OrderZt(String code) {
        this.code = code;
    }

    public String getCode() {
        return this.code;
    }

    public static Map<String, String> getOrderZtMap() {
        Map<String, String> map = new LinkedHashMap<>();
        map.put(OrderZt.audited.getCode(), OrderZt.audited.getCode());
        map.put(OrderZt.notAudited.getCode(), OrderZt.notAudited.getCode());
        map.put(OrderZt.abandoned.getCode(), OrderZt.abandoned.getCode());
        return map;
    }
}
