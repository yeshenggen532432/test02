package com.qweib.cloud.biz.system.utils.job;

/**
 * 可订阅的消息标记对应数据库publicplat--sys_subject_msg表
 */
public enum MsgSubjectSignEnum {
    order_pay_success,//订单支付成功
    offline_order_apply,//线下支付订单申请
    add_order_success//下单成功
}
