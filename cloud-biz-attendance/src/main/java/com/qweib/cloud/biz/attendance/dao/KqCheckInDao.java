package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.signin.model.SysSignIn;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysCheckInConform;
import com.qweib.cloud.core.domain.SysCheckInDate;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class KqCheckInDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    /**
     * 通过人员ID和签到时间查询记录
     */
    public Integer queryCheckByMidAndTime(Integer psnId, String checkTime, String database, String tp) {
        String sql = " select count(1) from " + database + ".sys_checkin where psn_id=? and DATE_FORMAT(check_time,'%Y-%m-%d')=? and tp='" + tp + "' ";
        try {
            return this.daoTemplate.queryForInt(sql.toString(), psnId, checkTime);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 添加签到记录
     */
    public int addCheck(SysCheckIn checkin, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return this.daoTemplate.addByObject("" + database + ".sys_checkin", checkin);
            //return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public int deleteCheckById(Integer id, String database) {
        String sql = "delete from " + database + ".sys_checkin where id=" + id;
        return this.daoTemplate.update(sql);
    }

    public int updateCheck(SysCheckIn checkin, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", checkin.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_checkin", checkin, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 公告分页查询(旧)
     */
    public Page page(SysCheckIn checkin, Integer page, Integer rows, String database, Integer memberId, String tp) {
        StringBuffer sql = new StringBuffer("SELECT c.id,c.job_content,c.location,DATE_FORMAT(c.check_time,'%Y-%m-%d %H:%i') check_time,(case when c.tp='1-2' then '下班' else '上班' end) as tp,m.member_nm ");
        sql.append(" from " + database + ".sys_checkin c left join " + database + ".sys_mem m on c.psn_id=m.member_id ");
        sql.append(" where member_id=" + memberId);
        sql.append(" and c.tp like '" + tp + "%' ");
        sql.append(" ORDER BY c.id DESC ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCheckIn.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param pageNo
     * @param pageSize
     * @param database
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：Oct 12, 2015
     * @see 公告分页查询(新)
     */
    public Page pageList(Integer pageNo, Integer pageSize, String database,
                         Integer memId) {
        StringBuffer sql = new StringBuffer("select date_format(check_time,'%Y-%m-%d') as checkTime,tp, ");
        sql.append(" (select id from " + database + ".sys_checkin where date_format(check_time,'%Y-%m-%d')=checkTime and (tp='1-1' or tp='1')  order by check_time desc limit 0,1) as upid, ");
        sql.append(" (select location from " + database + ".sys_checkin where id=upid) as locationup, ");
        sql.append(" (select id from " + database + ".sys_checkin where date_format(check_time,'%Y-%m-%d')=checkTime and tp='1-2'  order by check_time desc limit 0,1)as downid, ");
        sql.append(" (select location from " + database + ".sys_checkin where id=downid)as locationdown ");
        sql.append(" from " + database + ".sys_checkin where psn_id=" + memId + "");
        sql.append(" group by date_format(check_time,'%Y-%m-%d')  having tp!='2' ");
        sql.append(" order by checkTime desc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysCheckInConform.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：签到时间分页
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public Page pageCheckInDate(Integer pageNo, Integer pageSize, String database,
                                Integer psnId, String dates) {
        String dqtime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Calendar c = Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            StringBuffer sql = new StringBuffer("select distinct date_format(check_time,'%Y-%m-%d') as checkTime,tp,psn_id");
            sql.append(" from " + database + ".sys_checkin where psn_id=" + psnId + "");
            if (StrUtil.isNull(dates) || dates.equals("本周")) {
                int weekday = c.get(7) - 2;
                c.add(5, -weekday);
                Date tasktime = c.getTime();
                String sdate = "";
                Date a = df.parse(df.format(tasktime));
                Date b = new Date();
                boolean flag = a.after(b);
                if (flag) {
                    int weekday2 = c.get(7) + 5;
                    c.add(5, -weekday2);
                    Date tasktime2 = c.getTime();
                    sdate = df.format(tasktime2);
                } else {
                    sdate = df.format(tasktime);
                }
                sql.append(" and check_time >='").append(sdate + " 00:00:00").append("'");
                sql.append(" and check_time <='").append(dqtime).append("'");

            } else if (dates.equals("本月")) {
                String by = new SimpleDateFormat("yyyy-MM").format(new Date());
                sql.append(" and check_time >='").append(by + "-01 00:00:00").append("'");
                sql.append(" and check_time <='").append(dqtime).append("'");
            } else {
                sql.append(" and check_time like '%" + dates + "%'");
            }
            sql.append(" group by date_format(check_time,'%Y-%m-%d')  having tp!='2' ");
            sql.append(" order by checkTime desc ");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysCheckInDate.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：签到时间分页2
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public Page pageCheckInDate2(Integer pageNo, Integer pageSize, String database,
                                 String psnIds, String dates, Map<String, Object> map) {
        String dqtime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Calendar c = Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            StringBuffer sql = new StringBuffer("select date_format(a.check_time,'%Y-%m-%d') as checkTime,a.tp,a.psn_id,b.member_nm as memberName");
            sql.append(" from " + database + ".sys_checkin a left join " + database + ".sys_mem b on a.psn_id=b.member_id where 1=1");
            if (!StrUtil.isNull(psnIds)) {
                if (psnIds.indexOf("全部") >= 0) {
                    if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                        if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                            sql.append(" AND (b.branch_id IN (" + map.get("allDepts") + ") ");
                            sql.append(" OR a.psn_id=" + map.get("mId") + ")");
                        } else {
                            sql.append(" AND b.branch_id IN (" + map.get("allDepts") + ") ");
                        }
                    } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                        sql.append(" AND a.psn_id=" + map.get("mId"));
                    }
                    if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                        sql.append(" AND b.branch_id NOT IN (" + map.get("invisibleDepts") + ") ");
                    }
                } else {
                    sql.append(" and a.psn_id in(" + psnIds + ")");
                }
            }
            if (StrUtil.isNull(dates) || dates.equals("本周")) {
                int weekday = c.get(7) - 2;
                c.add(5, -weekday);
                Date tasktime = c.getTime();
                String sdate = "";
                Date a = df.parse(df.format(tasktime));
                Date b = new Date();
                boolean flag = a.after(b);
                if (flag) {
                    int weekday2 = c.get(7) + 5;
                    c.add(5, -weekday2);
                    Date tasktime2 = c.getTime();
                    sdate = df.format(tasktime2);
                } else {
                    sdate = df.format(tasktime);
                }
                sql.append(" and a.check_time >='").append(sdate + " 00:00:00").append("'");
                sql.append(" and a.check_time <='").append(dqtime).append("'");

            } else if (dates.equals("本月")) {
                String by = new SimpleDateFormat("yyyy-MM").format(new Date());
                sql.append(" and a.check_time >='").append(by + "-01 00:00:00").append("'");
                sql.append(" and a.check_time <='").append(dqtime).append("'");
            } else {
                sql.append(" and a.check_time like '%" + dates + "%'");
            }
            sql.append(" group by a.psn_id  having a.tp!='2' ");
            sql.append(" order by checkTime desc ");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysCheckInDate.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：签到信息集合
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public List<SysCheckInConform> queryCheckInConformLs(String database, Integer psnId, String checkTime) {
        StringBuffer sql = new StringBuffer("select check_time,tp,id as upid,location as locationup");
        sql.append(" from " + database + ".sys_checkin where psn_id=" + psnId + " and check_time like '%" + checkTime + "%'");
        sql.append(" order by check_time asc ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCheckInConform.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：签到信息集合
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public List<SysCheckInConform> queryCheckInConformLs2(String database, Integer psnId, String dates) {
        String dqtime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Calendar c = Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            StringBuffer sql = new StringBuffer("select check_time,tp,id as upid,location as locationup");
            sql.append(" from " + database + ".sys_checkin where psn_id=" + psnId + " ");
            if (StrUtil.isNull(dates) || dates.equals("本周")) {
                int weekday = c.get(7) - 2;
                c.add(5, -weekday);
                Date tasktime = c.getTime();
                String sdate = "";
                Date a = df.parse(df.format(tasktime));
                Date b = new Date();
                boolean flag = a.after(b);
                if (flag) {
                    int weekday2 = c.get(7) + 5;
                    c.add(5, -weekday2);
                    Date tasktime2 = c.getTime();
                    sdate = df.format(tasktime2);
                } else {
                    sdate = df.format(tasktime);
                }
                sql.append(" and check_time >='").append(sdate + " 00:00:00").append("'");
                sql.append(" and check_time <='").append(dqtime).append("'");

            } else if (dates.equals("本月")) {
                String by = new SimpleDateFormat("yyyy-MM").format(new Date());
                sql.append(" and check_time >='").append(by + "-01 00:00:00").append("'");
                sql.append(" and check_time <='").append(dqtime).append("'");
            } else {
                sql.append(" and check_time like '%" + dates + "%'");
            }
            sql.append(" order by check_time asc ");

            return this.daoTemplate.queryForLists(sql.toString(), SysCheckInConform.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id获取签到信息
     */
    public SysCheckIn queryCheckById(Integer id, String database) {
        String sql = " select c.id,c.job_content,c.location,c.remark,c.check_time,c.longitude,c.latitude,(case when c.tp='1-2' then '下班' else '上班' end) as tp,m.member_nm from " + database + ".sys_checkin c left join " + database + ".sys_mem m on c.psn_id=m.member_id where c.id=?";
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysCheckIn.class, id);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    public SysCheckIn queryCheckById1(Integer id, String database) {
        String sql = "select * from " + database + ".sys_checkin where id =? ";
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysCheckIn.class, id);
        } catch (DaoException e) {
            throw new DaoException(e);
        }

    }

    //查询图片
    public List<SysCheckinPic> queryPics(Integer id, String database) {
        String sql = "select pic,pic_mini from " + database + ".sys_checkin_pic where checkin_id=?";
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCheckinPic.class, id);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id，当前日期，下班查询记录是否存在
     *
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    public SysCheckIn queryCheckBydqdate(String database, Integer psnId) {
        String dqdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String sql = " select * from " + database + ".sys_checkin where psn_id=" + psnId + " and check_time like '%" + dqdate + "%' order by check_time desc limit 0,1";
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysCheckIn.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id，下班查询记录是否存在
     *
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    public SysCheckIn queryCheckBydqdate2(String database, Integer psnId) {
        String sql = " select * from " + database + ".sys_checkin where psn_id=" + psnId + " order by check_time desc limit 0,1";
        try {
            return this.daoTemplate.queryForObj(sql, SysCheckIn.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据用户id，日期，查询上下班记录
     */
    public List<SysCheckIn> queryCheckInList(String database, Integer mid, String date){
        try {
            String eDate = DateTimeUtil.dateTimeAddToStr(date, 5, 1, "yyyy-MM-dd");

            String sql = "select a.* from " + database + ".sys_checkin a where 1 = 1 ";
            sql += " and a.psn_id = " + mid;
            sql += " and a.check_time >= '" + date +"'";
            sql += " and a.check_time < '" + eDate +"'";
            sql += " order by a.check_time asc ";
            return this.daoTemplate.queryForLists(sql, SysCheckIn.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
