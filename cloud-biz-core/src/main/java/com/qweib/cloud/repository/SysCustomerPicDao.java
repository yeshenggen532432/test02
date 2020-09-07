package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysCustomerPicDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addCustomerPic(SysCustomerPic customerPic, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_customer_pic", customerPic);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysCustomerPic> queryCustomerPic(String database, SysCustomerPic customerPic) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + database + ".sys_customer_pic where 1=1 ");
        if (customerPic != null) {
            if (!StrUtil.isNull(customerPic.getCustomerId())) {
                sql.append(" and customer_id=").append(customerPic.getCustomerId());
            }

        }
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据商品ids获取商品图片集合
    public List<SysCustomerPic> queryCustomerPicByIds(String database, String ids) {

        try {
            String sql = "";
            if (!StrUtil.isNull(ids)) {
                sql = "select * from " + database + ".sys_customer_pic where 1=1 and customer_id in (" + ids + ")";
            }
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int queryCustomerPicCount1(String database, SysCustomerPic customerPic) {
        try {
            String sql = " select count(1) from " + database + ".sys_customer_pic where ware_id=?";
            return this.daoTemplate.queryForObject(sql, new Object[]{customerPic.getId()}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteCustomerPic(String database, SysCustomerPic customerPice) {
        String sql = "delete from " + database + ".sys_customer_pic where id=" + customerPice.getId();
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareMainPic(String database, Integer wareId, Integer picId) {
        String sql = "update " + database + ".sys_customer_pic set type=0 where ware_id=" + wareId;
        try {
            this.daoTemplate.update(sql);
            sql = "update " + database + ".sys_customer_pic set type=1 where id=" + picId;
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
