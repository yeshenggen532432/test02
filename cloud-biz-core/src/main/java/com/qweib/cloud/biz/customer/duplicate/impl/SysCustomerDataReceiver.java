package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description: 获取客户管理数据
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 10:12
 */
@Service
public class SysCustomerDataReceiver extends AbstractDataReceiver {

    @Override
    public List<CustomerDTO> getDatas(String database, String customerName) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.id,a.kh_nm")
                .append(" FROM `").append(database).append("`.`sys_customer` a")
                .append(" WHERE a.kh_nm LIKE ?");

        return jdbcTemplate.query(sql.toString(), new Object[]{customerName + "%"}, (rs, rowNum) ->
                new CustomerDTO(rs.getInt("id"), CustomerTypeEnum.SysCustomer, rs.getString("kh_nm")));
    }
}
