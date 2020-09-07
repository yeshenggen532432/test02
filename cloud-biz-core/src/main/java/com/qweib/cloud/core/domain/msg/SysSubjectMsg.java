package com.qweib.cloud.core.domain.msg;

import lombok.Data;

/**
 * 订阅消息主体内容表
 */
@Data
public class SysSubjectMsg {
    private Integer id;
    private String name;//名称
    private String sign;//获取标记
    private String pushMode;//推送模块（6系统通知，7计划通知，8日志通知，9商城通知）CnlifeConstants.MODE9
    private String pushType;//消息类型100以上商城订单，客户端做出对应处理SysChatMsg.tp
    private String pushMsg;//推送内容
    private String mobileMsg;//手机内容
    private String emailMsg;//邮箱内容
    private String wxMsg;//微信通知内容
    private String msgDesc;//消息描述
    private Integer state;//状态：0未启用，1启用
    private Integer type;//类型：0卖家，1买家，3.....

}
