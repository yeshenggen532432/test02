package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPlan;
import com.qweib.cloud.core.domain.BscPlanNew;
import com.qweib.cloud.core.domain.BscPlanSub;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.BranchMemberSqlUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BscPlanWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询计划（我的拜访）
     *
     * @创建：作者:llp 创建时间：2016-8-2
     * @修改历史： [序号](llp 2016 - 8 - 2)<修改说明>
     */
    public Page queryBscPlanWeb(String database, Integer page, Integer limit, String pdate, Integer mid, Integer branchId, String tp, String mids) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.id,a.mid,a.cid,a.is_wc,b.member_nm,c.kh_nm,c.address,c.linkman,c.tel,c.scbf_date,d.branch_name from " + database + ".bsc_plan a left join " + database + ".sys_mem b on a.mid=b.member_id left join " + database + ".sys_customer c on a.cid=c.id" +
                " left join " + database + ".sys_depart d on a.branch_id=d.branch_id where a.pdate='" + pdate + "'");
        if (tp.equals("1")) {
            sql.append(" and a.mid=" + mid + "");
        }
        if (!StrUtil.isNull(mids)) {
            sql.append(" and a.mid in (" + mids + ")");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlan.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询计划（我的拜访）(新的)
     */
    public BscPlanNew queryBscPlanNewWeb(String database, String pdate, Integer mid) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select a.*, x.xl_nm from " + database + ".bsc_plan_new a");
            sql.append(" left join " + database + ".bsc_planxl x on a.xlid = x.id");
            sql.append(" where a.pdate = '" + pdate + "'");
            sql.append(" and a.mid = " + mid + "");
            return this.daoTemplate.queryForObj(sql.toString(), BscPlanNew.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询计划（下属）(新的)
     */
    public Page queryBscPlanNewUnderlingWeb(String database, String pdate, int mid, String mids, Integer page, Integer limit,
                                            String visibleBranch, String invisibleBranch) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select a.*,x.xl_nm,m.member_nm from " + database + ".bsc_plan_new a ");
            sql.append(" left join " + database + ".bsc_planxl x on a.xlid = x.id");
            sql.append(" left join " + database + ".sys_mem m on a.mid = m.member_id");
            sql.append(BranchMemberSqlUtil.getBranchMemberSql(database, "a", visibleBranch, invisibleBranch, mid, mids));
            sql.append(" and a.pdate = '" + pdate + "'");
            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlanNew.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询计划（我的拜访明细）(新的)
     */
    public Page queryBscPlanSubWeb(String database, Integer pid, Integer mid, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select a.*,c.kh_nm,c.address,c.linkman,c.tel,c.scbf_date from " + database + ".bsc_plan_sub a ");
            sql.append(" left join " + database + ".sys_customer c on a.cid = c.id");
            sql.append(" where a.pid = " + pid + "");
            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlanSub.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询计划（我的拜访明细）(新的)
     */
    public List<BscPlanSub> queryBscPlanSubList(String database, Integer pid) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select a.*,c.kh_nm,c.address,c.linkman,c.tel,c.scbf_date from " + database + ".bsc_plan_sub a ");
            sql.append(" left join " + database + ".sys_customer c on a.cid = c.id");
            sql.append(" where a.pid = " + pid + "");
            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForLists(sql.toString(), BscPlanSub.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //分页查询计划（下属拜访）
    public Page queryBscPlanWebForUnderling(String database, Integer page, Integer limit, String pdate, Integer mid, Integer branchId, String tp, String mids, String allDepts, String invisibleDepts) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.id,a.mid,a.cid,a.is_wc,b.member_nm,c.kh_nm,c.address,c.linkman,c.tel,c.scbf_date,d.branch_name from " + database + ".bsc_plan a left join " + database + ".sys_mem b on a.mid=b.member_id left join " + database + ".sys_customer c on a.cid=c.id" +
                " left join " + database + ".sys_depart d on a.branch_id=d.branch_id where a.pdate='" + pdate + "'");
        if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
            sql.append(" and a.branch_id IN (" + allDepts + ") ");
        }
        if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
            sql.append(" and a.branch_id NOT IN (" + invisibleDepts + ") ");
        }
        sql.append(" and a.mid !=" + mid + " ");
        if (!StrUtil.isNull(mids)) {
            sql.append(" and a.mid in (" + mids + ") ");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlan.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：计划完成数
     *
     * @创建：作者:llp 创建时间：2016-8-2
     * @修改历史： [序号](llp 2016 - 8 - 2)<修改说明>
     */
    public int queryBscPlanWebCount(String database, String pdate, Integer mid, Integer branchId, String tp, String mids) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select count(a.id) as counts from " + database + ".bsc_plan a left join " + database + ".sys_mem b on a.mid=b.member_id left join " + database + ".sys_customer c on a.cid=c.id" +
                    " left join " + database + ".sys_depart d on a.branch_id=d.branch_id where a.pdate='" + pdate + "' and is_wc=1");
            if (tp.equals("1")) {
                sql.append(" and a.mid=" + mid + "");
            } else if (tp.equals("2")) {
                sql.append(" and d.branch_path like '%-" + branchId + "-%' and a.mid!=" + mid + "");
            } else {
                sql.append(" and a.mid!=" + mid + "");
            }
            if (!StrUtil.isNull(mids)) {
                sql.append(" and a.mid in (" + mids + ")");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：计划完成数
     */
    public int queryBscPlanNewWebCount(String database, Integer pid) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select count(a.id) as counts from " + database + ".bsc_plan_sub a ");
            sql.append(" where a.pid = " + pid + " and is_wc = 1");
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //计划完成数(下属拜访)
    public int queryBscPlanWebCountForUnderling(String database, String pdate, Integer mid, Integer branchId, String tp, String mids, String allDepts, String invisibleDepts) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select count(a.id) as counts from " + database + ".bsc_plan a left join " + database + ".sys_mem b on a.mid=b.member_id left join " + database + ".sys_customer c on a.cid=c.id" +
                    " left join " + database + ".sys_depart d on a.branch_id=d.branch_id where a.pdate='" + pdate + "' and is_wc=1");
            if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
                sql.append(" AND a.branch_id IN (" + allDepts + ") ");
            }
            if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
                sql.append(" AND a.branch_id NOT IN (" + invisibleDepts + ") ");
            }
            sql.append(" and a.mid!=" + mid + "");
            if (!StrUtil.isNull(mids)) {
                sql.append(" and a.mid in (" + mids + ")");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加计划
     *
     * @创建：作者:llp 创建时间：2016-8-2
     * @修改历史： [序号](llp 2016 - 8 - 2)<修改说明>
     */
    public int addBscPlanWeb(BscPlan plan, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".bsc_plan", plan);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /**
     * 说明：添加计划
     */
    public int addBscPlanNewWeb(BscPlanNew plan, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".bsc_plan_new", plan);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /**
     * 说明：添加计划(明细)
     */
    public int addBscPlanSubWeb(BscPlanSub planSub, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".bsc_plan_sub", planSub);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除计划
     *
     * @创建：作者:llp 创建时间：2016-8-2
     * @修改历史： [序号](llp 2016 - 8 - 2)<修改说明>
     */
    public void deleteBscPlanWeb(String database, Integer id) {
        String sql = "delete from " + database + ".bsc_plan where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /**
     * 说明：删除计划明细
     */
    public int deleteBscPlanSubWeb(String database, Integer id) {
        String sql = "delete from " + database + ".bsc_plan_sub where pid=" + id;
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改计划状态
     *
     * @创建：作者:llp 创建时间：2016-8-2
     * @修改历史： [序号](llp 2016 - 8 - 2)<修改说明>
     */
    public void updateBscPlanWeb(String database, Integer mid, Integer cid, String pdate) {
        String sql = "update " + database + ".bsc_plan set is_wc=1 where mid=" + mid + " and cid=" + cid + " and pdate='" + pdate + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改计划状态(新的)
     */
    public void updateBscPlanNewWeb(String database, Integer pid, Integer cid) {
        String sql = "update " + database + ".bsc_plan_sub set is_wc=1 where pid=" + pid + " and cid=" + cid;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改计划状态(新的)
     */
    public int updateBscPlanNewWeb(String database, BscPlanNew plan) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", plan.getId());
            return this.daoTemplate.updateByObject("" + database + ".bsc_plan_new", plan, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryPlanByMCDCount(String database, Integer mid, Integer cid, String pdate) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select count(1) as counts from " + database + ".bsc_plan where mid=" + mid + " and cid=" + cid + " and pdate='" + pdate + "'");
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取计划信息是否存在
     *
     * @创建：作者:llp 创建时间：2016-8-9
     * @修改历史： [序号](llp 2016 - 8 - 9)<修改说明>
     */
    public List queryPlanByCids(String cids, Integer mid, String pdate, String database) {
        String sql = "select * from " + database + ".bsc_plan where cid in(?) and mid=" + mid + " and pdate='" + pdate + "'";
        sql = sql.replace("?", cids);
        try {
            return this.daoTemplate.queryForLists(sql, BscPlan.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据日期获取业务员拜访
     *
     * @创建：作者:llp 创建时间：2016-8-23
     * @修改历史： [序号](llp 2016 - 8 - 23)<修改说明>
     */
    public List queryPlanByPdate(String pdate, String database) {
        String sql = "select a.mid,count(a.cid) as num,b.member_mobile as tel from " + database + ".bsc_plan a left join " + database + ".sys_mem b on a.mid=b.member_id where a.pdate='" + pdate + "' group by a.mid";
        try {
            return this.daoTemplate.queryForLists(sql, BscPlan.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
