package com.qweib.cloud.core.domain.sms;

import lombok.Data;

import java.util.Date;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 14:51
 */
@Data
public class SmsPayRecord {

    private Integer id;
    /**
     * 1：平台充值
     */
    private Integer type;
    /**
     * 充值数量
     */
    private Integer total;
    private Date cratedTime;
}
