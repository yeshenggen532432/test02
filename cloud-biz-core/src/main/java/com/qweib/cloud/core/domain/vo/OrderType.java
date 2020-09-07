package com.qweib.cloud.core.domain.vo;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author zzx
 * @version 1.1 2020/4/24
 * @description:订单类型
 */
public enum OrderType {
    //类型：0普通订单,1:秒杀 2:拼团  4:组团,9餐饮订单
    general(0),
    flash(1), //
    tour(2),
    headToru(4),
    dining(9),
    member(4),
    customer(2),
    staff(3);

    private int code;

    private OrderType(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }

    public static Map<Integer, String> getOrderTypeMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        map.put(OrderType.general.getCode(), "普通订单");
        map.put(OrderType.flash.getCode(), "秒杀订单");
        map.put(OrderType.tour.getCode(), "拼团订单");
        map.put(OrderType.headToru.getCode(), "组团订单");
        map.put(OrderType.dining.getCode(), "餐饮订单");
        return map;
    }
}
