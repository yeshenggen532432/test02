package com.qweib.cloud.repository.common;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.common.BillSnapshot;
import com.qweib.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 14:17
 * @description:
 */
@Repository
public class BillSnapshotRepository {
    @Autowired
    private JdbcDaoTemplatePlud daoTemplate;

    public List<BillSnapshot> list(String database, Integer userId, String billType, Integer billId) {
        String sql = "SELECT id,user_id,title,bill_type,bill_id,create_time,update_time from " + database + ".bsc_bill_snapshot s where 1=1";
        List params = Lists.newArrayList();
        if (userId != null) {
            sql += " and s.user_id = ? ";
            params.add(userId);
        }
        if (StringUtils.isNotBlank(billType)) {
            sql += " and s.bill_type = ? ";
            params.add(billType);
        }
        if (billId != null) {
            sql += " and s.bill_id = ? ";
            params.add(billId);
        }
        sql += " order by s.update_time desc";
        return daoTemplate.query(sql, params.toArray(), new BeanPropertyRowMapper<>(BillSnapshot.class));
    }

    public BillSnapshot get(String database, Integer userId, String id) {
        String sql = "SELECT * FROM " + database + ".bsc_bill_snapshot s WHERE s.id = ? AND s.user_id = ? ";
        return daoTemplate.queryForObject(sql, new Object[]{id, userId}, new BeanPropertyRowMapper<>(BillSnapshot.class));
    }

    public int removeSnapshotBefore(String database, Integer userId, long timeBefore) {
        String sql = "DELETE FROM " + database + ".bsc_bill_snapshot WHERE user_id = ? AND update_time <= ?";
        return daoTemplate.update(sql, userId, timeBefore);
    }

    public int save(String database, BillSnapshot snapshot) {
        return daoTemplate.update("INSERT INTO `" + database + "`.`bsc_bill_snapshot` (`id`, `title`, `user_id`, `bill_type`, `bill_id`, `data`, `create_time`, `update_time`) VALUES (?,?,?,?,?,?,?,?)",
                snapshot.getId(), snapshot.getTitle(), snapshot.getUserId(), snapshot.getBillType(), snapshot.getBillId(), snapshot.getData(), snapshot.getCreateTime(), snapshot.getUpdateTime());
    }

    public int update(String database, BillSnapshot snapshot) {
        String sql = "UPDATE " + database + ".bsc_bill_snapshot s SET s.title = ?, s.bill_id = ?, s.data = ?, s.update_time = ? WHERE s.id = ? AND s.user_id = ?";
        return daoTemplate.update(sql, snapshot.getTitle(), snapshot.getBillId(), snapshot.getData(), snapshot.getUpdateTime(), snapshot.getId(), snapshot.getUserId());
    }

    public int removeById(String database, Integer userId, String id) {
        String sql = "DELETE FROM " + database + ".bsc_bill_snapshot WHERE id = ? AND user_id = ?";
        return daoTemplate.update(sql, id, userId);
    }
}
