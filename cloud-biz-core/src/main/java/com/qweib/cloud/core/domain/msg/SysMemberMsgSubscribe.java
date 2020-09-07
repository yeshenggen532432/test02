package com.qweib.cloud.core.domain.msg;

import lombok.Data;

/**
 * 会员消息订阅表
 */
@Data
public class SysMemberMsgSubscribe {
    private Integer id;
    private Integer sysSubjectId;//消息体ID，在主数据中
    private Integer memberId;//订阅会员ID
    private Integer pushNotice;//推送订阅：0否1是
    private Integer mobileNotice;//手机内容订阅：0否1是
    private Integer emailNotice;//邮箱内容 订阅：0否1是
    private Integer wxNotice;//微信通知内容订阅：0否1是

    public SysMemberMsgSubscribe() {

    }

    /**
     * 订阅推送
     * @param memberId
     */
    public SysMemberMsgSubscribe(Integer memberId) {
        this.memberId = memberId;
        this.pushNotice = 1;
        this.mobileNotice = 0;
        this.emailNotice = 0;
        this.wxNotice = 0;
    }
}
