package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscAuditZdy;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 考勤班次地址
 */
@Repository
public class KqBcAddressDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
//
//    /**
//     * 说明：添加审批自定义
//     */
//    public Integer addBscAuditZdy(BscAuditZdy auditZdy, String database) {
//        try {
//            return daoTemplate.addByObject(database + ".bsc_audit_zdy", auditZdy);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 说明：查询审批自定义(查询“启用的”)
//     */
//    public List<BscAuditZdy> queryAuditZdy(Integer memberId, String database) {
//        try {
//            StringBuffer sb = new StringBuffer();
//            sb.append("select a.*, m.name as model_name ");
//            sb.append(" from " + database + ".bsc_audit_zdy a");
//            sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
//            sb.append(" where (member_id=" + memberId + " or is_sy=2)" );
//            sb.append(" and (a.status = '0' or a.status is null)");
//            sb.append(getSqlSort());
//            return this.daoTemplate.queryForLists(sb.toString(), BscAuditZdy.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 说明：查询审批自定义
//     */
//    public List<BscAuditZdy> queryAuditZdyList(Integer memberId, String database, BscAuditZdy bean) {
//        try {
//            StringBuffer sb = new StringBuffer();
//            sb.append(" select a.*, m.detail_name,m.amount_name,m.type_name,m.object_name,m.remark_name,m.account_name,m.order_name,m.time_name,m.name as model_name ");
//            sb.append(" from " + database + ".bsc_audit_zdy a");
//            sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
//            sb.append(" where (a.member_id =" + memberId + " or is_sy=2)");
//            if (bean != null) {
//                if (!StrUtil.isNull(bean.getZdyNm())) {
//                    sb.append(" and a.zdy_nm like '%" + bean.getZdyNm() + "%'");
//                }
//                if (!StrUtil.isNull(bean.getIsSy())) {
//                    sb.append(" and a.is_sy =" + bean.getIsSy());
//                }
//                if (!StrUtil.isNull(bean.getStatus())) {
//                    if ("1".equals(""+bean.getStatus())){
//                        sb.append(" and a.status = '" + bean.getStatus() + "'");
//                    }else{
//                        sb.append(" and (a.status = '" + bean.getStatus() + "' or a.status is null)");
//                    }
//                }
//            }
//            sb.append(getSqlSort());
//            return this.daoTemplate.queryForLists(sb.toString(), BscAuditZdy.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 根据名称获取自定义审批
//     */
//    public BscAuditZdy getAuditZdy(Integer memberId, String database, String zdyNm) {
//        try {
//            String sql = "select * from " + database + ".bsc_audit_zdy where member_id=? and zdy_nm=?";
//            List<BscAuditZdy> list = this.daoTemplate.queryForLists(sql, BscAuditZdy.class, new Object[]{memberId, zdyNm});
//            return Collections3.isNotEmpty(list) ? list.get(0) : null;
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 说明：修改审批自定义
//     */
//    public int updateAuditZdy(String database, BscAuditZdy bean) {
//        try {
//            Map<String,Object> whereParam = new HashMap<>();
//            whereParam.put("id", bean.getId());
//            return this.daoTemplate.updateByObject(database+".bsc_audit_zdy", bean, whereParam, "id");
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 说明：删除审批自定义
//     */
//    public int deleteAuditZdy(String database, Integer id) {
//        String sql = "delete from " + database + ".bsc_audit_zdy where id=?";
//        try {
//            return this.daoTemplate.update(sql, id);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 摘要：
//     */
//    public int queryAuditZdyNmCount(String database, Integer memberId, String zdyNm) {
//        String sql = "select count(1) from " + database + ".bsc_audit_zdy where member_id=? and zdy_nm=?";
//        try {
//            return this.daoTemplate.queryForObject(sql, new Object[]{memberId, zdyNm}, Integer.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * @说明：根据id获取审批自定义
//     */
//    public BscAuditZdy queryAuditZdyById(Integer id, String database) {
//        StringBuffer sb = new StringBuffer();
//        sb.append(" select a.*,m.name as model_name ");
//        sb.append(" from " + database + ".bsc_audit_zdy a");
//        sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
//        sb.append(" where a.id="+id );
//        try {
//            return this.daoTemplate.queryForObj(sb.toString(), BscAuditZdy.class, null);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    /**
//     * 获取排序sql
//     */
//    private String getSqlSort(){
//        String s = " order by CASE WHEN a.sort IS NULL THEN 1 ELSE 0 END ASC, a.sort,a.id asc ";
//        return s;
//    }


    //----------------------------------------------------------------------------------------------
    /**
     * 根据地址名称查询
     */
    public KqAddress queryKqBcAddressByAddress(String database, String address) {
        try {
            String sql = "select * from " + database + ".kq_bc_address where address=?";
            List<KqAddress> list = this.daoTemplate.queryForLists(sql, BscAuditZdy.class, new Object[]{address});
            return Collections3.isNotEmpty(list) ? list.get(0) : null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id查询
     */
    public KqAddress queryById(String database, Integer id) {
        try {
            String sql = "select * from " + database + ".kq_bc_address where id=?";
            List<KqAddress> list = this.daoTemplate.queryForLists(sql, BscAuditZdy.class, new Object[]{id});
            return Collections3.isNotEmpty(list) ? list.get(0) : null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     *
     */
    public List<KqAddress> queryList(String database, KqAddress bean) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(" select a.*");
            sb.append(" from " + database + ".kq_bc_address a");
            sb.append(" where 1=1 ");
            if (bean != null) {
                if (!StrUtil.isNull(bean.getAddress())) {
                    sb.append(" and a.address like '%" + bean.getAddress() + "%'");
                }
            }
            return this.daoTemplate.queryForLists(sb.toString(), KqAddress.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 添加
     */
    public Integer add(String database, KqAddress bean) {
        try {
            return daoTemplate.addByObject(database + ".kq_bc_address", bean);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改
     */
    public int update(String database, KqAddress bean) {
        try {
            Map<String,Object> whereParam = new HashMap<>();
            whereParam.put("id", bean.getId());
            return this.daoTemplate.updateByObject(database+".kq_bc_address", bean, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
