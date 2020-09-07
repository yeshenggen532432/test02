package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscAuditZdy;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
public class BscAuditZdyWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加审批自定义
     */
    public Integer addBscAuditZdy(BscAuditZdy auditZdy, String database) {
        try {
            return daoTemplate.addByObject(database + ".bsc_audit_zdy", auditZdy);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：查询审批自定义(查询“启用的”)
     */
    public List<BscAuditZdy> queryAuditZdy(Integer memberId, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append("select a.*, m.name as model_name ");
            sb.append(" from " + database + ".bsc_audit_zdy a");
            sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
            sb.append(" where (member_id=" + memberId + " or is_sy=2)" );
            sb.append(" and (a.status = '0' or a.status is null)");
            sb.append(getSqlSort());
            return this.daoTemplate.queryForLists(sb.toString(), BscAuditZdy.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：查询审批自定义
     */
    public List<BscAuditZdy> queryAuditZdyList(Integer memberId, String database, BscAuditZdy bean) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(" select a.*, m.detail_name,m.amount_name,m.type_name,m.object_name,m.remark_name,m.account_name,m.order_name,m.time_name,m.name as model_name ");
            sb.append(" from " + database + ".bsc_audit_zdy a");
            sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
            sb.append(" where (a.member_id =" + memberId + " or is_sy=2)");
            if (bean != null) {
                if (!StrUtil.isNull(bean.getZdyNm())) {
                    sb.append(" and a.zdy_nm like '%" + bean.getZdyNm() + "%'");
                }
                if (!StrUtil.isNull(bean.getIsSy())) {
                    sb.append(" and a.is_sy =" + bean.getIsSy());
                }
                if (!StrUtil.isNull(bean.getStatus())) {
                    if ("1".equals(""+bean.getStatus())){
                        sb.append(" and a.status = '" + bean.getStatus() + "'");
                    }else{
                        sb.append(" and (a.status = '" + bean.getStatus() + "' or a.status is null)");
                    }
                }
            }
            sb.append(getSqlSort());
            return this.daoTemplate.queryForLists(sb.toString(), BscAuditZdy.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据名称获取自定义审批
     */
    public BscAuditZdy getAuditZdy(Integer memberId, String database, String zdyNm) {
        try {
            String sql = "select * from " + database + ".bsc_audit_zdy where member_id=? and zdy_nm=?";
            List<BscAuditZdy> list = this.daoTemplate.queryForLists(sql, BscAuditZdy.class, new Object[]{memberId, zdyNm});
            return Collections3.isNotEmpty(list) ? list.get(0) : null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改审批自定义
     */
    public int updateAuditZdy(String database, BscAuditZdy bean) {
        try {
            Map<String,Object> whereParam = new HashMap<>();
            whereParam.put("id", bean.getId());
            return this.daoTemplate.updateByObject(database+".bsc_audit_zdy", bean, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除审批自定义
     */
    public int deleteAuditZdy(String database, Integer id) {
        String sql = "delete from " + database + ".bsc_audit_zdy where id=?";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     */
    public int queryAuditZdyNmCount(String database, Integer memberId, String zdyNm) {
        String sql = "select count(1) from " + database + ".bsc_audit_zdy where member_id=? and zdy_nm=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{memberId, zdyNm}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据审批流名称查询
     */
    public BscAuditZdy queryAuditZdyByName(String database, String zdyNm) {
        try {
            String sql = "select * from " + database + ".bsc_audit_zdy where zdy_nm = ?";
            List<BscAuditZdy> list = this.daoTemplate.queryForLists(sql, BscAuditZdy.class,new Object[]{zdyNm});
            if(Collections3.isNotEmpty(list)){
                return list.get(0);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return null;
    }

    /**
     * @说明：根据id获取审批自定义
     */
    public BscAuditZdy queryAuditZdyById(Integer id, String database) {
        StringBuffer sb = new StringBuffer();
        sb.append(" select a.*,m.name as model_name ");
        sb.append(" from " + database + ".bsc_audit_zdy a");
        sb.append(" left join " + database + ".bsc_audit_model m on m.id = a.model_id" );
        sb.append(" where a.id="+id );
        try {
            return this.daoTemplate.queryForObj(sb.toString(), BscAuditZdy.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 获取排序sql
     */
    private String getSqlSort(){
//        CASE WHEN a.sort IS NULL THEN 1 ELSE 0 END ASC, a.sort asc,
        String s = " order by CASE WHEN m.id IS NULL THEN 1 ELSE 0 END ASC, m.id asc ";
        return s;
    }

    /**
     * 根据modeId查询审批流列表
     */
    public List<BscAuditZdy> queryAuditZdyListByModelId(String database, Integer modelId, Integer status) {
        StringBuffer sb = new StringBuffer();
        sb.append(" select a.*,f.id as account_id,f.acc_name as account_name");
        sb.append(" from " + database + ".bsc_audit_zdy a");
        sb.append(" left join " + database + ".approval_transfer_order_config c on c.approval_id = a.id" );
        sb.append(" left join " + database + ".fin_account f on f.id = c.payment_account" );
        sb.append(" where a.model_id="+modelId);
        if(status != null && status == 1){
            sb.append(" and a.status=1");
        }else{
            sb.append(" and (a.status=0 or a.status is null)");
        }
        try {
            return this.daoTemplate.queryForLists(sb.toString(), BscAuditZdy.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据modeId查询审批流列表
     */
    public Page queryAuditZdyPageByModelId(String database, Integer modelId, Integer page, Integer rows) {
        StringBuffer sb = new StringBuffer();
        sb.append(" select a.*,f.id as account_id,f.acc_name as account_name");
        sb.append(" from " + database + ".bsc_audit_zdy a");
        sb.append(" left join " + database + ".approval_transfer_order_config c on c.approval_id = a.id" );
        sb.append(" left join " + database + ".fin_account f on f.id = c.payment_account" );
        sb.append(" where a.model_id="+modelId);
        sb.append(" and (a.status=0 or a.status is null)");
        try {
            return this.daoTemplate.queryForPageByMySql(sb.toString(),page, rows, BscAuditZdy.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
