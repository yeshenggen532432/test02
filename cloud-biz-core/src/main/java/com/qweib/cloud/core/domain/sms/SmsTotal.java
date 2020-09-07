package com.qweib.cloud.core.domain.sms;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 14:49
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class SmsTotal {

    private Integer id;
    /**
     * 剩余短信条数
     */
    private Integer total;
    private Integer version;
}
