package com.qweib.cloud.repository.sms;

import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.sms.SmsPayRecord;
import com.qweibframework.commons.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 15:26
 */
@Repository
public class SmsPayRecordDao {

    private static final String TABLE_NAME = "sms_pay_record";

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public Integer save(String database, SmsPayRecord record) {
        Map<String, Object> valueMap = Maps.newHashMap();

        valueMap.put("type", record.getType());
        valueMap.put("total", record.getTotal());
        valueMap.put("created_time", DateUtils.getTimestamp());

        return this.daoTemplate.saveEntityAndGetKey(database, TABLE_NAME, valueMap);
    }
}
