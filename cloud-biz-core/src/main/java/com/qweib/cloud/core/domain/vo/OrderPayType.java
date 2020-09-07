package com.qweib.cloud.core.domain.vo;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 商品订单状态 注:key使用Long页面map必须使用Long才能取得到值
 */
public enum OrderPayType {
    /**
     * <option value="0" <c:if test="${order.payType eq '0'}">selected</c:if> >没有类型</option>
     * <option value="1" <c:if test="${order.payType eq '1'}">selected</c:if>>线下支付</option>
     * <option value="2" <c:if test="${order.payType eq '2'}">selected</c:if>>余额支付</option>
     * <option value="3" <c:if test="${order.payType eq '3'}">selected</c:if>>微信支付</option>
     */
    //当Map中是Integer,String时使用map2[1]或map2[1]或{map2[“1”]}，不可以获取到值，使用map2.1取值会报错。
    // 当Map中的key类型为Long时，可以使用map2.1取值会报错。当Map中的key类型为Long时，可以使用{map2[1]}取到值
    none(0L),
    offline(1L),
    balance(2L),
    weixin(3L),
    alipay(4L);

    private Long code;

    private OrderPayType(Long code) {
        this.code = code;
    }

    public Long getCode() {
        return this.code;
    }

    public static Map<Long, String> getOrderPayTypeMap() {
        Map<Long, String> map = new LinkedHashMap<>();
        map.put(OrderPayType.none.getCode(), "未提交支付");
        map.put(OrderPayType.offline.getCode(), "线下支付");
        map.put(OrderPayType.balance.getCode(), "余额支付");
        map.put(OrderPayType.weixin.getCode(), "微信支付");
        map.put(OrderPayType.alipay.getCode(), "支付宝");
        return map;
    }
}
