package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqDetail;
import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class KqDetailDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addDetail(KqDetail bo, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".kq_detail", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateDetail(KqDetail bo, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bo.getId());
            return this.daoTemplate.updateByObject("" + database + ".kq_detail", bo, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public String getLastKqDate(Integer memberId,String endDate,String database)
    {
        String sql = "select * from " + database + ".kq_detail where kq_date<'" + endDate + "' and member_id=" + memberId.toString() + " order by kq_date desc limit 0,1";
        List<KqDetail> list = this.daoTemplate.queryForLists(sql,KqDetail.class);
        if(list.size() > 0)return list.get(0).getKqDate();
        return "";

    }

    public int deleteDetail(KqEmpRule bo, String database) {
        String sql = "delete from " + database + ".kq_detail where 1 = 1 ";
        Integer flag = 0;
        if (bo.getId() != null) {
            if (bo.getId().intValue() > 0) {
                sql += " and id = " + bo.getId().toString();
                flag = 1;
            }
        }
        if (!StrUtil.isNull(bo.getSdate())) {
            sql += " and kq_date>='" + bo.getSdate() + "'";
            flag = 1;
        }
        if (!StrUtil.isNull(bo.getEdate())) {
            sql += " and kq_date<'" + bo.getEdate() + "'";
            flag = 1;
        }
        if (bo.getMemberId() != null) {
            if (bo.getMemberId().intValue() > 0) {
                flag = 1;
                sql += " and member_id = " + bo.getMemberId().toString();
            }
        }
        if (!StrUtil.isNull(bo.getBranchId()) || !StrUtil.isNull(bo.getMemberNm())) {
            sql += " and member_id in(select member_id from " + database + ".sys_mem where 1 = 1 ";
            if (!StrUtil.isNull(bo.getBranchId())) {
                if (bo.getBranchId().intValue() > 0)
                    sql += " and branch_id=" + bo.getBranchId();
            }
            if (!StrUtil.isNull(bo.getMemberNm())) sql += " and member_nm like '%" + bo.getMemberNm() + "%'";
            sql += ")";
        }
        if (flag == 0) return 0;
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public Page queryKqDetailPage(KqEmpRule bo, String database, Integer page, Integer limit) {
        String sql = "select a.*,e.member_nm from " + database + ".kq_detail a join " + database + ".sys_mem e on a.member_id = e.member_id ";
        if (bo.getBranchId() != null) {
            if (bo.getBranchId().intValue() > 0) {
                sql += " join " + database + ".sys_depart d on e.branch_id = d.branch_id ";
            }
        }
        sql += " where 1  = 1 ";

        if (bo.getBranchId() != null) {
            if (bo.getBranchId().intValue() > 0) {
                sql += " and e.branch_id =" + bo.getBranchId();
            }
        }
        if (!StrUtil.isNull(bo.getMemberNm())) {
            sql += " and e.member_nm like '%" + bo.getMemberNm() + "%'";
        }

        if (!StrUtil.isNull(bo.getSdate())) {
            sql += " and a.kq_date>='" + bo.getSdate() + "'";
        }
        if (!StrUtil.isNull(bo.getEdate())) {
            sql += " and a.kq_date<'" + bo.getEdate() + "'";
        }
        sql += " order by a.member_id,a.kq_date ";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqDetail.class);

    }

    public List<SysCheckIn> getCheckInList(KqDetail bo, String database) {
        String sql = "select a.* from " + database + ".sys_checkin a join " + database + ".sys_mem e on a.psn_id = e.member_id ";
        if (bo.getBranchId() != null) {
            if (bo.getBranchId().intValue() > 0) {
                sql += " join " + database + ".sys_depart d on e.branch_id = d.branch_id ";
            }
        }
        sql += " where 1  = 1 ";

        if (bo.getBranchId() != null) {
            if (bo.getBranchId().intValue() > 0) {
                sql += " and e.branch_id =" + bo.getBranchId();
            }
        }
        if (!StrUtil.isNull(bo.getMemberNm())) {
            sql += " and e.member_nm like '%" + bo.getMemberNm() + "%'";
        }
        if(bo.getMemberId()!= null)
        {
            sql += " and a.psn_id=" + bo.getMemberId().toString();
        }
        if (!StrUtil.isNull(bo.getSdate())) {
            sql += " and a.check_time>='" + bo.getSdate() + "'";
        }
        if (!StrUtil.isNull(bo.getEdate())) {
            sql += " and a.check_time<='" + bo.getEdate() + "'";
        }

        return this.daoTemplate.queryForLists(sql, SysCheckIn.class);
    }

    public List<SysCheckIn> getCheckInList1(String sdate, String edate, String ids, String database) {
        String sql = "select a.* from " + database + ".sys_checkin a join " + database + ".sys_mem e on a.psn_id = e.member_id where psn_id in(" + ids + ")";
        if (!StrUtil.isNull(sdate)) {
            sql += " and a.check_time>='" + sdate + "'";
        }
        if (!StrUtil.isNull(edate)) {
            sql += " and a.check_time<='" + edate + "'";
        }
        return this.daoTemplate.queryForLists(sql, SysCheckIn.class);
    }


}
