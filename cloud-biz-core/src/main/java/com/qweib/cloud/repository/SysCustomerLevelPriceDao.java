package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerLevelPrice;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerLevelPriceDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page queryCustomerLevelPrice(SysCustomerLevelPrice levelPrice, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_customer_level_price a");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomerLevelPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysCustomerLevelPrice> queryList(SysCustomerLevelPrice levelPrice, String database, String wareIds) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_customer_level_price a ");
        sql.append(" where 1=1 ");
        if (levelPrice != null) {
            if (!StrUtil.isNull(levelPrice.getLevelId())) {
                sql.append(" and a.level_Id = ").append(levelPrice.getLevelId());
            }
            if (!StrUtil.isNull(levelPrice.getWareId())) {
                sql.append(" and a.ware_id=").append(levelPrice.getWareId());
            }
            if (!StrUtil.isNull(levelPrice.getLevelIds())) {
                sql.append(" and a.level_Id in (").append(levelPrice.getLevelIds()).append(")");
            }
        }
        if (!StrUtil.isNull(wareIds)) {
            sql.append(" and a.ware_id in (").append(wareIds).append(")");
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelPrice.class);
    }


    public int addCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_customer_level_price", levelPrice);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysCustomerLevelPrice queryCustomerLevelPriceById(Integer levelPriceId, String database) {
        String sql = "select * from " + database + ".sys_customer_level_price where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysCustomerLevelPrice.class, levelPriceId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysCustomerLevelPrice queryCustomerLevelByWareIdAndLevelId(Integer levelId, Integer wareId, String database) {
        String sql = "select * from " + database + ".sys_customer_level_price where ware_id=? and level_Id=?";
        try {
            List<SysCustomerLevelPrice> list = this.daoTemplate.queryForLists(sql, SysCustomerLevelPrice.class, wareId, levelId);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysCustomerLevelPrice> groupCustomerLevelByWareId(String database, Integer wareId) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.ware_id,ifnull(a.price,0) as price,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_customer_price where ware_id=").append(wareId);
        sql.append(" group by a.ware_id,ifnull(a.price,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", levelPrice.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_customer_level_price", levelPrice, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteCustomerLevelPrice(Integer id, String database) {
        String sql = " delete from " + database + ".sys_customer_level_price where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteByLevelId(Integer levelId, String database) {
        String sql = " delete from " + database + ".sys_customer_level_price where level_id=? ";
        try {
            return this.daoTemplate.update(sql, levelId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteCustomerLevelPriceAll(String database) {
        String sql = "delete from " + database + ".sys_customer_level_price";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysCustomerLevelPrice queryCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(" select * from " + database + ".sys_customer_level_price");
            sb.append(" where 1=1");
            if (null != levelPrice) {
                if (!StrUtil.isNull(levelPrice.getLevelId())) {
                    sb.append(" and level_id = " + levelPrice.getLevelId());
                }
                if (!StrUtil.isNull(levelPrice.getWareId())) {
                    sb.append(" and ware_id = " + levelPrice.getWareId());
                }
            }
            return this.daoTemplate.queryForObj(sb.toString(), SysCustomerLevelPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
