package com.qweib.cloud.core.domain.vo;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 订单状态
 */
public enum OrderState {

    //0 取消1,待支付,2已支付待发货,3已发货待收货,4已完成
    cancel(0),
    payNo(1),
    sendWait(2),
    sendRece(3),
    finish(4);

    private int code;

    private OrderState(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }

    public static Map<Integer, String> getOrderStateMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        map.put(OrderState.cancel.getCode(), "已取消");
        map.put(OrderState.payNo.getCode(), "待支付");
        map.put(OrderState.sendWait.getCode(), "待发货");
        map.put(OrderState.sendRece.getCode(), "待收货");
        map.put(OrderState.finish.getCode(), "已完成");
        return map;
    }
}
