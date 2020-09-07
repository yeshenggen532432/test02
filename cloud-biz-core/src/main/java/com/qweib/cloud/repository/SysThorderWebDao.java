package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysThorder;
import com.qweib.cloud.core.domain.SysThorderDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class SysThorderWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addThorder(SysThorder thorder, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_thorder", thorder);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateThorder(SysThorder thorder, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", thorder.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_thorder", thorder, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Integer getAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysThorder queryThorderOne(String database, Integer mid, Integer cid, String oddate) {
        try {
            String sql = "select * from " + database + ".sys_thorder where mid=? and cid=? and oddate=? and order_lb='拜访单'";
            return this.daoTemplate.queryForObj(sql, SysThorder.class, mid, cid, oddate);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysThorder queryThorderOne2(String database, Integer id) {
        try {
            String sql = "select * from " + database + ".sys_thorder where id=?";
            return this.daoTemplate.queryForObj(sql, SysThorder.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addThorderDetail(SysThorderDetail bforderDetail, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_thorder_detail", bforderDetail);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysThorderDetail> queryThorderDetail(String database, Integer orderId) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append("select a.*,b.ware_nm,b.ware_gg, b.hs_num, b.ware_dw as max_unit, b.min_unit, b.max_unit_code, b.min_unit_code from " + database + ".sys_thorder_detail a");
            sb.append(" left join " + database + ".sys_ware b on a.ware_id=b.ware_id");
            sb.append(" where a.order_id=" + orderId);
//            String sql = "select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_thorder_detail a left join " + database + ".sys_ware b on a.ware_id=b.ware_id where a.order_id=" + orderId;
            return this.daoTemplate.queryForLists(sb.toString(), SysThorderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteThorderDetail(String database, Integer orderId) {
        String sql = "delete from " + database + ".sys_thorder_detail where order_id=" + orderId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryDhorder(String database, Map<String, Object> map, Integer page, Integer limit, String kmNm, String sdate, String edate, String mids) {
        Calendar c = Calendar.getInstance();
        String dqtime = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.id,a.mid,a.order_no,b.kh_nm,c.member_nm,a.order_zt,a.oddate,a.odtime,a.shr,a.tel,a.cjje from " + database + ".sys_thorder a");
            sql.append(" left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
//			if(!StrUtil.isNull(zt)){
//				if(zt==2){
//					sql.append(" and a.mid in(select y.member_id from "+database+".sys_mem y left join "+database+".sys_depart z on y.branch_id=z.branch_id where " +
//							"(z.branch_path like '%-"+branchId+"-%' or y.member_id="+memId+"))");
//				}else{
//					sql.append(" and a.mid="+memId+"");
//				}
//			}
            if (!StrUtil.isNull(mids)) {
                sql.append(" AND a.mid in (" + mids + ")");
            } else {
                if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                    if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                        sql.append(" AND (c.branch_id IN (" + map.get("allDepts") + ") ");
                        sql.append(" OR a.mid=" + map.get("mId") + ")");
                    } else {
                        sql.append(" AND c.branch_id IN (" + map.get("allDepts") + ") ");
                    }
                } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                    sql.append(" AND a.mid=" + map.get("mId"));
                }
                if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                    sql.append(" AND c.branch_id NOT IN (" + map.get("invisibleDepts") + ") ");
                }
            }
            if (!StrUtil.isNull(kmNm)) {
                sql.append(" and (b.kh_nm like '%" + kmNm + "%' or c.member_nm like '%" + kmNm + "%')");
            }
//			if(StrUtil.isNull(sdate)||sdate.equals("本周")){
//				int weekday = c.get(7)-2;
//				c.add(5,-weekday);
//				Date tasktime=c.getTime();
//				String sdate1="";
//				Date a = df.parse(df.format(tasktime));
//				Date b=new Date();
//				boolean flag = a.after(b);
//				if(flag){
//					int weekday2 = c.get(7)+5;
//					c.add(5,-weekday2);
//					Date tasktime2=c.getTime();
//					sdate1=df.format(tasktime2);
//				}else{
//					sdate1=df.format(tasktime);
//				}
//				sql.append(" and a.oddate >='").append(sdate1).append("'");
//				sql.append(" and a.oddate <='").append(dqtime).append("'");
//
//			}else if(sdate.equals("本月")){
//				String by=new SimpleDateFormat("yyyy-MM").format(new Date());
//				sql.append(" and a.oddate >='").append(by+"-01").append("'");
//				sql.append(" and a.oddate <='").append(dqtime).append("'");
//			}else{
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and a.oddate >='").append(sdate).append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and a.oddate <='").append(edate).append("'");
            }
            //}
            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysThorder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryOrderDetailCount(String database, Integer orderId) {
        try {
            String sql = "select sum(ware_num) from " + database + ".sys_thorder_detail where order_id=?";
            return this.daoTemplate.queryForObject(sql, new Object[]{orderId}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
