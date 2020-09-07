package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description: 获取供应商管理数据
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 12:06
 */
@Service
public class StkProviderDataReceiver extends AbstractDataReceiver {

    @Override
    public List<CustomerDTO> getDatas(String database, String customerName) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.id,a.pro_name")
                .append(" FROM `").append(database).append("`.`stk_provider` a")
                .append(" WHERE a.pro_name LIKE ?");
        return jdbcTemplate.query(sql.toString(), new Object[]{customerName + "%"}, (rs, rowNum) ->
                new CustomerDTO(rs.getInt("id"), CustomerTypeEnum.StkProvider, rs.getString("pro_name")));
    }
}
