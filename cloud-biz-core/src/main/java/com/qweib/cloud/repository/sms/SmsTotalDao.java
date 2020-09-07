package com.qweib.cloud.repository.sms;

import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.sms.SmsTotal;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 14:54
 */
@Repository
public class SmsTotalDao {

    private static final int SMS_TOTAL_KEY = 1;
    private static final String TABLE_NAME = "sms_total";

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public SmsTotal get(String database) {
        List<SmsTotal> list = this.daoTemplate.query("SELECT * FROM " + database + "." + TABLE_NAME + " WHERE id = ?", new Object[]{SMS_TOTAL_KEY},
                new SmsTotalRowMapper());

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public void save(String database, Integer total) {
        Map<String, Object> valueMap = Maps.newHashMap();
        valueMap.put("id", SMS_TOTAL_KEY);
        valueMap.put("total", total);
        valueMap.put("version", 1);
        this.daoTemplate.saveEntityAndGetKey(database, TABLE_NAME, valueMap);
    }

    public void update(String database, Integer total, Integer version) {
        int count = this.daoTemplate.update("UPDATE " + database + "." + TABLE_NAME + " SET total = ?, version = ? WHERE id = ? AND version = ?",
                new Object[]{total, version + 1, SMS_TOTAL_KEY, version});

        if (count < 1) {
            throw new BizException("业务繁忙，请稍后重试");
        }
    }

    private static class SmsTotalRowMapper implements RowMapper<SmsTotal> {

        @Override
        public SmsTotal mapRow(ResultSet rs, int rowNum) throws SQLException {
            SmsTotal entity = new SmsTotal();
            entity.setId(rs.getInt("id"));
            entity.setTotal(rs.getInt("total"));
            return entity;
        }
    }
}
