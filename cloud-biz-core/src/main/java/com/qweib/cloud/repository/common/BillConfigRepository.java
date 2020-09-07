package com.qweib.cloud.repository.common;

import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.settings.bill.BillConfig;
import com.qweib.cloud.core.domain.settings.bill.BillConfigItem;
import com.qweib.cloud.utils.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 单据设置dao
 *
 * @author: jimmy.lin
 * @time: 2019/8/9 18:06
 * @description:
 */
@Repository
public class BillConfigRepository {
    @Autowired
    private JdbcDaoTemplatePlud daoTemplate;

    public BillConfig getByNamespace(String database, String namespace) {
        String sql = "select * from " + database + ".bsc_bill_config c where c.namespace = ? ";
        try {
            return daoTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(BillConfig.class), new Object[]{namespace});
        } catch (DataAccessException e) {
            return null;
        }
    }

    public List<BillConfigItem> listItemsByNamespace(String database, String namespace) {
        String sql = "select i.* from " + database + ".bsc_bill_config_item i left join " + database + ".bsc_bill_config c on i.config_id = c.id where c.namespace = ?";
        return daoTemplate.query(sql, new Object[]{namespace}, new BeanPropertyRowMapper<>(BillConfigItem.class));
    }

    public Integer save(String database, BillConfig setting) {
        return daoTemplate.save(database + ".bsc_bill_config", setting);
    }

    public void saveItems(String database, List<BillConfigItem> items) {
        if (Collections3.isNotEmpty(items)) {
            String table = database + ".bsc_bill_config_item";
            for (BillConfigItem item : items) {
                daoTemplate.save(table, item);
            }
        }
    }

    public void updateItems(String database, List<BillConfigItem> items) {
        if (Collections3.isNotEmpty(items)) {
            String table = database + ".bsc_bill_config_item";
            for (BillConfigItem item : items) {
                Map where = Maps.newHashMap();
                where.put("id", item.getId());
                daoTemplate.updateByObject(table, item, where, "id");
            }
        }
    }

    public void removeItems(String database, Integer configId) {
        String sql = "delete from " + database + ".bsc_bill_config_item where config_id = ?";
        daoTemplate.deletes(sql, configId);
    }

}
