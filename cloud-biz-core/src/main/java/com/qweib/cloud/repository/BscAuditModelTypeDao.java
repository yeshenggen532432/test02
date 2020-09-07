package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscAuditModelType;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

/**
 * 审批模板类型科目
 */
@Repository
public class BscAuditModelTypeDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 批量添加审批模板类型科目
     */
    public int[] batchAddAuditModeType(String database, Integer modelId, List<BscAuditModelType> list) {
        String sql = "insert into " + database + ".bsc_audit_model_type(model_id,subject_type,subject_item) values (?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, modelId);
                    pre.setString(2, list.get(num).getSubjectType());
                    pre.setString(3, list.get(num).getSubjectItem());
                }

                public int getBatchSize() {
                    return list.size();
                }
            };
            return daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量删除审批模板类型科目
     */
    public int batchDelAuditModeType(String database, String ids) {
        String sql = "delete  from " + database + ".bsc_audit_model_type where id in (" + ids + ")";
        return daoTemplate.update(sql);
    }

    /**
     * 审批模板：分页的
     */
    public Page queryAuditModelType(BscAuditModelType bean, String database, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.*,t.type_name,i.item_name from " + database + ".bsc_audit_model_type a ");
            sql.append(" left join " + database + ".fin_costtype t on t.id = a.subject_type");
            sql.append(" left join " + database + ".fin_costitem i on i.id = a.subject_item");
            sql.append(" where 1=1 ");
            if (bean != null) {
                if (!StrUtil.isNull(bean.getModelId())) {
                    sql.append(" and a.model_id = " + bean.getModelId());
                }
                if (!StrUtil.isNull(bean.getTypeName())) {
                    sql.append(" and t.type_name like '% " + bean.getTypeName() + "'%");
                }
                if (!StrUtil.isNull(bean.getItemName())) {
                    sql.append(" and i.item_name like '%" + bean.getItemName() + "%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscAuditModelType.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
//
//    /**
//     * 审批模板：全部数据
//     */
//    public List<BscAuditModel> queryAuditModelList(BscAuditModel bean, String database) {
//        StringBuilder sql = getPublicSql(bean, database);
//        try {
//            return this.daoTemplate.queryForLists(sql.toString(), BscAuditModel.class, null);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 审批模板：过滤没有类型的
//     */
//    public List<BscAuditModel> queryAuditModelListByNoType(BscAuditModel bean, String database) {
//        StringBuilder sql = new StringBuilder();
//        sql.append("select a.* from " + database + ".bsc_audit_model a ");
//        sql.append(" where 1=1 ");
//        sql.append(" and a.type_name is not null");
//        sql.append(" order by a.id asc");
//        try {
//            return this.daoTemplate.queryForLists(sql.toString(), BscAuditModel.class, null);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 审批模板：全部数据
//     */
//    public BscAuditModel queryAuditModelById(Integer id, String database) {
//        try {
//            String sql = "select * from " + database + ".bsc_audit_model where id =? ";
//            return this.daoTemplate.queryForObj(sql, BscAuditModel.class, id);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    private StringBuilder getPublicSql(BscAuditModel bean, String database) {
//        StringBuilder sql = new StringBuilder();
//        sql.append("select a.* from " + database + ".bsc_audit_model a ");
//        sql.append(" where 1=1 ");
//        if(bean != null){
//            if(!StrUtil.isNull(bean.getName())){
//                sql.append(" and a.name like '%" + bean.getName() + "%'");
//            }
//        }
//        sql.append(" order by a.id asc");
//        return sql;
//    }


}
