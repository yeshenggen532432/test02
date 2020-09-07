package com.qweib.cloud.biz.salesman.dao;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.salesman.pojo.dto.BillPriceDTO;
import com.qweib.cloud.biz.salesman.pojo.input.SalesmanPushMoneyQuery;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;

/**
 * Description: 业务员统计 dao
 *
 * @author zeng.gui
 * Created on 2019/7/15 - 17:42
 */
@Repository
public class SalesmanCountDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    private static final String SALE_RETURN_TYPE = "销售退货";

    /**
     * 获取业务员提成原始数据
     *
     * @param database
     * @param query
     * @return
     */
    public List<BillPriceDTO> querySalesmanPushMoney(String database, SalesmanPushMoneyQuery query) {
        StringBuilder sql = new StringBuilder(512);

        sql.append("SELECT ssi.out_qty AS 'quantity', ssi.io_price AS 'unit_price', ssi.ware_id, ssi.bill_name AS 'bill_type', ssi.bill_no, ssi.unit_name")
                .append(", so.emp_id AS 'salesman_id', so.staff AS 'salesman_name', so.cst_id AS 'customer_id', so.kh_nm AS 'customer_name'")
                .append(", c.qdtp_nm AS 'customer_type_name', c.khdj_nm AS 'customer_level_name'")
                .append(", sw.waretype AS 'ware_type_id', sw.ware_nm AS 'ware_name'")
                // 过滤掉商品表提成信息 , sw.tc_amt AS 'tc_quantity', sw.sale_pro_tc AS 'tc_money', sw.sale_gro_tc AS 'tc_gross_margin'
                .append(" FROM `").append(database).append("`.`stk_storage_io` ssi")
                .append(" LEFT JOIN `").append(database).append("`.`stk_out` so ON ssi.bill_id = so.id")
                .append(" LEFT JOIN `").append(database).append("`.`sys_customer` c ON so.cst_id = c.id")
                .append(" LEFT JOIN `").append(database).append("`.`sys_ware` sw ON ssi.ware_id = sw.ware_id");

        if (MathUtils.valid(query.getWareTypeId())) {
            sql.append(" LEFT JOIN `").append(database).append("`.`sys_waretype` swt ON sw.waretype = swt.waretype_id");
        }

        sql.append(" WHERE ")
                .append(" ssi.out_qty <> 0 AND ssi.`status` = 0")
                .append(" AND so.`status` <> 2");

        List<Object> values = Lists.newArrayList();

        sql.append(" AND ssi.io_time > ? AND ssi.io_time < ?");
        values.add(query.getBeginDate());
        values.add(query.getEndDate());

        if (StringUtils.isNotBlank(query.getBillType())) {
            sql.append(" AND ssi.bill_name = ?");
            values.add(query.getBillType());
        } else {
            sql.append(" AND ssi.bill_name IN (").append(StringUtils.repeat("?", ",", 10)).append(")");
            values.addAll(Lists.newArrayList("正常销售", "销售退货", "其他销售", "消费折让", "费用折让", "促销折让", "其它出库", "借出出库", "领用出库", "报损出库"));
        }

        if (MathUtils.valid(query.getWareId())) {
            sql.append(" AND sw.ware_id = ?");
            values.add(query.getWareId());
        } else if (StringUtils.isNotBlank(query.getWareName())) {
            sql.append(" AND sw.ware_nm LIKE ?");
            values.add("%" + query.getWareName() + "%");
        }

        if (MathUtils.valid(query.getCustomerId())) {
            sql.append(" AND so.cst_id = ?");
            values.add(query.getCustomerId());
        } else if (StringUtils.isNotBlank(query.getCustomerName())) {
            sql.append(" AND so.kh_nm LIKE ?");
            values.add("%" + query.getCustomerName() + "%");
        }

        if (MathUtils.valid(query.getSalesmanId())) {
            sql.append(" AND so.emp_id = ?");
            values.add(query.getSalesmanId());
        } else if (StringUtils.isNotBlank(query.getSalesmanName())) {
            sql.append(" AND so.staff LIKE ?");
            values.add("%" + query.getSalesmanName() + "%");
        }

        if (MathUtils.valid(query.getWareTypeId())) {
            sql.append(" AND swt.waretype_path LIKE ?");
            values.add("%-" + query.getWareTypeId() + "-%");
        }

        if (StringUtils.isBlank(query.getBillType()) || Objects.equals(SALE_RETURN_TYPE, query.getBillType())) {
            sql.append(" UNION ALL ");
            sql.append("SELECT ssi.in_qty*(-1) AS 'quantity', ssi.in_price AS 'unit_price', ssi.ware_id, ssi.bill_name AS 'bill_type', ssi.bill_no, ssi.unit_name")
                    .append(", si.emp_id AS 'salesman_id', si.emp_nm AS 'salesman_name', si.pro_id AS 'customer_id', si.pro_name AS 'customer_name'")
                    .append(", c.qdtp_nm AS 'customer_type_name', c.khdj_nm AS 'customer_level_name'")
                    .append(", sw.waretype AS 'ware_type_id', sw.ware_nm AS 'ware_name'")
                    // 过滤掉商品表提成信息 , sw.tc_amt AS 'tc_quantity', sw.sale_pro_tc AS 'tc_money', sw.sale_gro_tc AS 'tc_gross_margin'
                    .append(" FROM `").append(database).append("`.`stk_storage_io` ssi")
                    .append(" LEFT JOIN `").append(database).append("`.`stk_in` si ON ssi.bill_id = si.id")
                    .append(" LEFT JOIN `").append(database).append("`.`sys_customer` c ON si.pro_id = c.id")
                    .append(" LEFT JOIN `").append(database).append("`.`sys_ware` sw ON ssi.ware_id = sw.ware_id");

            if (MathUtils.valid(query.getWareTypeId())) {
                sql.append(" LEFT JOIN `").append(database).append("`.`sys_waretype` swt ON sw.waretype = swt.waretype_id");
            }

            sql.append(" WHERE ")
                    .append(" ssi.bill_name = ? AND ssi.in_qty <> 0 AND ssi.`status` = 0")
                    .append(" AND si.`status` <> 2 AND si.`status` <> -2");
            values.add(SALE_RETURN_TYPE);

            sql.append(" AND ssi.io_time > ? AND ssi.io_time < ?");
            values.add(query.getBeginDate());
            values.add(query.getEndDate());

            if (MathUtils.valid(query.getWareId())) {
                sql.append(" AND sw.ware_id = ?");
                values.add(query.getWareId());
            } else if (StringUtils.isNotBlank(query.getWareName())) {
                sql.append(" AND sw.ware_nm LIKE ?");
                values.add("%" + query.getWareName() + "%");
            }

            if (MathUtils.valid(query.getCustomerId())) {
                sql.append(" AND si.pro_id = ?");
                values.add(query.getCustomerId());
            } else if (StringUtils.isNotBlank(query.getCustomerName())) {
                sql.append(" AND si.pro_name LIKE ?");
                values.add("%" + query.getCustomerName() + "%");
            }

            if (MathUtils.valid(query.getSalesmanId())) {
                sql.append(" AND si.emp_id = ?");
                values.add(query.getSalesmanId());
            } else if (StringUtils.isNotBlank(query.getSalesmanName())) {
                sql.append(" AND si.emp_nm LIKE ?");
                values.add("%" + query.getSalesmanName() + "%");
            }

            if (MathUtils.valid(query.getWareTypeId())) {
                sql.append(" AND swt.waretype_path LIKE ?");
                values.add("%-" + query.getWareTypeId() + "-%");
            }
        }

        return daoTemplate.query(sql.toString(), values.toArray(new Object[values.size()]), new RowMapper<BillPriceDTO>() {
            @Override
            public BillPriceDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
                BillPriceDTO billDTO = new BillPriceDTO();

                billDTO.setWareTypeId(rs.getInt("ware_type_id"));
                billDTO.setWareId(rs.getInt("ware_id"));
                billDTO.setWareName(rs.getString("ware_name"));

                billDTO.setBillNo(rs.getString("bill_no"));
                billDTO.setBillType(rs.getString("bill_type"));
                billDTO.setQuantity(rs.getBigDecimal("quantity"));
                billDTO.setUnitPrice(rs.getBigDecimal("unit_price"));
                billDTO.setUnitName(rs.getString("unit_name"));

                billDTO.setSalesmanId(rs.getInt("salesman_id"));
                billDTO.setSalesmanName(rs.getString("salesman_name"));
                billDTO.setCustomerId(rs.getInt("customer_id"));
                billDTO.setCustomerName(rs.getString("customer_name"));

                billDTO.setCustomerTypeName(rs.getString("customer_type_name"));
                billDTO.setCustomerLevelName(rs.getString("customer_level_name"));

                return billDTO;
            }
        });
    }
}
