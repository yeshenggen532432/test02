package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQdTypePrice;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQdTypePriceDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page queryQdTypePrice(SysQdTypePrice qdTypePrice, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_qd_type_price a");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysQdTypePrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysQdTypePrice> queryList(SysQdTypePrice qdTypePrice, String database, String wareIds) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_qd_type_price a ");
        sql.append(" where 1=1 ");
        if (qdTypePrice != null) {
            if (!StrUtil.isNull(qdTypePrice.getRelaId())) {
                sql.append(" and a.rela_Id = ").append(qdTypePrice.getRelaId());
            }
            if (!StrUtil.isNull(qdTypePrice.getWareId())) {
                sql.append(" and a.ware_id = ").append(qdTypePrice.getWareId());
            }
            if (!StrUtil.isNull(qdTypePrice.getRelaIds())) {
                sql.append(" and a.rela_Id in( ").append(qdTypePrice.getRelaIds()).append(")");
            }
        }
        if (!StrUtil.isNull(wareIds)) {
            sql.append(" and a.ware_id in (").append(wareIds).append(")");
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysQdTypePrice.class);
    }


    public int addQdTypePrice(SysQdTypePrice qdTypePrice, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_qd_type_price", qdTypePrice);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysQdTypePrice queryQdTypePriceById(Integer qdTypePriceId, String database) {
        String sql = "select * from " + database + ".sys_qd_type_price where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysQdTypePrice.class, qdTypePriceId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysQdTypePrice> groupQdTypePriceByWareId(String database, Integer wareId) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.ware_id,ifnull(a.price,0) as price,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_customer_price where ware_id=").append(wareId);
        sql.append(" group by a.ware_id,ifnull(a.price,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysQdTypePrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateQdTypePrice(SysQdTypePrice qdTypePrice, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", qdTypePrice.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_qd_type_price", qdTypePrice, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteQdTypePrice(Integer id, String database) {
        String sql = " delete from " + database + ".sys_qd_type_price where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteQdTypePriceAll(String database) {
        String sql = "delete from " + database + ".sys_qd_type_price";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysQdTypePrice queryQdTypePrice(SysQdTypePrice typePrice, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(" select * from " + database + ".sys_qd_type_price");
            sb.append(" where 1=1");
            if (null != typePrice) {
                if (!StrUtil.isNull(typePrice.getRelaId())) {
                    sb.append(" and rela_id = " + typePrice.getRelaId());
                }
                if (!StrUtil.isNull(typePrice.getWareId())) {
                    sb.append(" and ware_id = " + typePrice.getWareId());
                }
            }
            return this.daoTemplate.queryForObj(sb.toString(), SysQdTypePrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysQdTypePrice queryQdTypePriceByWareIdAndRelaId(Integer relaId, Integer wareId, String database) {
        String sql = "select * from " + database + ".sys_qd_type_price where ware_id=? and rela_id=?";
        try {
            List<SysQdTypePrice> list = this.daoTemplate.queryForLists(sql, SysQdTypePrice.class, wareId, relaId);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
