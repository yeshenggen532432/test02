package com.qweib.cloud.core.domain.sms;

import lombok.Data;

import java.util.Date;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 15:36
 */
@Data
public class SmsDeductRecord {

    private Integer id;
    /**
     * 扣除数量
     */
    private Integer total;
    private Date cratedTime;
}
