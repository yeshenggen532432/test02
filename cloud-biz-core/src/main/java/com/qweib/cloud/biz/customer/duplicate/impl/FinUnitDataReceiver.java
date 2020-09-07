package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description: 获取其他往来单位数据
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 14:26
 */
@Service
public class FinUnitDataReceiver extends AbstractDataReceiver {

    @Override
    public List<CustomerDTO> getDatas(String database, String customerName) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.id,a.pro_name")
                .append(" FROM `").append(database).append("`.`fin_unit` a")
                .append(" WHERE a.pro_name LIKE ?");
        return jdbcTemplate.query(sql.toString(), new Object[]{customerName + "%"}, (rs, rowNum) ->
                new CustomerDTO(rs.getInt("id"), CustomerTypeEnum.FinUnit, rs.getString("pro_name")));
    }
}
