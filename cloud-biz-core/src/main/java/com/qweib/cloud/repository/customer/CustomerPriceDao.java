package com.qweib.cloud.repository.customer;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModelVo;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerPrice;
import com.qweib.cloud.core.domain.customer.CustomerPriceData;
import com.qweib.cloud.core.domain.customer.CustomerPriceQuery;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.WareSqlUtil;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
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
 * Created on 2019/4/23 - 14:32
 */
@Repository
public class CustomerPriceDao {

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public SysCustomerPrice getCustomerPrice(CustomerPriceQuery query) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM ").append(query.getDatabase()).append(".sys_customer_price")
                .append(" WHERE customer_id=? AND ware_id=?");

        List<SysCustomerPrice> list = this.daoTemplate.query(sql.toString(), new Object[]{query.getCustomerId(), query.getProductId()},
                new CustomerPriceRowMapper());

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    private static class CustomerPriceRowMapper implements RowMapper<SysCustomerPrice> {

        @Override
        public SysCustomerPrice mapRow(ResultSet rs, int rowNum) throws SQLException {
            SysCustomerPrice customerPrice = new SysCustomerPrice();
            customerPrice.setId(rs.getInt("id"));
            customerPrice.setWareId(rs.getInt("ware_id"));
            customerPrice.setCustomerId(rs.getInt("customer_id"));
            customerPrice.setSaleAmt(rs.getBigDecimal("sale_amt"));
            customerPrice.setLsPrice(rs.getDouble("ls_price"));
            customerPrice.setFxPrice(rs.getDouble("fx_price"));
            customerPrice.setCxPrice(rs.getDouble("cx_price"));
            customerPrice.setSunitPrice(rs.getDouble("sunit_price"));
            customerPrice.setMinLsPrice(rs.getDouble("min_ls_price"));
            customerPrice.setMinFxPrice(rs.getDouble("min_fx_price"));
            customerPrice.setMinCxPrice(rs.getDouble("min_cx_price"));

            return customerPrice;
        }
    }

    public int updateCustomerPrice(String database, Integer id, CustomerPriceData priceData) {
        Map<String, Object> properties = Maps.newHashMap();
        if (priceData.getBigUnitTradePrice() != null) {
            properties.put("sale_amt", priceData.getBigUnitTradePrice());
        }
        if (priceData.getSmallUnitTradePrice() != null) {
            properties.put("sunit_price", priceData.getSmallUnitTradePrice());
        }

        Map<String, Object> whereArgs = Maps.newHashMap();
        whereArgs.put("id", id);

        return this.daoTemplate.updateProperties(database, "sys_customer_price", properties, whereArgs);
    }

    /**
     * 保存客户价格
     *
     * @param database
     * @param priceData
     * @return
     */
    public Integer saveCustomerPrice(String database, CustomerPriceData priceData) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("INSERT INTO ").append(database).append(".sys_customer_price (ware_id,customer_id,sale_amt,sunit_price)")
                .append(" VALUES ")
                .append("(").append(StringUtils.repeat("?", ",", 4)).append(");");

        List<Object> values = Lists.newArrayList();
        values.add(priceData.getProductId());
        values.add(priceData.getCustomerId());
        values.add(StringUtils.toDouble(priceData.getBigUnitTradePrice()));
        values.add(StringUtils.toDouble(priceData.getSmallUnitTradePrice()));

        return Optional.ofNullable(this.daoTemplate.saveEntityAndGetKey(sql.toString(), values.toArray(new Object[values.size()])))
                .orElseThrow(() -> new BizException("保存客户价格出错"));
    }


    /**
     * 获取客户价格列表
     *
     * @param database
     * @param vo
     * @return
     */
    public List<CustomerPriceModelVo> queryCustomerPriceList(String database, CustomerPriceModelVo vo) {
        StringBuffer sql = new StringBuffer();
        sql.append("select sc.kh_nm,sc.address,scp.sale_amt,scp.sunit_price,sw.waretype,sw.ware_nm,sw.ware_dw,sw.ware_gg,sw.min_unit,sw.min_Ware_Gg,sw.s_Unit,sw.b_Unit,sw.waretype ");
        sql.append(" from " + database + ".sys_customer sc LEFT JOIN " + database + ".sys_customer_price scp on sc.id=scp.customer_id INNER JOIN " + database + ".sys_ware sw on scp.ware_id=sw.ware_id ");
        sql.append(" left join " + database + ".sys_waretype wt on sw.waretype=wt.waretype_id where 1=1 ");
        if (vo != null) {
            if (!StrUtil.isNull(vo.getCustomerName())) {
                sql.append(" and sc.kh_nm like '%" + vo.getCustomerName() + "%'");
            }
            if (!StrUtil.isNull(vo.getProductName())) {
                sql.append(" and sw.ware_nm like '%" + vo.getProductName() + "%'");
            }
            if (null != vo.getWaretype() && vo.getWaretype() != 0) {
                sql.append(" and instr(wt.waretype_path,'-").append(vo.getWaretype()).append("-')>0");
            }
        }
        sql.append(" and " + WareSqlUtil.getCompanyStockWareTypeAppendSql("wt"));//过滤分类

        //sql.append(" and " + WareSqlUtil.getCompanyWareAppendSql("sw", database));
        sql.append(" order by sc.id,sw.ware_nm");
        //sql.append(" limit 0,1000");
        List<CustomerPriceModelVo> list = this.daoTemplate.query(sql.toString(), new CustomerPriceVoRowMapper());
        return list;
    }


    private static class CustomerPriceVoRowMapper implements RowMapper<CustomerPriceModelVo> {

        @Override
        public CustomerPriceModelVo mapRow(ResultSet rs, int rowNum) throws SQLException {
            CustomerPriceModelVo vo = new CustomerPriceModelVo();
            vo.setCustomerName(rs.getString("kh_nm"));
            //vo.setCustomerAddress(rs.getString("address"));
            vo.setProductName(rs.getString("ware_nm"));
            vo.setBigUnitName(rs.getString("ware_dw"));
            vo.setBigUnitSpec(rs.getString("ware_gg"));
            vo.setBigUnitTradePrice(rs.getString("sale_amt"));

            vo.setSmallUnitName(rs.getString("min_unit"));
            vo.setSmallUnitSpec(rs.getString("min_Ware_Gg"));
            vo.setSmallUnitTradePrice(rs.getString("sunit_price"));

            vo.setSmallUnitScale(rs.getDouble("s_Unit"));
            vo.setbUnit(rs.getDouble("b_Unit"));
            vo.setWaretype(rs.getInt("waretype"));
            return vo;
        }
    }
}
