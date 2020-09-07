package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/28 - 15:11
 */
@Data
public class SmsMessage {

    private int code;
    private String msg;
    private SmsResult result;

    public boolean isSuccess() {
        return this.code == 0;
    }
}
