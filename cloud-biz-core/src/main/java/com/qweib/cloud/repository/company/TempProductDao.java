package com.qweib.cloud.repository.company;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.product.*;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import com.qweibframework.commons.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 12:10
 */
@Repository
public class TempProductDao extends BaseDao {

    private static final String TABLE_NAME = "product_temp";

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public Integer save(TempProductSave input, String database) {
        Map<String, Object> valueMap = Maps.newHashMap();
        setFieldValues(input, valueMap);
        valueMap.put("record_id", input.getRecordId());

        return this.daoTemplate.saveEntityAndGetKey(database, TABLE_NAME, valueMap);
    }

    public Optional<TempProductBaseDTO> existProduct(Integer recordId, String productName, String database) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("SELECT id,product_name FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` WHERE record_id=? AND product_name=?");
        List<TempProductBaseDTO> list = this.daoTemplate.query(sql.toString(), new Object[]{recordId, productName}, new ProductBaseRowMapper());
        return Collections3.isNotEmpty(list) ? Optional.of(list.get(0)) : Optional.empty();
    }

    public Page<TempProductDTO> page(TempProductQuery query, PageRequest pageRequest, String database) {
        int totalRow = countProduct(query, database);
        if (totalRow <= pageRequest.getOffset()) {
            return new Page<>(Lists.newArrayListWithCapacity(0), totalRow, pageRequest);
        }

        StringBuilder sql = new StringBuilder("SELECT a.*,b.member_nm AS 'updated_name' FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` a")
                .append(" LEFT JOIN `").append(database).append("`.`sys_mem` b ON a.updated_by = b.member_id");

        List<Object> values = Lists.newArrayList();
        sql.append(makeWhereSegment(query, values));
        sql.append(" ORDER BY id ASC LIMIT ?,?");
        values.add(pageRequest.getOffset());
        values.add(pageRequest.getSize());

        List<TempProductDTO> list = this.daoTemplate.query(sql.toString(), values.toArray(new Object[values.size()]),
                new TempProductRowMapper());

        return new Page<>(list, totalRow, pageRequest);
    }

    public TempProductDTO get(Integer id, String database) {
        StringBuilder sql = new StringBuilder("SELECT a.*,b.member_nm AS 'updated_name' FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` a")
                .append(" LEFT JOIN `").append(database).append("`.`sys_mem` b ON a.updated_by = b.member_id");
        sql.append(" WHERE id=?");
        List<TempProductDTO> list = this.daoTemplate.query(sql.toString(), new Object[]{id}, new TempProductRowMapper());

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public List<TempProductBaseDTO> getAllBaseProduct(Integer recordId, String database) {
        StringBuilder sql = new StringBuilder("SELECT a.id,a.product_name FROM `").append(database)
                .append("`.`").append(TABLE_NAME).append("` a WHERE a.record_id=? ORDER BY a.id ASC");

        return this.daoTemplate.query(sql.toString(), new Object[]{recordId}, new ProductBaseRowMapper());
    }

    private static class ProductBaseRowMapper implements RowMapper<TempProductBaseDTO> {
        @Override
        public TempProductBaseDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            TempProductBaseDTO baseDTO = new TempProductBaseDTO();
            baseDTO.setId(rs.getInt("id"));
            baseDTO.setProductName(rs.getString("product_name"));
            return baseDTO;
        }
    }

    public int update(TempProductUpdate input, String database) {
        Map<String, Object> fieldMap = Maps.newHashMap();
        setFieldValues(input, fieldMap);

        Map<String, Object> whereMap = Maps.newHashMap();
        whereMap.put("id", input.getId());

        return this.daoTemplate.updateEntity(database, TABLE_NAME, fieldMap, whereMap);
    }

    public void delete(List<Integer> ids, String database) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("DELETE FROM `").append(database).append("`.`").append(TABLE_NAME).append("` WHERE id=?");
        this.daoTemplate.deletes(sql.toString(), ids.toArray(new Integer[ids.size()]));
    }

    private void setFieldValues(TempProductModel input, Map<String, Object> fieldMap) {
        fieldMap.put("category_name", input.getCategoryName());
        fieldMap.put("product_code", input.getProductCode());
        fieldMap.put("product_name", input.getProductName());

        fieldMap.put("big_unit_name", input.getBigUnitName());
        fieldMap.put("big_unit_spec", input.getBigUnitSpec());
        fieldMap.put("big_unit_scale", input.getBigUnitScale());
        fieldMap.put("big_bar_code", input.getBigBarCode());
        fieldMap.put("big_purchase_price", input.getBigPurchasePrice());
        fieldMap.put("big_sale_price", input.getBigSalePrice());

        fieldMap.put("small_unit_name", input.getSmallUnitName());
        fieldMap.put("small_unit_spec", input.getSmallUnitSpec());
        fieldMap.put("small_unit_scale", input.getSmallUnitScale());
        fieldMap.put("small_bar_code", input.getSmallBarCode());
        fieldMap.put("small_sale_price", input.getSmallSalePrice());

        fieldMap.put("expiration_date", input.getExpirationDate());
        fieldMap.put("provider_name", input.getProviderName());

        fieldMap.put("remark", input.getRemark());

        fieldMap.put("updated_by", input.getUpdatedBy());
        fieldMap.put("updated_time", DateUtils.getTimestamp());
    }

    public int countProduct(TempProductQuery query, String database) {
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

    private String makeWhereSegment(TempProductQuery query, List<Object> values) {
        StringBuilder sql = new StringBuilder();

        int index = 0;
        sql.append(getWhereLogical(index++));
        sql.append("a.record_id=?");
        values.add(query.getRecordId());
        if (StringUtils.isNotBlank(query.getProductName())) {
            sql.append(getWhereLogical(index++));
            sql.append("a.product_name=?");
            values.add(query.getProductName());
        }

        return sql.toString();
    }

    private static class TempProductRowMapper implements RowMapper<TempProductDTO> {

        @Override
        public TempProductDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            TempProductDTO productDTO = new TempProductDTO();

            productDTO.setId(rs.getInt("id"));
            productDTO.setCategoryName(rs.getString("category_name"));
            productDTO.setProductCode(rs.getString("product_code"));
            productDTO.setProductName(rs.getString("product_name"));

            productDTO.setBigUnitName(rs.getString("big_unit_name"));
            productDTO.setBigUnitSpec(rs.getString("big_unit_spec"));
            productDTO.setBigUnitScale(rs.getDouble("big_unit_scale"));
            productDTO.setBigBarCode(rs.getString("big_bar_code"));
            productDTO.setBigPurchasePrice(rs.getDouble("big_purchase_price"));
            productDTO.setBigSalePrice(rs.getDouble("big_sale_price"));

            productDTO.setSmallUnitName(rs.getString("small_unit_name"));
            productDTO.setSmallUnitSpec(rs.getString("small_unit_spec"));
            productDTO.setSmallUnitScale(rs.getDouble("small_unit_scale"));
            productDTO.setSmallBarCode(rs.getString("small_bar_code"));
            productDTO.setSmallSalePrice(rs.getDouble("small_sale_price"));

            productDTO.setExpirationDate(rs.getString("expiration_date"));
            productDTO.setProviderName(rs.getString("provider_name"));
            productDTO.setRemark(rs.getString("remark"));

            productDTO.setUpdatedName(rs.getString("updated_name"));

            return productDTO;
        }
    }
}
