package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysThorder;
import com.qweib.cloud.core.domain.SysThorderDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysThorderDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Page queryThorderPage(SysThorder order, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.kh_nm,c.member_nm,(select count(1) from " + order.getDatabase() + ".sys_thorder_detail where order_id=a.id) as count from "
                + order.getDatabase() + ".sys_thorder a left join " + order.getDatabase() + ".sys_customer b on a.cid=b.id left join " + order.getDatabase() + ".sys_mem c on a.mid=c.member_id " +
                "where 1=1");
        if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
            if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
                sql.append(" AND (c.branch_id IN (" + allDepts + ") ");
                sql.append(" OR a.mid=" + mId + ")");
            } else {
                sql.append(" AND c.branch_id IN (" + allDepts + ") ");
            }
        } else if (!StrUtil.isNull(mId)) {//个人
            sql.append(" AND a.mid=" + mId);
        }
        if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
            sql.append(" AND c.branch_id NOT IN (" + invisibleDepts + ") ");
        }

        if (null != order) {
            if (!StrUtil.isNull(order.getKhNm())) {
                sql.append(" and b.kh_nm like '%" + order.getKhNm() + "%'");
            }
            if (!StrUtil.isNull(order.getMemberNm())) {
                sql.append(" and c.member_nm like '%" + order.getMemberNm() + "%'");
            }
            if (!StrUtil.isNull(order.getOrderNo())) {
                sql.append(" and a.order_no like '%" + order.getOrderNo() + "%'");
            }
            if (!StrUtil.isNull(order.getOrderZt())) {
                sql.append(" and a.order_zt='" + order.getOrderZt() + "'");
            }
            if (!StrUtil.isNull(order.getPszd())) {
                sql.append(" and a.pszd='" + order.getPszd() + "'");
            }
            if (!StrUtil.isNull(order.getSdate())) {
                sql.append(" and a.oddate >='").append(order.getSdate()).append("'");
            }
            if (!StrUtil.isNull(order.getEdate())) {
                sql.append(" and a.oddate <='").append(order.getEdate()).append("'");
            }
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysThorder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryThorderDetailPage(Integer orderId, String database, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_thorder_detail a left join " + database + ".sys_ware b on a.ware_id=b.ware_id " +
                "where 1=1");
        if (!StrUtil.isNull(orderId)) {
            sql.append(" and a.order_id=" + orderId + "");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysThorderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateOrderSh(String database, Integer id, String sh) {
        String sql = "update " + database + ".sys_thorder set order_zt=? where id=?";
        try {
            return this.daoTemplate.update(sql, sh, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysThorder queryThorderByid(String database, Integer id) {
        try {
            String sql = "select * from " + database + ".sys_thorder where id=?";
            return this.daoTemplate.queryForObj(sql, SysThorder.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteOrder(String database, Integer id) {
        String sql = "delete from " + database + ".sys_thorder where id=?";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int checkWareIsUse(String database, Integer wareId) {
        String sql = " select count(a.id) as num from " + database + ".sys_thorder_detail a where a.ware_id=" + wareId + "";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
