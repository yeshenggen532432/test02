package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description: 获取员工管理数据
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 14:34
 */
@Service
public class SysMemDataReceiver extends AbstractDataReceiver {

    @Override
    public List<CustomerDTO> getDatas(String database, String customerName) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.member_id,a.member_nm")
                .append(" FROM `").append(database).append("`.`sys_mem` a")
                .append(" WHERE a.member_nm LIKE ?");
        return jdbcTemplate.query(sql.toString(), new Object[]{customerName + "%"}, (rs, rowNum) ->
                new CustomerDTO(rs.getInt("member_id"), CustomerTypeEnum.SysMem, rs.getString("member_nm")));
    }
}
