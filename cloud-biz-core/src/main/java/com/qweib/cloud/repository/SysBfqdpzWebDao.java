package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.MemberBranchSqlUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysBfqdpzWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加拜访签到拍照
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public int addBfqdpz(SysBfqdpz bfqdpz, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_bfqdpz", bfqdpz);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改拜访签到拍照
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public int updateBfqdpz(SysBfqdpz bfqdpz, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bfqdpz.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_bfqdpz", bfqdpz, whereParam, "id");
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
     * 说明：获取拜访签到拍照信息
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public SysBfqdpz queryBfqdpzOne(String database, Integer mid, Integer cid, String qddate) {
        try {
            String sql = "select * from " + database + ".sys_bfqdpz where mid=? and cid=? and qddate=?";
            return this.daoTemplate.queryForObj(sql, SysBfqdpz.class, mid, cid, qddate);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取拜访签到拍照上次信息
     *
     * @创建：作者:llp 创建时间：2016-3-30
     * @修改历史： [序号](llp 2016 - 3 - 30)<修改说明>
     */
    public SysBfqdpz queryBfqdpzOneSc(String database, Integer mid, Integer cid) {
        try {
            String sql = "select * from " + database + ".sys_bfqdpz where mid=? and cid=? and qddate!='" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "' order by id desc limit 0,1";
            return this.daoTemplate.queryForObj(sql, SysBfqdpz.class, mid, cid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询拜访客户信息
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    public Page queryBfqdpzPage(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String qddate, String mids) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime,b.kh_nm,b.khdj_nm,c.member_nm,(select branch_name from " + database + ".sys_depart where branch_id=c.branch_id) as branch_name from " + database + ".sys_bfqdpz a " +
                "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
//		if(!StrUtil.isNull(zt)){
//			if(zt==2){
//				sql.append(" and a.mid in(select y.member_id from "+database+".sys_mem y left join "+database+".sys_depart z on y.branch_id=z.branch_id where " +
//						"(z.branch_path like '%-"+branchId+"-%' or y.member_id="+memId+"))");
//			}else{
//				sql.append(" and a.mid="+memId+"");
//			}
//		}
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
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (b.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(qddate)) {
            sql.append(" and a.qddate like '%" + qddate + "%'");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfqdpz.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询拜访客户信息2
     *
     * @创建：作者:llp 创建时间：2017-8-3
     * @修改历史： [序号](llp 2017 - 8 - 3)<修改说明>
     */
    public Page queryBfqdpzPage2(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String mids, String sdate, String edate, Integer cid, Integer id) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime,b.kh_nm,b.khdj_nm,a.longitude,a.latitude,b.longitude as longitude3,b.latitude as latitude3,a.address,c.member_nm,c.member_head,(select branch_name from " + database + ".sys_depart where branch_id=c.branch_id) as branch_name from " + database + ".sys_bfqdpz a " +
                "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
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
        if (!StrUtil.isNull(sdate)) {
            sql.append(" and a.qddate >='").append(sdate).append("'");
        }
        if (!StrUtil.isNull(edate)) {
            sql.append(" and a.qddate <='").append(edate).append("'");
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (b.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(cid)) {
            sql.append(" and a.cid=" + cid + "");
        }
        if (!StrUtil.isNull(id)) {
            sql.append(" and a.id<" + id + "");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfqdpzJl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryBfqdpzPage3(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String mids, String sdate, String edate, Integer cid, Integer id) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime,b.kh_nm,b.khdj_nm,a.longitude,a.latitude,b.longitude as longitude3,b.latitude as latitude3,a.address,c.member_nm,c.member_head,(select branch_name from " + database + ".sys_depart where branch_id=c.branch_id) as branch_name from " + database + ".sys_bfqdpz a " +
                "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
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
        if (!StrUtil.isNull(sdate)) {
            sql.append(" and a.qddate >='").append(sdate).append("'");
        }
        if (!StrUtil.isNull(edate)) {
            sql.append(" and a.qddate <='").append(edate).append("'");
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (b.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(cid)) {
            sql.append(" and a.cid=" + cid + "");
        }
        if (!StrUtil.isNull(id)) {
            sql.append(" and a.id<" + id + "");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql2(sql.toString(), page, limit, SysBfqdpzJl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //统计商家数
    public int queryBfqdpzWebCount(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String mids, String sdate, String edate, Integer cid) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select count(*) from (select count(*) from " + database + ".sys_bfqdpz a " +
                    "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
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
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and a.qddate >='").append(sdate).append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and a.qddate <='").append(edate).append("'");
            }
            if (!StrUtil.isNull(khNm)) {
                sql.append(" and (b.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%')");
            }
            if (!StrUtil.isNull(cid)) {
                sql.append(" and a.cid=" + cid + "");
            }
            sql.append(" group by a.cid ) s");
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryBfqdpzWebCount2(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String mids, String sdate, String edate, Integer cid) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select count(a.cid) from " + database + ".sys_bfqdpz a " +
                    "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
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
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and a.qddate >='").append(sdate).append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and a.qddate <='").append(edate).append("'");
            }
            if (!StrUtil.isNull(khNm)) {
                sql.append(" and (b.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%')");
            }
            if (!StrUtil.isNull(cid)) {
                sql.append(" and a.cid=" + cid + "");
            }
            sql.append(" group by a.cid");
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysBfqdpzJl queryBfqdpzBy4cs(String database, Map<String, Object> map, String mids) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.qddate from " + database + ".sys_bfqdpz a " +
                    "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
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
            sql.append(" order by a.id desc limit 0,1");
            return this.daoTemplate.queryForObj(sql.toString(), SysBfqdpzJl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据拜访id获取拜访签到拍照信息
     *
     * @创建：作者:llp 创建时间：2016-4-12
     * @修改历史： [序号](llp 2016 - 4 - 12)<修改说明>
     */
    public SysBfqdpz queryBfqdpzById(String database, Integer id) {
        try {
            String sql = "select * from " + database + ".sys_bfqdpz where id=?";
            return this.daoTemplate.queryForObj(sql, SysBfqdpz.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysBfqdpzJl queryBfqdpzById2(String database, Integer id) {
        try {
            String sql = "select a.id,a.mid,a.cid,a.qddate,a.qdtime,b.kh_nm,b.khdj_nm,a.longitude,a.latitude,a.address,c.member_nm,c.member_head,(select branch_name from " + database + ".sys_depart where branch_id=c.branch_id) as branch_name from " + database + ".sys_bfqdpz a " +
                    "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where a.id=?";
            return this.daoTemplate.queryForObj(sql, SysBfqdpzJl.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据客户，业务，时间获取拜访签到拍照信息
     *
     * @创建：作者:llp 创建时间：2016-8-11
     * @修改历史： [序号](llp 2016 - 8 - 11)<修改说明>
     */
    public SysBfqdpz queryBfqdpzBycmd(String database, Integer mid, Integer cid, String date) {
        try {
            String sql = "select * from " + database + ".sys_bfqdpz where mid=? and cid=? and qddate=?";
            return this.daoTemplate.queryForObj(sql, SysBfqdpz.class, mid, cid, date);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询拜访客户信息
     *
     * @创建：作者:llp 创建时间：2016-4-12
     * @修改历史： [序号](llp 2016 - 4 - 12)<修改说明>
     */
    public Page queryBfqdpzPageBymcid(String database, Integer page, Integer limit, Map<String, Object> map, Integer cid) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime,b.kh_nm,c.member_nm,(select branch_name from " + database + ".sys_depart where branch_id=c.branch_id) as branch_name from " + database + ".sys_bfqdpz a " +
                "left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1");
        sql.append(" and a.cid=" + cid + " ");
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
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfqdpz.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询拜访评论
     */
    public List<SysBfcomment> queryBfCommentList(Integer bfId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_nm,m.member_id,tm.comment_id,tm.content,tm.voice_time from " + datasource + ".sys_bfcomment tm ");
        sql.append(" left join " + datasource + ".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where bf_id=").append(bfId).append(" and belong_id='0' ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysBfcomment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询拜访回复
     */
    public List<SysBfcomment> queryBfRcList(Integer commentId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,tm.content,tm.belong_id,tm.rc_nm,tm.comment_id,tm.voice_time,tm.comment_time from " + datasource + ".sys_bfcomment tm ");
        sql.append(" left join " + datasource + ".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where belong_id=").append(commentId);
        try {
            return daoTemplate.queryForLists(sql.toString(), SysBfcomment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询拜访发布人信息
     */
    public SysMemDTO findMemberByQdpz(Integer bfId, String datasource) {
        StringBuffer sql = new StringBuffer(" select m.member_id,m.member_mobile from " + datasource + ".sys_bfqdpz t left join ");
        sql.append(datasource + ".sys_mem m on t.mid=m.member_id where t.id=").append(bfId);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMemDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 说明：根据评论id查询
     *
     * @创建：作者:llp 创建时间：2017-8-9
     * @修改历史： [序号](llp 2017 - 8 - 9)<修改说明>
     */
    public SysBfcomment queryBfCommentById(Integer commentId, String datasource) {
        StringBuffer sql = new StringBuffer("select member_id,comment_id from " + datasource + ".sys_bfcomment ");
        sql.append(" where comment_id=").append(commentId);
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysBfcomment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加评论/回复
     *
     * @创建：作者:llp 创建时间：2017-8-9
     * @修改历史： [序号](llp 2017 - 8 - 9)<修改说明>
     */
    public int addBfcomment(SysBfcomment bfcomment, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_bfcomment", bfcomment);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除评论,回复
     *
     * @创建：作者:llp 创建时间：2017-8-9
     * @修改历史： [序号](llp 2017 - 8 - 9)<修改说明>
     */
    public void deleteBfComment(Integer commentId, String datasource) {
        String sql = "delete from " + datasource + ".sys_bfcomment where comment_id=" + commentId + " or belong_id=" + commentId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询拜访查询（合并打卡查询）
     */
    public Page queryBfqdpzPageNew(String database, Map<String, Object> map, Integer page, Integer limit, String khNm, String mids, String sdate, String edate, Integer cid, Integer id) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*, ");
        sql.append(" c.kh_nm,c.khdj_nm,c.longitude as longitude3,c.latitude as latitude3,m.member_nm,m.member_head,");
        sql.append(" (select branch_name from " + database + ".sys_depart where branch_id = m.branch_id) as branch_name ");
        sql.append(" from (");
        sql.append(" select id, mid, cid, qddate, qdtime, CONCAT(qddate,' ',qdtime) time, longitude, latitude, address, 0 voice_time,'' bcbfzj, 1 type  from " + database + ".sys_bfqdpz");
        sql.append(" union all");
        sql.append(" select id, mid, 0 cid, '', '', sign_time as time, longitude, latitude, address, voice_time, remarks as bcbfzj, 2 type from " + database + ".sys_sign_in");
        sql.append(" ) as a");
//        sql.append("select a.id, a.mid, a.cid, a.qddate, a.qdtime, a.longitude, a.latitude,a.address,");
//        sql.append(" from " + database + ".sys_bfqdpz a ");
        sql.append(" left join " + database + ".sys_customer c on a.cid = c.id ");
        sql.append(" left join " + database + ".sys_mem m on a.mid = m.member_id ");
        sql.append(" where 1=1");
        sql.append(MemberBranchSqlUtil.getMemberBranchAppendSql2(mids, map));
        if (!StrUtil.isNull(sdate)) {
            sql.append(" and a.time >='").append(sdate).append("'");
        }
        if (!StrUtil.isNull(edate)) {
            sql.append(" and a.time <='").append(edate + " 23:59:59").append("'");
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (c.kh_nm like '%" + khNm + "%' or m.member_nm like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(cid)) {
            sql.append(" and a.cid=" + cid + "");
        }
        if (!StrUtil.isNull(id)) {
            sql.append(" and a.id<" + id + "");
        }
        sql.append(" order by time desc");
        try {
            return this.daoTemplate.queryForPageByMySql2(sql.toString(), page, limit, SysBfqdpzJl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询"打卡查询明细"：图片和语音
     */
    public List<SysSignDetail> querySignInDetailList (String database, Integer id) {
        try {
            String sql = "select * from " + database + ".sys_sign_detail where sign_id = " + id.toString();
            return this.daoTemplate.queryForLists(sql, SysSignDetail.class);
        }catch (Exception e){
            throw new DaoException(e);
        }
    }



}
