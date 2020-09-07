package com.qweib.cloud.repository.company;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.product.TempProductRecordDTO;
import com.qweib.cloud.core.domain.product.TempProductRecordQuery;
import com.qweib.cloud.core.domain.product.TempProductRecordSave;
import com.qweib.commons.StringUtils;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.DateUtils;
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
 * Created on 2019/5/21 - 14:44
 */
@Repository
public class TempProductRecordDao extends BaseDao {

    private static final String TABLE_NAME = "product_temp_record";

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public Integer save(TempProductRecordSave input, String database) {
        Map<String, Object> valueMap = Maps.newHashMap();
        valueMap.put("record_title", input.getTitle());
        valueMap.put("created_by", input.getCreatedBy());
        valueMap.put("created_time", DateUtils.getTimestamp());

        return this.daoTemplate.saveEntityAndGetKey(database, TABLE_NAME, valueMap);
    }

    public Page<TempProductRecordDTO> page(TempProductRecordQuery query, PageRequest pageRequest, String database) {
        int totalRow = countRecord(query, database);
        if (totalRow <= pageRequest.getOffset()) {
            return new Page<>(Lists.newArrayListWithCapacity(0), totalRow, pageRequest);
        }

        StringBuilder sql = new StringBuilder("SELECT a.*,b.member_nm AS 'created_name' FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` a")
                .append(" LEFT JOIN `").append(database).append("`.`sys_mem` b ON a.created_by = b.member_id");

        List<Object> values = Lists.newArrayList();
        sql.append(makeWhereSegment(query, values));
        sql.append(" ORDER BY id ASC LIMIT ?,?");
        values.add(pageRequest.getOffset());
        values.add(pageRequest.getSize());

        List<TempProductRecordDTO> list = this.daoTemplate.query(sql.toString(), values.toArray(new Object[values.size()]),
                new TempProductRecordRowMapper());

        return new Page<>(list, totalRow, pageRequest);
    }

    private static class TempProductRecordRowMapper implements RowMapper<TempProductRecordDTO> {

        @Override
        public TempProductRecordDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            TempProductRecordDTO recordDTO = new TempProductRecordDTO();

            recordDTO.setId(rs.getInt("id"));
            recordDTO.setTitle(rs.getString("record_title"));
            recordDTO.setCreatedName(rs.getString("created_name"));
            recordDTO.setCreatedTime(rs.getDate("created_time"));

            return recordDTO;
        }
    }

    private String makeWhereSegment(TempProductRecordQuery query, List<Object> values) {
        StringBuilder sql = new StringBuilder();

        int index = 0;
        if (StringUtils.isNotBlank(query.getTitle())) {
            sql.append(getWhereLogical(index++));
            sql.append("a.record_title=?");
            values.add(query.getTitle());
        }

        return sql.toString();
    }

    public int countRecord(TempProductRecordQuery query, String database) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(a.id) FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` a");

        List<Object> values = Lists.newArrayList();
        sql.append(makeWhereSegment(query, values));

        if (Collections3.isNotEmpty(values)) {
            return this.daoTemplate.queryForObject(sql.toString(), values.toArray(new Object[values.size()]), Integer.class);
        } else {
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        }
    }
}
