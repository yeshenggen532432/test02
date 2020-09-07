package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysFixedCustomerPrice;
import com.qweib.cloud.core.domain.SysFixedCustomerPriceSumVo;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class SysFixedCustomerPriceDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page queryFixedCustomerPrice(SysFixedCustomerPrice model, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_fixed_customer_price a");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysFixedCustomerPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysFixedCustomerPrice> queryList(SysFixedCustomerPrice model, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_fixed_customer_price a ");
        sql.append(" where 1=1 ");
        if (model != null) {
            if (!StrUtil.isNull(model.getFixedId())) {
                sql.append(" and a.fixed_id = ").append(model.getFixedId());
            }
            if (!StrUtil.isNull(model.getCustomerId())) {
                sql.append(" and a.customer_id=").append(model.getCustomerId());
            }
            if (!StrUtil.isNull(model.getCustomerIds())) {
                sql.append(" and a.customer_id in (").append(model.getCustomerIds()).append(")");
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysFixedCustomerPrice.class);
    }


    public int addFixedCustomerPrice(SysFixedCustomerPrice model, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_fixed_customer_price", model);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysFixedCustomerPrice queryFixedCustomerPriceById(Integer fdId, String month, String database) {
        String sql = "select * from " + database + ".sys_fixed_customer_price where customer_id=?";
        if (!StringUtils.isBlank(month)) {
            sql += " and month= '" + month + "'";
        }
        try {
            return this.daoTemplate.queryForObj(sql, SysFixedCustomerPrice.class, fdId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateFixedCustomerPrice(SysFixedCustomerPrice model, String database) {
        try {
            List<Object> params = Lists.newArrayList(model.getPrice(), model.getCustomerId(), model.getFixedId());
            String sql = "update " + database + ".sys_fixed_customer_price s set s.price = ? where s.customer_id = ? and s.fixed_id = ?";
            if (StringUtils.isBlank(model.getMonth())) {
                sql += " and (s.`month` = '' or s.`month` is null) ";
            } else {
                sql += " and s.`month` = ?";
                params.add(model.getMonth());
            }
            return this.daoTemplate.update(sql, params.toArray());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryCustomer(Integer page, Integer rows, String keyword, String status, String month,String allowEmptyMonth, String database) {
        String sql = getCustomerPriceSql(keyword,status,month,allowEmptyMonth,database);
        return this.daoTemplate.queryForPageByMySql(sql, page, rows, SysCustomer.class);
    }

    public List<Map<String,Object>> getCustomerPriceList(String keyword, String status, String month,String allowEmptyMonth,String customerIds,Integer fixedId, String database){
        String sql = getCustomerPriceListSql(keyword,status,month,allowEmptyMonth,customerIds,fixedId,database);
        return this.daoTemplate.queryForList(sql);

    }


    private String getCustomerPriceListSql(String keyword, String status, String month,String allowEmptyMonth,String customerIds,Integer fixedId, String database){
        String sql = "select * from (select p.id,p.customer_id,p.`month`,p.fixed_id,p.`status`,p.price,c.kh_nm from " + database + ".sys_fixed_customer_price p ";
        sql+="left join " + database + ".sys_customer c on c.id = p.customer_id where 1=1 ";

        if (StringUtils.isNoneBlank(status)) {
            if (status.equals("1")) {
                sql += " and (p.status is null or p.status=1)";
            } else {
                sql += " and p.status = '" + status + "'";
            }
        }
        if(StringUtils.isNoneBlank(customerIds)){
            sql +=" and p.customer_id in ("+customerIds+")";
        }

        if(!StrUtil.isNull(fixedId)){
            sql +=" and p.fixed_id="+fixedId;
        }

        sql+=" ) a where 1=1 ";

        if (StringUtils.isNotBlank(keyword)) {
            sql += " and a.kh_nm like concat('%','" + keyword + "', '%')";
        }

        if(StringUtils.isBlank(allowEmptyMonth)||"0".equals(allowEmptyMonth)){
            sql += " and ( 1=1 ";
            if (StringUtils.isNotBlank(month)) {
                sql += " and a.month = '" + month + "'";
            }
            sql +=" or a.month is null )";
        }else{
            if (StringUtils.isNotBlank(month)) {
                sql += " and a.month = '" + month + "'";
            }
            sql +=" and a.month is not null ";
        }

        return sql;
    }


    private String getCustomerPriceSql(String keyword, String status, String month,String allowEmptyMonth, String database){
        String sql = "select * from (select p.customer_id,p.`month`,p.`status`,p.price,c.* from " + database + ".sys_fixed_customer_price p ";
        sql+="left join " + database + ".sys_customer c on c.id = p.customer_id where 1=1 ";

        if (StringUtils.isNoneBlank(status)) {
            if (status.equals("1")) {
                sql += " and (p.status is null or p.status=1)";
            } else {
                sql += " and p.status = '" + status + "'";
            }
        }
        sql+=" group by p.customer_id,p.`month`) a where 1=1 ";

        if (StringUtils.isNotBlank(keyword)) {
            sql += " and a.kh_nm like concat('%','" + keyword + "', '%')";
        }
        if (StringUtils.isNotBlank(month)) {
            sql += " and month = '" + month + "'";
        }

//        if(StringUtils.isBlank(allowEmptyMonth)||"0".equals(allowEmptyMonth)){
//            sql +=" or a.month is null ";
//        }else{
//            sql +=" and a.month is not null ";
//        }

        if(StringUtils.isBlank(allowEmptyMonth)||"0".equals(allowEmptyMonth)){
            sql += " and ( 1=1 ";
            if (StringUtils.isNotBlank(month)) {
                sql += " and a.month = '" + month + "'";
            }
            sql +=" or a.month is null )";
        }else{
            if (StringUtils.isNotBlank(month)) {
                sql += " and a.month = '" + month + "'";
            }
            sql +=" and a.month is not null ";
        }


        sql += "order by a.customer_id ";
        return sql;
    }




    public List<SysFixedCustomerPriceSumVo> getCustomerPriceSum(String keyword, String status, String month,String allowEmptyMonth,String database) {
        String sql = "select sum(s.price) as price,s.fixed_id FROM " + database + ".sys_fixed_customer_price s left join " + database + ".sys_customer c" +
                " on c.id = s.customer_id where 1=1 ";
        List<Object> params = Lists.newArrayList();
//        if (StringUtils.isNotEmpty(month)) {
//            sql += " and s.month = ? ";
//            params.add(month);
//        }

        if(StringUtils.isBlank(allowEmptyMonth)||"0".equals(allowEmptyMonth)){
            sql += " and ( 1=1 ";
            if (StringUtils.isNotBlank(month)) {
                sql += " and s.month = '" + month + "'";
            }
            sql +=" or s.month is null )";
        }else{
            if (StringUtils.isNotBlank(month)) {
                sql += " and s.month = '" + month + "'";
            }
            sql +=" and s.month is not null ";
        }
//
//        if(StringUtils.isBlank(allowEmptyMonth)||"0".equals(allowEmptyMonth)){
//            sql +=" or s.month is null ";
//        }else{
//            sql +=" and s.month is not null ";
//        }
        if (StringUtils.isNotBlank(keyword)) {
            sql += " and c.kh_nm like concat('%',?, '%')";
            params.add(keyword);
        }
        if (StringUtils.isNoneBlank(status)) {
            if (status.equals("1")) {
                sql += " and (s.status is null or s.status= ?)";
                params.add(status);
            } else {
                sql += " and s.status = ?";
                params.add(status);
            }
        }

        sql += "group by s.fixed_id";
        return this.daoTemplate.queryForLists(sql, SysFixedCustomerPriceSumVo.class, params.toArray());

    }

    public List<SysFixedCustomerPrice> queryCustomerPrice(List<Integer> customerIds, String datasource) {
        String sql = "select * from " + datasource + ".sys_fixed_customer_price p where p.customer_id in (" + StringUtils.join(customerIds, ",") + ")";
        return this.daoTemplate.queryForLists(sql, SysFixedCustomerPrice.class);
    }


    public Page queryNoneCustomerPrice(Integer page, Integer rows, String khNm, Integer qdtypeId, String database) {
        String sql = "select * from (select c.kh_nm,c.id,c.is_db,c.qdtype_id,b.customer_id from " + database + ".sys_customer c left join (select distinct p.customer_id from " + database + ".sys_fixed_customer_price p) b ON c.id = b.customer_id ) d WHERE d.customer_id IS NULL and d.is_db=2 ";
        if (StringUtils.isNotBlank(khNm)) {
            sql += " and d.kh_nm like concat('%','" + khNm + "', '%')";
        }
        if (qdtypeId != null && qdtypeId != 0) {
            sql += " and d.qdtype_id =' " + qdtypeId + " ' ";

        }
        return this.daoTemplate.queryForPageByMySql(sql, page, rows, SysCustomer.class);
    }

    public int deleteByCustomerId(Integer customerId, String month, String database) {
        List<Object> params = Lists.newArrayList(customerId);
        String sql = " delete from " + database + ".sys_fixed_customer_price where customer_id=? ";
        if (StringUtils.isNotEmpty(month)) {
            sql += " and `month` = ? ";
            params.add(month);
        } else {
            sql += " and (`month` = '' or `month` is null) ";
        }
        try {
            return this.daoTemplate.update(sql, params.toArray());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateCustomerStatus(Integer customerId, String month, String status, String database) {
        List<Object> params = Lists.newArrayList(status, customerId);
        String sql = "update " + database + ".sys_fixed_customer_price set status=? where customer_id=?";
        if (StringUtils.isEmpty(month)) {
            sql += " and (`month` = '' or `month` is null) ";
        } else {
            sql += " and `month` = ? ";
            params.add(month);
        }
        try {
            return this.daoTemplate.update(sql, params.toArray());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateCustomerStatus(String fixedPriceIds, String status, String database){
        String sql = "update " + database + ".sys_fixed_customer_price set status="+status+" where id in("+fixedPriceIds+")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateMonth(String database, Integer customerId, String month, String oldMonth) {
        int count = 0;
        if (StringUtils.isNotEmpty(month)) {
            count = countByCustomerIdAndMonth(customerId, month, database);
        } else {
            count = countByCustomerId(customerId, database);
        }
        if (count > 0) {
            throw new BizException("月份[" + month + "]已存在");
        }
        String sql = "update " + database + ".sys_fixed_customer_price s set s.`month` = ? where s.customer_id = ? ";
        List<Object> params = Lists.newArrayList(month, customerId);
        if (StringUtils.isEmpty(oldMonth)) {
            sql += " and (s.`month` = '' or s.`month` is null)";
        } else {
            sql += " and s.`month` = ? ";
            params.add(oldMonth);
        }
        this.daoTemplate.update(sql, params.toArray());
    }

    public int countByCustomerId(Integer id, String database) {
        return daoTemplate.queryForInt("select count(*) from " + database + ".sys_fixed_customer_price s where s.customer_id = ? and (s.month = '' or s.month is null)", id);
    }

    public int countByCustomerIdAndMonth(Integer id, String month, String database) {
        return daoTemplate.queryForInt("select count(*) from " + database + ".sys_fixed_customer_price s where s.customer_id = ? and (s.month = ?)", id, month);
    }
}
