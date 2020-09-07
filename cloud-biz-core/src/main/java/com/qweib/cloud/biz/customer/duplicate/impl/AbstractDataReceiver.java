package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.DataReceiver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 14:26
 */
public abstract class AbstractDataReceiver implements DataReceiver {

    @Autowired
    protected JdbcTemplate jdbcTemplate;
}
