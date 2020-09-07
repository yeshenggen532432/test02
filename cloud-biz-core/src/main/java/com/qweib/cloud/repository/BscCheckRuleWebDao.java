package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscCheckRule;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscCheckRuleWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public Page queryCheckRuleWeb(String database, Integer memId, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select id,kqgj_nm,tp,check_weeks,check_times,address,sy_mids1,member_id from " + database + ".bsc_check_rule where 1=1");
            if (!StrUtil.isNull(memId)) {
                sql.append(" and member_id=" + memId + " or gl_mids2 like '%-" + memId + "%-'");
            }
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscCheckRule.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public int addCheckRuleWeb(BscCheckRule checkRule, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".bsc_check_rule", checkRule);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：自增id
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public Integer getAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public BscCheckRule queryCheckRuleWebOne(String database, Integer id) {
        try {
            String sql = "select * from " + database + ".bsc_check_rule where id=?";
            return this.daoTemplate.queryForObj(sql, BscCheckRule.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改考勤规则人员权限
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public void updateCheckRuleWebRy(String database, Integer id, String syMids1, String syMids2, String glMids1, String glMids2) {
        String sql = "update " + database + ".bsc_check_rule set sy_mids1='" + syMids1 + "',sy_mids2='" + syMids2 + "'," +
                "gl_mids1='" + glMids1 + "',gl_mids2='" + glMids2 + "' where id=" + id + "";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改考勤规则详情
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public void updateCheckRuleWebXq(String database, Integer id, String kqgjNm, String checkWeeks, String checkTimes, String address, String longitude, String latitude,
                                     Integer yxMeter, Integer zzsbTime, Integer zwxbTime, Integer sxbtxTime, Integer isQd) {
        String sql = "update " + database + ".bsc_check_rule set kqgj_nm='" + kqgjNm + "',check_weeks='" + checkWeeks + "',check_times='" + checkTimes + "',address='" + address + "',longitude='" + longitude + "',latitude='" + latitude + "'," +
                "yx_meter=" + yxMeter + ",zzsb_time=" + zzsbTime + ",zwxb_time=" + zwxbTime + ",sxbtx_time=" + sxbtxTime + ",is_qd=" + isQd + " where id=" + id + "";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public void deleteCheckRuleWeb(String database, Integer id) {
        String sql = "delete from " + database + ".bsc_check_rule where id=" + id + "";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id组查询用户
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public List<SysMember> queryMemberByMids(String database, String mids) {
        try {
            StringBuilder sql = new StringBuilder("select member_id,member_nm from " + database + ".sys_mem where member_id in(" + mids + ")");
            return this.daoTemplate.queryForLists(sql.toString(), SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id获取他的考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    public BscCheckRule queryCheckRuleWebBysyMid(String database, Integer syMid) {
        try {
            String sql = "select * from " + database + ".bsc_check_rule where sy_mids2 like '%-" + syMid + "-%'";
            return this.daoTemplate.queryForObj(sql, BscCheckRule.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id获取他的考勤规则
     *
     * @创建：作者:llp 创建时间：2017-3-2
     * @修改历史： [序号](llp 2017 - 3 - 2)<修改说明>
     */
    public BscCheckRule queryCheckRuleWebByMid(String database, Integer Mid) {
        try {
            String sql = "select *,group_concat(sy_mids1) as mids from " + database + ".bsc_check_rule where member_id=" + Mid + " or gl_mids2 like '%-" + Mid + "-%'";
            return this.daoTemplate.queryForObj(sql, BscCheckRule.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取迟到/早退用户人数
     *
     * @创建：作者:llp 创建时间：2017-3-3
     * @修改历史： [序号](llp 2017 - 3 - 3)<修改说明>
     */
    public List<SysCheckIn> queryCheckInCDrs(String database, String mids, String sdate, String edate, String tp) {
        try {
            StringBuilder sql = new StringBuilder("select *,count(1) as counts from " + database + ".sys_checkin where 1=1");
            if (!StrUtil.isNull(mids)) {
                sql.append(" and psn_id in(" + mids + ")");
            }
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and check_time >='").append(sdate + " 00:00:00").append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and check_time <='").append(edate + " 23:59:59").append("'");
            }
            if (!StrUtil.isNull(tp)) {
                sql.append(" and cdzt like '%" + tp + "%'");
            }
            sql.append(" group by psn_id");
            return this.daoTemplate.queryForLists(sql.toString(), SysCheckIn.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id和日期判断在是否请假
     *
     * @创建：作者:llp 创建时间：2017-3-3
     * @修改历史： [序号](llp 2017 - 3 - 3)<修改说明>
     */
    public int queryIsAuditqJ(String database, Integer mid, String dates) {
        try {
            StringBuilder sql = new StringBuilder("select count(1) from " + database + ".bsc_audit where audit_tp=1");
            if (!StrUtil.isNull(mid)) {
                sql.append(" and member_id=" + mid + "");
            }
            if (!StrUtil.isNull(dates)) {
                sql.append(" and stime <='" + dates + "' and etime >='" + dates + "'");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id和日期判断在是否有未打卡
     *
     * @创建：作者:llp 创建时间：2017-3-3
     * @修改历史： [序号](llp 2017 - 3 - 3)<修改说明>
     */
    public int queryIsCheckinDk(String database, Integer mid, String dates) {
        try {
            StringBuilder sql = new StringBuilder("select count(1) from " + database + ".sys_checkin where 1=1");
            if (!StrUtil.isNull(mid)) {
                sql.append(" and psn_id=" + mid + "");
            }
            if (!StrUtil.isNull(dates)) {
                sql.append(" and check_time like '%" + dates + "%'");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id和日期获取迟到/早退
     *
     * @创建：作者:llp 创建时间：2017-3-3
     * @修改历史： [序号](llp 2017 - 3 - 3)<修改说明>
     */
    public int queryIsCheckinCdZt(String database, Integer mid, String dates, String tp) {
        try {
            StringBuilder sql = new StringBuilder("select count(1) from " + database + ".sys_checkin where 1=1");
            if (!StrUtil.isNull(mid)) {
                sql.append(" and psn_id=" + mid + "");
            }
            if (!StrUtil.isNull(dates)) {
                sql.append(" and check_time like '%" + dates + "%'");
            }
            if (!StrUtil.isNull(tp)) {
                sql.append(" and cdzt like '%" + tp + "%'");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id和日期段获取请假次数
     *
     * @创建：作者:llp 创建时间：2017-3-3
     * @修改历史： [序号](llp 2017 - 3 - 3)<修改说明>
     */
    public int queryAuditQjCount(String database, Integer mid, String sdate, String edate) {
        try {
            StringBuilder sql = new StringBuilder("select count(1) from " + database + ".bsc_audit where audit_tp=1");
            if (!StrUtil.isNull(mid)) {
                sql.append(" and member_id=" + mid + "");
            }
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and stime >='").append(sdate).append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and stime <='").append(edate).append("'");
            }
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
