package com.qweib.cloud.biz.customer.duplicate.impl;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description: 获取会员管理数据
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 14:57
 */
@Service
public class ShopMemberDataReceiver extends AbstractDataReceiver {

    @Override
    public List<CustomerDTO> getDatas(String database, String customerName) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.id,a.name")
                .append(" FROM `").append(database).append("`.`shop_member` a")
                .append(" WHERE a.name LIKE ? AND a.is_del = 0");
        return jdbcTemplate.query(sql.toString(), new Object[]{customerName + "%"}, (rs, rowNum) ->
                new CustomerDTO(rs.getInt("id"), CustomerTypeEnum.ShopMember, rs.getString("name")));
    }
}
