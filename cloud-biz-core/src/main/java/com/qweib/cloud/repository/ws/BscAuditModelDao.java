package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscAuditModel;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;
import javax.annotation.Resource;
import java.util.List;

/**
 * 审批模板
 */
@Repository
public class BscAuditModelDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 审批模板：分页的
     */
    public Page queryAuditModelPage(BscAuditModel bean, String database, Integer page, Integer limit) {
        StringBuilder sql = getPublicSql(bean, database);
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscAuditModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 审批模板：全部数据
     */
    public List<BscAuditModel> queryAuditModelList(BscAuditModel bean, String database) {
        StringBuilder sql = getPublicSql(bean, database);
        try {
            return this.daoTemplate.queryForLists(sql.toString(), BscAuditModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 审批模板：过滤没有类型的
     */
    public List<BscAuditModel> queryAuditModelListByNoType(BscAuditModel bean, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.* from " + database + ".bsc_audit_model a ");
        sql.append(" where 1=1 ");
        sql.append(" and a.type_name is not null");
        if(bean != null){
            if(!StrUtil.isNull(bean.getDelFlag())){
                if(String.valueOf(bean.getDelFlag()).equals("1")){
                    sql.append(" and a.del_flag = 1");
                }else {
                    sql.append(" and (a.del_flag = 0 or a.del_flag is null)");
                }
            }
        }
        sql.append(" order by a.id asc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), BscAuditModel.class, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 审批模板：全部数据
     */
    public BscAuditModel queryAuditModelById(Integer id, String database) {
        try {
            String sql = "select * from " + database + ".bsc_audit_model where id =? ";
            return this.daoTemplate.queryForObj(sql, BscAuditModel.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    private StringBuilder getPublicSql(BscAuditModel bean, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.* from " + database + ".bsc_audit_model a ");
        sql.append(" where 1=1 ");
        if(bean != null){
            if(!StrUtil.isNull(bean.getName())){
                sql.append(" and a.name like '%" + bean.getName() + "%'");
            }
            if(!StrUtil.isNull(bean.getDelFlag())){
                if(String.valueOf(bean.getDelFlag()).equals("1")){
                    sql.append(" and a.del_flag = 1");
                }else {
                    sql.append(" and (a.del_flag = 0 or a.del_flag is null)");
                }
            }
        }
        sql.append(" order by case when a.sort is null then 1 else 0 end asc, a.sort asc");
        return sql;
    }


}
