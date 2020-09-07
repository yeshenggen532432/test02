package com.qweib.cloud.repository.company;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 说明：任务表Dao
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
@Repository
public class SysTaskDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加任务
     *
     * @param task
     * @return
     */
    public int addTask(SysTask task, String database) {
        try {
            if (null == task.getPercent()) {
                task.setPercent(0);
            }
            int i = daoTemplate.addByObject(database + ".sys_task", task);
            /*****用于更改id生成方式 by guojr******/
            if (i > 0) {
                return i;
            }
//			if(i>0){
//				return this.daoTemplate.getAutoIdForIntByMySql();
//			}
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return 0;
    }

    /**
     * 根据ID查询任务
     *
     * @param id
     * @return
     */
    public SysTask queryById(Integer id, String database) {
        try {
            StringBuffer sql = new StringBuffer("select task.* ");
            sql.append(" from " + database + ".sys_task task where id=? ");
            return this.daoTemplate.queryForObj(sql.toString(), SysTask.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysTask queryById(Integer id, String database, Integer memId) {
        try {
            StringBuffer sql = new StringBuffer("select task.*,m.member_nm as createByNm,(select GROUP_CONCAT(mem.member_nm) from " + database + ".sys_task_psn psn");
            sql.append(" join sys_mem mem on psn.psn_id = mem.member_id where psn.nid = task.id and psn.psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ")");
            sql.append(" member_nm,(select GROUP_CONCAT(CAST(mem.member_id as char(20))) from " + database + ".sys_task_psn psn");
            sql.append(" join sys_mem mem on psn.psn_id = mem.member_id where psn.nid = task.id and psn.psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ")");
            sql.append(" member_ids,(select GROUP_CONCAT(mem.member_nm) from " + database + ".sys_task_psn psn ");
            sql.append(" join sys_mem mem on psn.psn_id = mem.member_id where psn.nid = task.id and psn.psn_type=" + SysTaskPsn.PSN_FOCUS_ON + ")");
            sql.append(" supervisor,(select GROUP_CONCAT(CAST(mem.member_id as char(20))) from " + database + ".sys_task_psn psn ");
            sql.append(" join sys_mem mem on psn.psn_id = mem.member_id where psn.nid = task.id and psn.psn_type=" + SysTaskPsn.PSN_FOCUS_ON + ")");
            sql.append(" supervisor_ids,(case when (select count(psns.id) from " + database + ".sys_task_psn psns where psns.nid=task.id ");
            sql.append(" and psns.psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + " and psns.psn_id=" + memId + ") >0 then 1 else 0 end) is_member_nm");
            sql.append(" ,(case when (select count(psns.id) from " + database + ".sys_task_psn psns where psns.nid=task.id ");
            sql.append(" and psns.psn_type=" + SysTaskPsn.PSN_FOCUS_ON + " and psns.psn_id=" + memId + ") >0 then 1 else 0 end) is_supervisor");
            sql.append(" from " + database + ".sys_task task left join " + database + ".sys_mem m on task.create_by=m.member_id where task.id=" + id);
            SysTask task = this.daoTemplate.queryForObj(sql.toString(), SysTask.class);
			/*StringBuffer sql2 = new StringBuffer("select GROUP_CONCAT(mem.member_nm)as memberNm,GROUP_CONCAT(CAST(mem.member_id as char)) as ids,GROUP_CONCAT(mem.member_nm) as names from "+database);
			sql2.append(".sys_task_psn psn join sys_mem mem on psn.psn_id = mem.member_id where psn.nid = "+id+" and psn.psn_type=");
			Map<String,Object> map = daoTemplate.queryForMap(sql2.toString()+SysTaskPsn.PSN_RESPONSIBILITY);//责任人
			Map<String,Object> map2 = daoTemplate.queryForMap(sql2.toString()+SysTaskPsn.PSN_FOCUS_ON);//关注人
			task.setMemberIds(map.get("ids").toString());
			task.setMemberNm(map.get("names").toString());
			task.setSupervisorIds(map2.get("ids").toString());
			task.setSupervisor(map2.get("names").toString());*/
            return task;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改任务
     *
     * @param task
     * @param database
     * @return
     */
    public int updateTask(SysTask task, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", task.getId());
            return this.daoTemplate.updateByObject(database + ".sys_task", task, whereParam, "id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据ID删除任务信息
     *
     * @param i
     */
    public int[] deleteTask(final Integer[] id, String database) {
        try {
            String sql = "delete from " + database + ".sys_task where id = ?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return id.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setObject(1, id[num]);
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public int[] deleteTask(final String[] id, String database) {
        try {
            String sql = "delete from " + database + ".sys_task where id = ?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return id.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setObject(1, id[num]);
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 分页查询任务信息
     *
     * @param title
     * @param pageNo
     * @param pageSize
     * @param type     1 发布人 2 责任人 3 关注人
     * @return
     */
    @Deprecated
    public Page queryPageByTitle(String title, Integer pageNo,
                                 Integer pageSize, String database, Integer state, Integer id, String type) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select *,(case when DATE_FORMAT(overtime,'%Y-%m-%d %H:%i') > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime from (select task.id,task.task_title,DATE_FORMAT(create_time,'%Y-%m-%d %H:%i') createTime,task.percent,act_time,parent_id,end_time,status,(case when act_time is null or act_time ='' then NOW() else act_time end) overtime,");
            sql.append(" (select GROUP_CONCAT(mem.member_nm) from " + database + ".sys_task_psn psn join " + database + ".sys_mem mem on mem.member_id = psn.psn_id");
            sql.append(" where task.id = psn.nid and psn.psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ") member_nm ,");
            sql.append(" (case when (select GROUP_CONCAT(CAST(id as char(20))) from " + database + ".sys_task t where t.parent_id =task.id) is null then 0 else 1 end) child ,");
            sql.append(" (case when (select count(*) from " + database + ".sys_task ts where 1=1 ");
            if (!StrUtil.isNull(state) && state <= 3) {
                sql.append(" and status = ").append(state);
            }
            sql.append(" and ( 1=1");
            if (!StrUtil.isNull(id)) {
                sql.append(" and ts.id in (select nid from " + database + ".sys_task_psn where psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + " and psn_id=" + id + ")");
            }
            sql.append("  or (ts.create_by = ").append(id).append(" and parent_id is null)");
            if (!StrUtil.isNull(title)) {
                sql.append(" and task.task_title like '%" + title + "%'");
            }
            sql.append(" ) and ts.id = task.parent_id)>0 then 1 else 0 end) isshow");
            if (!StrUtil.isNull(title)) {
                sql.append(",(select count(1) from " + database + ".sys_task dd left join " + database + ".sys_task_psn gg on dd.id=gg.nid where (gg.psn_type=" + SysTaskPsn.PSN_FOCUS_ON);
                sql.append(" and psn_id=" + id + ") and (gg.psn_type!=" + SysTaskPsn.PSN_RESPONSIBILITY + " and psn_id=" + id + ") and (dd.create_by!=" + id + " and parent_id is null) and dd.id=task.id) isAct ");
            }
            sql.append(" from " + database + ".sys_task task where 1=1");
            if (!StrUtil.isNull(state) && state <= 3) {
                sql.append(" and status = ").append(state);
            }
            sql.append(" and ( 1=1");
            sql.append(" and task.id in (select nid from " + database + ".sys_task_psn where 1=1 ");
            if (StrUtil.isNull(type)) {
                sql.append("  and (task.create_by =" + id + " and parent_id is null) ");
                if (3 != state) {//草稿箱  "" and
                    sql.append("  or ( psn_id=" + id);
                    sql.append(" and psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ") ");
                    sql.append(" or (  psn_id=" + id);
                    sql.append(" and psn_type=" + SysTaskPsn.PSN_FOCUS_ON + ") ");
                }
            } else {//选择责任人或关注人或发布者(已完成的状态才有该值)
                if ("1".equals(type)) {//发布人
                    sql.append("  and (task.create_by =" + id + " and parent_id is null) ");
                } else if ("2".equals(type)) {//责任人
                    sql.append("  and ( psn_id=" + id);
                    sql.append(" and psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ") ");
                } else if ("3".equals(type)) {//关注人
                    sql.append(" and (  psn_id=" + id);
                    sql.append(" and psn_type=" + SysTaskPsn.PSN_FOCUS_ON + ") ");
                }
            }
            sql.append(")) ");
            if (!StrUtil.isNull(title)) {
                sql.append(" and task.task_title like '%" + title + "%'");
            }
            sql.append(" ) t where isshow = 0 ");
//			sql.append(" and parent_id is NULL ");
            if (2 == state) {//已完成
                sql.append(" order by act_time desc ");
            } else {
                sql.append(" order by id desc ");
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 分页查询任务信息(全部相关任务)
     *
     * @param pageNo   第几页
     * @param pageSize 每页数量
     * @param database 数据库名
     * @param status   状态 1草稿 2进行中	3已完成
     * @param id       人员ID
     * @return
     */
    public Page queryPageByTitle(Integer pageNo, Integer pageSize, String database, Integer status, Integer id) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT distinct x.*,m.member_nm, ");
        sql.append(" (case when DATE_FORMAT((case when act_time is null or act_time ='' then NOW() else act_time end),'%Y-%m-%d %H:%i') > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime, ");
        sql.append(" (case when (SELECT GROUP_CONCAT(CAST(id as char(50))) FROM " + database + ".sys_task t WHERE t.parent_id = x.id) is null then 0 else 1 end) child ");
        sql.append("  FROM ( ");
        sql.append("  SELECT task.* ");
        sql.append("  FROM " + database + ".sys_task task ");
        sql.append("  WHERE task.create_by = " + id + " AND task.status = " + status + " AND task.parent_id IS NULL ");
        sql.append("  union ");
        sql.append("  SELECT task.* ");
        sql.append("  FROM " + database + ".sys_task task, " + database + ".sys_task_psn psn ");
        sql.append("  WHERE task.id = psn.nid AND psn.psn_id = " + id + " AND task.status = " + status + " AND task.parent_id IS NULL ");
        sql.append("  union ");
        sql.append("  SELECT t.* ");
        sql.append("  FROM " + database + ".sys_task t ");
        sql.append("  WHERE t.id IN ( ");
        sql.append("  SELECT task.parent_id  ");
        sql.append("  FROM " + database + ".sys_task task, " + database + ".sys_task_psn psn ");
        sql.append("  WHERE task.id = psn.nid AND (psn.psn_id = " + id + " or task.create_by=" + id + ") AND task.status = " + status + " AND task.parent_id IS NOT NULL)) x ");

        sql.append(" ," + database + ".sys_task_psn p ," + database + ".sys_mem m where x.id=p.nid and p.psn_id=m.member_id and p.psn_type=1 ");
        sql.append(" order by x.create_time desc ");
        return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
    }

    //分页查询任务信息(发布者角色)
    public Page queryPageForCreateby(Integer pageNo, Integer pageSize, String database, Integer status, Integer id) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT distinct x.*,m.member_nm, ");
        sql.append(" (case when DATE_FORMAT((case when act_time is null or act_time ='' then NOW() else act_time end),'%Y-%m-%d %H:%i') > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime, ");
        sql.append(" (case when (SELECT GROUP_CONCAT(CAST(id as char(50))) FROM " + database + ".sys_task t WHERE t.parent_id = x.id) is null then 0 else 1 end) child ");
        sql.append("  FROM ( ");
        sql.append("  SELECT task.* ");
        sql.append("  FROM " + database + ".sys_task task ");
        sql.append("  WHERE task.create_by = " + id + " AND task.status = " + status + " AND task.parent_id IS NULL ");
        sql.append("  union ");
        sql.append("  SELECT t.* ");
        sql.append("  FROM " + database + ".sys_task t ");
        sql.append("  WHERE t.id IN ( ");
        sql.append("  SELECT task.parent_id  ");
        sql.append("  FROM " + database + ".sys_task task, " + database + ".sys_task_psn psn ");
        sql.append("  WHERE task.id = psn.nid AND  task.create_by=" + id + " AND task.status = " + status + " AND task.parent_id IS NOT NULL)) x ");

        sql.append(" ," + database + ".sys_task_psn p ," + database + ".sys_mem m where x.id=p.nid and p.psn_id=m.member_id and p.psn_type=1 ");
        sql.append(" order by x.create_time desc ");
        return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
    }

    //分页查询任务信息(执行人或关注人角色)
    public Page queryPageForPsnId(Integer pageNo, Integer pageSize, String database, Integer status, Integer id, String tp) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT distinct x.*,m.member_nm, ");
        sql.append(" (case when DATE_FORMAT((case when act_time is null or act_time ='' then NOW() else act_time end),'%Y-%m-%d %H:%i') > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime, ");
        sql.append(" (case when (SELECT GROUP_CONCAT(CAST(id as char(50))) FROM " + database + ".sys_task t WHERE t.parent_id = x.id) is null then 0 else 1 end) child ");
        sql.append("  FROM ( ");
        sql.append("  SELECT task.* ");
        sql.append("  FROM " + database + ".sys_task task, " + database + ".sys_task_psn psn ");
        sql.append("  WHERE task.id = psn.nid AND psn.psn_id = " + id + " AND psn.psn_type = " + tp + " AND task.status = " + status + " AND task.parent_id IS NULL ");
        sql.append("  union ");
        sql.append("  SELECT t.* ");
        sql.append("  FROM " + database + ".sys_task t ");
        sql.append("  WHERE t.id IN ( ");
        sql.append("  SELECT task.parent_id  ");
        sql.append("  FROM " + database + ".sys_task task, " + database + ".sys_task_psn psn ");
        sql.append("  WHERE task.id = psn.nid AND psn.psn_id = " + id + " AND psn.psn_type = " + tp + " AND task.status = " + status + " AND task.parent_id IS NOT NULL)) x ");

        sql.append(" ," + database + ".sys_task_psn p ," + database + ".sys_mem m where x.id=p.nid and p.psn_id=m.member_id and p.psn_type=1 ");
        sql.append(" order by x.create_time desc ");
        return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
    }

    /**
     * @param searchContent
     * @param pageNo
     * @param pageSize
     * @param datasource
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-5-19
     * @see 查询任务(包括已办、未办、草稿)
     */
    public Page queryModelTask(String searchContent, Integer pageNo,
                               Integer pageSize, String datasource, Integer memId) {
        StringBuffer sql = new StringBuffer(" select distinct t.id,t.task_title,t.percent,parent_id,status,(case when (case when act_time is null or act_time ='' then NOW() else act_time end) > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime ");
//		sql.append(" (case when (select GROUP_CONCAT(CAST(id as char)) from "+datasource+".sys_task t where t.parent_id =t.id) is null then 0 else 1 end) child ");
        sql.append(" from " + datasource + ".sys_task t left join " + datasource + ".sys_task_psn psn on t.id=psn.nid left join " + datasource + ".sys_mem m on psn.psn_id=m.member_id ");
//		sql.append(" where psn.psn_type=1 and psn and task_title like '%"+searchContent+"%' ");
        sql.append(" where (((status=1 or status=2) and (psn_id=" + memId + " or create_by=" + memId + ")) or (status=3 and t.create_by=" + memId + " )) and task_title like '%" + searchContent + "%' ");
        sql.append(" order by id desc ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return null;
    }

    public Page queryPageById(Integer taskId, Integer pageNo, Integer pageSize,
                              String database, Integer state) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select task.id,task.task_title,task.percent,act_time,DATE_FORMAT(create_time,'%Y-%m-%d %H:%i') createTime,(case when (case when act_time is null or act_time ='' then DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i') else DATE_FORMAT(act_time,'%Y-%m-%d %H:%i') end)>DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') then 1 else 0 end) isovertime,");
            sql.append(" (select GROUP_CONCAT(mem.member_nm) from " + database + ".sys_task_psn psn join " + database + ".sys_mem mem on mem.member_id = psn.psn_id");
            sql.append(" where task.id = psn.nid and psn.psn_type=" + SysTaskPsn.PSN_RESPONSIBILITY + ") member_nm ,");
            sql.append(" (case when (select id from " + database + ".sys_task t where t.parent_id =task.id) is null then 0 else 1 end) child ");
            sql.append(" from " + database + ".sys_task task where task.parent_id = ").append(taskId);
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    public List<SysTask> queryChild(Integer taskId, String database) {
        try {
            String sql = "select id from " + database + ".sys_task where parent_id = ?";
            return daoTemplate.queryForLists(sql, SysTask.class, taskId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 添加
     *
     * @param feed
     * @param database
     * @return
     */
    public int addTask(SysTaskFeedback feed, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(database + ".sys_task_feedback", feed);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据任务ID修改状态
     *
     * @param feed
     * @param database
     * @param state
     */
    public Integer updateState(Integer taskId, String database, Integer state, String date) {
        try {

            String sql = "update " + database + ".sys_task set status=?,act_time=? where id=? ";
            return this.daoTemplate.update(sql, state, date, taskId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }
	/*public void updateState(final String[] lists, String database,final Integer state) {
		try{
			String sql = "update "+database+".sys_task set status =? where id = ?";
			for (String id : lists) {
				daoTemplate.update(sql, state,Integer.parseInt(id));
			}
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return lists.length;
				}

				public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, state);
					pre.setInt(2, Integer.parseInt(lists[num]));
				}
			};
			daoTemplate.batchUpdate(sql.toUpperCase(), setter);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}*/

    public void updatetStates(final List<Integer> lists, String database, final Integer state) {
        try {
            String sql = "update " + database + ".sys_task set status =? where id = ?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return lists.size();
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, state);
                    pre.setInt(2, lists.get(num));
                }
            };
            daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据任务ID查询所有子任务
     *
     * @param feed
     * @param database
     * @param state
     */
    public List<SysTask> queryForListByPid(Integer taskId, String database) {
        try {
            String sql = "select * from " + database + ".sys_task where parent_id = ?";
            return this.daoTemplate.queryForLists(sql, SysTask.class, taskId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /***
     * 根据任务ID获取责任人和关注人
     * @param taskId
     * @param dateBase
     * @return
     */
    public Map<String, Object> queryByMember(Integer taskId, String database, Integer psnType, Integer focus) {
        try {
            String info = " from " + database + ".sys_task_psn a left join " + database + ".sys_mem b on a.psn_id=b.member_id where a.nid =task.id and a.psn_type =" + focus;
            StringBuffer sql = new StringBuffer();
            sql.append(" select GROUP_CONCAT(CAST(mem.member_id as char(20))) ids,GROUP_CONCAT(mem.member_mobile) tels,task_title ");
            if (null != focus) {
                sql.append(",(select GROUP_CONCAT(CAST(b.member_id as char(20))) " + info + " ) idsfocus ");
                sql.append(",(select GROUP_CONCAT(b.member_mobile) " + info + " ) telsfocus ");
            }
            sql.append(" from " + database + ".sys_task task ");
            sql.append(" join " + database + ".sys_task_psn psn on  task.id = psn.nid");
            sql.append(" join " + database + ".sys_mem mem on psn.psn_id=mem.member_id");
            sql.append(" where task.id = ").append(taskId);
            sql.append(" and psn.psn_type = ").append(psnType);
//			sql.append(" and (psn.psn_type = ").append(psnType).append(" or psn.psn_type =").append(SysTaskPsn.PSN_FOCUS_ON).append(") ");
            return this.daoTemplate.queryForMap(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //pc端根据任务ID获取责任人和关注人
    public Map<String, Object> queryByMember2(Integer taskId, String database) {
        StringBuffer sql = new StringBuffer("select GROUP_CONCAT(CAST(t.member_id as char(50))) ids,GROUP_CONCAT(t.member_mobile) tels,");
        sql.append("GROUP_CONCAT(concat(t.idsfocus,'-')) idsfocus,GROUP_CONCAT(concat(t.telsfocus,'-')) telsfocus,");
        sql.append("GROUP_CONCAT(t.task_title) titles,GROUP_CONCAT(CAST(t.id as char(50))) taskids ");
        sql.append("from (select m.member_id,m.member_mobile,task.id,task.task_title,task.task_path,");
        sql.append("(select GROUP_CONCAT(CAST(b.member_id as char(20))) from " + database + ".sys_task_psn a left join " + database + ".sys_mem b on a.psn_id=b.member_id where a.nid =task.id and a.psn_type =2 ) idsfocus ,");
        sql.append("(select GROUP_CONCAT(b.member_mobile)  from " + database + ".sys_task_psn a left join " + database + ".sys_mem b on a.psn_id=b.member_id where a.nid =task.id and a.psn_type =2 ) telsfocus ");
        sql.append("from " + database + ".sys_task task," + database + ".sys_task_psn psn ," + database + ".sys_mem m ");
        sql.append("where task.id=psn.nid and psn.psn_id=m.member_id and psn.psn_type=1) t ");
        sql.append("where t.task_path like '-" + taskId + "-%'");
        try {
//			String info = " from "+database+".sys_task_psn a left join "+database+".sys_mem b on a.psn_id=b.member_id where a.nid =task.id and a.psn_type ="+focus;
//			StringBuffer sql = new StringBuffer();
//			sql.append(" select GROUP_CONCAT(CAST(mem.member_id as char(20))) ids,GROUP_CONCAT(mem.member_mobile) tels ");
//			if(null!=focus){
//				sql.append(",(select GROUP_CONCAT(CAST(b.member_id-task.id as char(20))) "+info+" ) idsfocus ");
//				sql.append(",(select GROUP_CONCAT(b.member_mobile) "+info+" ) telsfocus ");
//			}
//			sql.append(",GROUP_CONCAT(CAST(task.task_title as char(255))) titles,GROUP_CONCAT(CAST(task.id as char(20))) taskids ");
//			sql.append(" from "+database+".sys_task task ");
//			sql.append(" join "+database+".sys_task_psn psn on  task.id = psn.nid");
//			sql.append(" join "+database+".sys_mem mem on psn.psn_id=mem.member_id");
//			sql.append(" where task.task_path like '-").append(taskId).append("-%' ");
//			sql.append(" and psn.psn_type = ").append(psnType);
////			sql.append(" and (psn.psn_type = ").append(psnType).append(" or psn.psn_type =").append(SysTaskPsn.PSN_FOCUS_ON).append(") ");
            return this.daoTemplate.queryForMap(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /***
     * 根据任务ID获取责发布人和关注人
     * @param taskId
     * @param dateBase
     * @return
     */
    public Map<String, Object> querycreatebyfocus(Integer taskId, String database, Integer focus) {
        try {
            String info = " from " + database + ".sys_task_psn a left join " + database + ".sys_mem b on a.psn_id=b.member_id where a.nid =task.id and a.psn_type =" + focus;
            StringBuffer sql = new StringBuffer();
            sql.append(" select GROUP_CONCAT(CAST(mem.member_id as char(20))) ids,GROUP_CONCAT(mem.member_mobile) tels,task_title ");
            if (null != focus) {
                sql.append(",(select GROUP_CONCAT(CAST(b.member_id as char(20))) " + info + " ) idsfocus ");
                sql.append(",(select GROUP_CONCAT(b.member_mobile) " + info + " ) telsfocus ");
            }
            sql.append(" from " + database + ".sys_task task ");
            sql.append(" join " + database + ".sys_mem mem on task.create_by=mem.member_id");
            sql.append(" where task.id = ").append(taskId);
//			sql.append(" and (psn.psn_type = ").append(psnType).append(" or psn.psn_type =").append(SysTaskPsn.PSN_FOCUS_ON).append(") ");
            return this.daoTemplate.queryForMap(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 任务催办
     *
     * @param id
     * @param msg
     */
    public void addMsg(final String[] id, final SysTaskMsg msg, String database) {
        String sql = "insert into " + database + ".sys_task_msg(psn_id,remind_time,nid,content,tp) values(?,?,?,?,?)";
        BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
            public int getBatchSize() {
                return id.length;
            }

            public void setValues(PreparedStatement pre, int num)
                    throws SQLException {
                pre.setObject(1, id[num]);
                pre.setObject(2, msg.getRemindTime());
                pre.setObject(3, msg.getNid());
                pre.setObject(4, msg.getContent());
                pre.setObject(5, msg.getTp());
            }
        };
        daoTemplate.batchUpdate(sql.toUpperCase(), setter);
    }

    /**
     * 统计超期任务
     *
     * @param dateBase
     * @param pageNo
     * @param pageSize
     * @return
     */
    public Page queryUnfinished(Integer state, String database, Integer branchId, Integer pageNo,
                                Integer pageSize) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select task.* from (select id,task_title,start_time,end_time,act_time,status,(select GROUP_CONCAT(mem.member_nm) from " + database + ".sys_task_psn psn");
            sql.append(" join " + database + ".sys_mem mem on psn.psn_id = mem.member_id where psn.psn_type=1 and psn.nid");
            sql.append(" = t.id ) member_nm,(case when (act_time is null or act_time ='')");
            sql.append(" then date_format(now(),'%Y-%m-%d %H:%i') else act_time end) new_date from " + database + ".sys_task t)");
            sql.append(" task left join " + database + ".sys_task_psn a on task.id=a.nid left join " + database + ".sys_mem b on a.psn_id=b.member_id where a.psn_type=1 and task.status!=3 and b.branch_id=" + branchId + " and new_date > DATE_FORMAT(end_time,'%Y-%m-%d %H:%i') ");
            if (state == 1) {
                sql.append(" and date_format(start_time,'%Y')=date_format(now(),'%Y') ");
            } else if (state == 2) {
                sql.append(" and date_format(start_time,'%Y-%m')=date_format(now(),'%Y-%m') ");
            } else if (state == 3) {
                sql.append(" and YEARWEEK(date_format(start_time,'%Y-%m-%d')) = YEARWEEK(now()) ");
            }
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 团队执行力统计
     *
     * @param dateBase
     * @param pageNo
     * @param pageSize
     * @return
     */
    public Page queryTeam(Integer state, String database, Integer branchId, Integer pageNo,
                          Integer pageSize) {
        try {
            StringBuffer sqlche = new StringBuffer();
            if (state == 1) {
                sqlche.append(" and date_format(start_time,'%Y')=date_format(now(),'%Y') ");
            } else if (state == 2) {
                sqlche.append(" and date_format(start_time,'%Y-%m')=date_format(now(),'%Y-%m') ");
            } else if (state == 3) {
                sqlche.append(" and YEARWEEK(date_format(start_time,'%Y-%m-%d')) = YEARWEEK(now()) ");
            }
            StringBuffer sql = new StringBuffer();
            sql.append(" select temp.*,ROUND((temp.complete+unfinished)/(temp.complete+unfinished+timeout)*100,2) ratio");
            sql.append(" from (select t.nid,(select mem.member_nm from " + database + ".sys_mem mem where mem.member_id = t.psn_id) ");
            sql.append(" member_nm,(select count(*) count1 from " + database + ".sys_task task join " + database + ".sys_task_psn ps on");
            sql.append(" task.id = ps.nid where task.act_time<=DATE_FORMAT(task.end_time,'%Y-%m-%d %H:%i') and ps.psn_type=1 and ps.psn_id = t.psn_id and task.status =2 " + sqlche.toString() + ") complete,");
            sql.append(" (select count(*) count1 from " + database + ".sys_task task join " + database + ".sys_task_psn ps on");
            sql.append(" task.id = ps.nid where task.act_time>DATE_FORMAT(task.end_time,'%Y-%m-%d %H:%i') and ps.psn_type=1 and ps.psn_id = t.psn_id  and task.status =2 " + sqlche.toString() + ") unfinished,");
            sql.append(" (select count(*) count1 from " + database + ".sys_task task join " + database + ".sys_task_psn ps on");
            sql.append(" task.id = ps.nid where status = 1 and ps.psn_type=1 and date_format(now(),'%Y-%m-%d %H:%i') > DATE_FORMAT(task.end_time,'%Y-%m-%d %H:%i') and ps.psn_id = t.psn_id and task.status =1 " + sqlche.toString() + ") timeout");
            sql.append(" from (select psn.psn_id,psn.nid from " + database + ".sys_task_psn psn left join " + database + ".sys_mem b on psn.psn_id=b.member_id where b.branch_id=" + branchId + " and psn.psn_type=1 group by psn_id) t ) temp ");
//			sql.append(" left join "+database+".sys_task_psn a on a.nid=temp.nid left join "+database+".sys_mem b on a.psn_id=b.member_id where b.branch_id="+branchId);
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 易办事-团队工作负荷统计
     *
     * @param dateBase
     * @param pageNo
     * @param pageSize
     * @return
     */
    public Page queryLoad(Integer state, String database, Integer branchId, Integer pageNo,
                          Integer pageSize) {
        try {
            StringBuffer sqlche = new StringBuffer();
            if (state == 1) {
                sqlche.append(" and date_format(start_time,'%Y')=date_format(now(),'%Y') ");
            } else if (state == 2) {
                sqlche.append(" and date_format(start_time,'%Y-%m')=date_format(now(),'%Y-%m') ");
            } else if (state == 3) {
                sqlche.append(" and YEARWEEK(date_format(start_time,'%Y-%m-%d')) = YEARWEEK(now()) ");
            }
            StringBuffer sql = new StringBuffer();
            sql.append(" select temp.nid,temp.status,member_nm,complete,unfinished,totalnumber,(case when ratio is null then 0 else ratio end) ratio from (select temp.*,(temp.complete+unfinished) totalnumber,ROUND((temp.complete)/(temp.complete+unfinished)*100,2) ratio");
            sql.append(" from (select t.nid,t.status,(select mem.member_nm from " + database + ".sys_mem mem where mem.member_id = t.psn_id) ");
            sql.append(" member_nm,(select count(*) count1 from " + database + ".sys_task task join " + database + ".sys_task_psn ps on");
            sql.append(" task.id = ps.nid where task.status=2 and ps.psn_type=1 and ps.psn_id = t.psn_id " + sqlche.toString() + ") complete,");
            sql.append(" (select count(*) count1 from " + database + ".sys_task task join " + database + ".sys_task_psn ps on");
            sql.append(" task.id = ps.nid where task.status=1 and ps.psn_type=1 and ps.psn_id = t.psn_id " + sqlche.toString() + ") unfinished");
            sql.append(" from (select psn.psn_id,psn.nid,tt.status from " + database + ".sys_task_psn psn left join " + database + ".sys_mem b on psn.psn_id=b.member_id left join ");
            sql.append(database + ".sys_task tt on tt.id=psn.nid where b.branch_id=" + branchId + " and tt.status!=3 and psn.psn_type=1 group by psn_id) t ) temp ) temp ");
//			sql.append(" left join "+database+".sys_task_psn a on a.nid=temp.nid left join "+database+".sys_mem b on a.psn_id=b.member_id where b.branch_id="+branchId);
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 分页查询任务
     */
    public Page queryPage(SysTask task, Integer pageNo, Integer pageSize, String database, Integer memId) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select distinct task.id,task.task_title,task.create_time,task.start_time,task.end_time,task.parent_id,task.status,task.act_time,task.percent,m.member_nm as create_name,(select task_title from " + database + ".sys_task ts where task.parent_id =ts.id");
            sql.append(" limit 0,1) parent_title,(select GROUP_CONCAT(member_nm) from " + database + ".sys_mem mem where mem.member_id");
            sql.append(" in( select psn.psn_id from " + database + ".sys_task_psn psn where psn.psn_type=").append(SysTaskPsn.PSN_RESPONSIBILITY);
            sql.append(" and psn.nid = task.id)) member_nm,(select GROUP_CONCAT(member_nm) from " + database + ".sys_mem mem where mem.member_id");
            sql.append(" in( select psn.psn_id from " + database + ".sys_task_psn psn where psn.psn_type=").append(SysTaskPsn.PSN_FOCUS_ON);
            sql.append(" and psn.nid = task.id)) supervisor,(case when (select count(*) from " + database + ".sys_task ts where ");
            sql.append(" ts.parent_id = task.id) >0 then 1 else 0 end) child ");
//			sql.append(" ,(select psn.psn_id from "+database+".sys_task_psn psn where psn.psn_type="+SysTaskPsn.PSN_RESPONSIBILITY+" and psn.nid = task.id) member_id");//执行人
            sql.append(" from " + database + ".sys_task task left join " + database + ".sys_task_psn tp on task.id=tp.nid ");
            sql.append(" left join " + database + ".sys_mem m on task.create_by=m.member_id where 1=1 ");
            if (!StrUtil.isNull(task.getTaskTitle())) {
                sql.append(" and task.task_title like '%" + task.getTaskTitle() + "%'");
            }
            if (!StrUtil.isNull(task.getParentId())) {
                sql.append(" and task.parent_id = ").append(task.getParentId());
            }
            if (!StrUtil.isNull(task.getId())) {
                sql.append(" and task.id != ").append(task.getId());
            }
            if (null != memId) {//普通成员
                sql.append(" and (task.create_by=" + memId + " or (psn_type=1 and psn_id=" + memId);
                sql.append(") or (psn_type=2 and psn_id=" + memId + ")) ");
            }
            sql.append(" order by field(task.status,1,3,2) ,task.create_time desc,member_nm,supervisor");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据任务名称查询任务
     *
     * @param taskTitle
     * @param database
     * @return
     */
    public SysTask queryByTitle(String taskTitle, String database) {
        try {
            String sql = "select * from " + database + ".sys_task where task_title = ?";
            return this.daoTemplate.queryForObj(sql, SysTask.class, taskTitle);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * @param taskId 任务ID
     * @说明：易办事-关注任务查询
     * @创建：作者:zrp 创建时间：2015-1-26
     */
    public Page queryFocus(Integer id, String dateBase, Integer pageNo, Integer pageSize, Integer state) {
        try {
            StringBuffer sql = new StringBuffer("select task.id,task.task_title from " + dateBase + ".sys_task task join " + dateBase + ".sys_task_psn psn");
            sql.append(" on task.id = psn.nid where psn_type = 2 and psn.psn_id =" + id + " and task.status =").append(SysTask.STATUS_NO);
            if (state == 1) {
                sql.append(" and DATE_FORMAT(now(),'%Y-%m-%d %H:%i')>DATE_FORMAT(task.end_time,'%Y-%m-%d %H:%i') ");
            } else {
                sql.append(" and DATE_FORMAT(now(),'%Y-%m-%d %H:%i')<=DATE_FORMAT(task.end_time,'%Y-%m-%d %H:%i') ");
            }
            sql.append(" order by task.id desc ");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 查询需要推送的数据
     *
     * @param datasource
     * @return
     */
    public List<SysTask> queryPush(String datasource) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select task.*,ROUND((TIMESTAMPDIFF(MINUTE,task.start_time,task.end_time)-TIMESTAMPDIFF(MINUTE,task.start_time,NOW()))");
            sql.append(" /TIMESTAMPDIFF(MINUTE,task.start_time,task.end_time) * 100,0) ratio,");
            sql.append(" (select GROUP_CONCAT(mem.member_mobile) from " + datasource + ".sys_mem mem join " + datasource + ".sys_task_psn psn on psn.psn_id = mem.member_id");
            sql.append(" where psn.nid =task.id and psn.psn_type=1) member_nm,");
            sql.append(" (select GROUP_CONCAT(CAST(mem.member_id as char(20))) from " + datasource + ".sys_mem mem join " + datasource + ".sys_task_psn psn on psn.psn_id = mem.member_id ");
            sql.append(" where psn.nid =task.id and psn.psn_type=1) member_ids");
            sql.append(" from " + datasource + ".sys_task task where status = 1 and DATE_FORMAT(now(),'%Y-%m-%d %H:%i:%S')<= DATE_FORMAT(end_time,'%Y-%m-%d %H:%i:%S')");
            return this.daoTemplate.queryForLists(sql.toString(), SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //查询需要推送的进行中任务
    public List<SysTaskIng> queryPushTaskIng(String datasource) {
        String ntime = "date_format(now(),'%Y-%m-%d %H:%i')";
        StringBuffer sql = new StringBuffer();
		/*sql.append(" select task_id,task_title,m.member_mobile,(case when time5="+ntime+" then -1 else (case when time4="+ntime+" then concat(remind4,'%') else (case when time3=");
		sql.append(ntime+" then concat(remind3,'%') else (case when time2="+ntime+" then concat(remind2,'%') else (case when time1="+ntime+" then concat(remind1,'%') else NULL end) end) end) end) end) as premind from ");
		sql.append(datasource+".sys_task_ing ti left join "+datasource+".sys_mem m on ti.create_by=m.member_id where time5="+ntime+" or time4="+ntime+" or time3="+ntime+" or time2="+ntime+" or time1="+ntime);*/
        sql.append(" select id,task_id,task_title,m.member_mobile,create_by,remind1 as premind from ");
        sql.append(datasource + ".sys_task_ing ti left join " + datasource + ".sys_mem m on ti.create_by=m.member_id where time1<=" + ntime);
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysTaskIng.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 分页查询草稿箱信息
     *
     * @param title
     * @param pageNo
     * @param pageSize
     * @param database
     * @return
     */
    public Page queryDraft(Integer uid, String title, Integer pageNo, Integer pageSize, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select id,task_title,parent_id from " + database + ".sys_task where create_by = " + uid + " and status = " + SysTask.STATUS_DRAFT);
            if (!StrUtil.isNull(title)) {
                sql.append(" and task_title like '%" + title + "%'");
            } else {
                sql.append(" and parent_id is null ");
            }
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTask.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据父任务ID查询是否有未完成任务
     *
     * @param taskId
     * @param database
     * @return
     */
    public Map queryByTaskIdNot(Integer taskId, String database) {
        try {
            String sql = "select count(*) num from " + database + ".sys_task where parent_id = ? and status=1 and percent<100 ";
            return this.daoTemplate.queryForMap(sql, taskId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * @param taskId
     * @param database
     * @param psnType
     * @return
     * @创建：作者:YYP 创建时间：2015-4-11
     * @see 查询责任人或关注人id和姓名
     */
    public Map queryByTaskMem(Integer taskId, String database,
                              Integer psnType) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select GROUP_CONCAT(CAST(mem.member_id as char(20))) ids,GROUP_CONCAT(mem.member_nm) names from " + database + ".sys_task_psn psn ");
            sql.append(" join " + database + ".sys_mem mem on psn.psn_id=mem.member_id");
            sql.append(" where psn.nid = ").append(taskId);
            sql.append(" and psn.psn_type = ").append(psnType);
            return this.daoTemplate.queryForMap(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<SysMemDTO> queryMemList(Integer taskId, String database,
                                        Integer psnType) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select mem.member_id,mem.member_nm from " + database + ".sys_task_psn psn ");
            sql.append(" join " + database + ".sys_mem mem on psn.psn_id=mem.member_id");
            sql.append(" where psn.nid = ").append(taskId);
            sql.append(" and psn.psn_type = ").append(psnType);
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * @param parentId
     * @param id
     * @param database
     * @创建：作者:YYP 创建时间：2015-6-3
     * @see 更新任务路径
     */
    public void updateStatePath(Integer parentId, Integer id, String database) {
        StringBuffer sql = new StringBuffer("update " + database + ".sys_task t set ");
        if (null == parentId) {
            sql.append(" task_path='-" + id + "-' ");
        } else {
            sql.append(" task_path= concat(").append("(select b.task_path from (select * from " + database + ".sys_task) as b where b.id=" + parentId + "),'" + id + "-') ");
        }
        sql.append(" where id=" + id);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param taskId
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-6-3
     * @see 删除任务
     */
    public void deleteTaskById(String taskIds, String datasource) {
        StringBuffer sql = new StringBuffer("delete from " + datasource + ".sys_task where 1=1 ");
        try {
            String[] tIds = taskIds.split(",");
            for (int i = 0; i < tIds.length; i++) {
                if (0 == i) {
                    sql.append(" and( task_path like '%-" + tIds[i] + "-%' ");
                } else {
                    sql.append(" or task_path like '%-" + tIds[i] + "-%' ");
                }
            }
            sql.append(" ) ");
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param taskId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-6-4
     * @see 查询主子任务ids
     */
    public Map<String, Object> queryTaskIds(Integer taskId, String datasource) {
        StringBuffer sql = new StringBuffer("select group_concat(CAST(id as char(20)) ) ids from ");
        sql.append(datasource + ".sys_task where task_path like '%-" + taskId + "-%' ");
        try {
            return daoTemplate.queryForMap(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param taskId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-6-18
     * @see 查询主子任务
     */
    public List<SysTask> queryTaskByzid(Integer taskId, String datasource) {
        StringBuffer sql = new StringBuffer("select t.id,t.task_title,t.create_time,t.start_time,t.end_time,t.parent_id,tp.psn_id as create_by,t.remind1,t.remind2,t.remind3,t.remind4 from ");
        sql.append(datasource + ".sys_task t left join " + datasource + ".sys_task_psn tp on t.id=tp.nid where t.task_path like '%-" + taskId + "-%' and tp.psn_type=1 ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysTask.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /**
     *@see 批量添加进行中任务
     *@param taskIngList
     *@param database
     *@创建：作者:YYP 创建时间：2015-6-18
     */
	/*public int[] addTaskIngBatch(final List<SysTask> taskList, String database) {
		String tsql1 = " date_format(TIMESTAMPADD(MINUTE,(TIMESTAMPDIFF(MINUTE,?,?))*((100-?)/100),?),'%Y-%m-%d %H:%i'), ";
		StringBuffer sql = new StringBuffer("insert into "+database+".sys_task_ing(task_id,task_title,create_time,start_time,end_time,parent_id,create_by,time1,time2,time3,time4,time5,remind1,remind2,remind3,remind4) ");
		sql.append(" values(?,?,?,?,?,?,?,").append(tsql1).append(tsql1).append(tsql1).append(tsql1).append(" date_format(TIMESTAMPADD(MINUTE,-5,?),'%Y-%m-%d %H:%i'),?,?,?,?) ");
		String tsql1 = " date_format(TIMESTAMPADD(MINUTE,(TIMESTAMPDIFF(MINUTE,?,?))*((100-?)/100),?),'%Y-%m-%d %H:%i'), ";
		StringBuffer sql = new StringBuffer("insert into "+database+".sys_task_ing(task_id,task_title,time1,remind1) ");
		sql.append(" values(?,?,").append(tsql1).append(" ,?) ");//1
		sql.append(";insert into "+database+".sys_task_ing(task_id,task_title,time1,remind1) ");
		sql.append(" values(?,?,").append(tsql1).append(" ,?) ");//2
		sql.append(";insert into "+database+".sys_task_ing(task_id,task_title,time1,remind1) ");
		sql.append(" values(?,?,").append(tsql1).append(" ,?) ");//3
		sql.append(";insert into "+database+".sys_task_ing(task_id,task_title,time1,remind1) ");
		sql.append(" values(?,?,").append(tsql1).append(" ,?) ");//4
		sql.append(";insert into "+database+".sys_task_ing(task_id,task_title,time1,remind1) ");
		sql.append(" values(?,?,").append(tsql1).append(" ,?) ");//5
		
		try{
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement pre, int num) throws SQLException {
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					//time1
					pre.setString(8,taskList.get(num).getStartTime());
					pre.setString(9,taskList.get(num).getEndTime());
					pre.setInt(10,taskList.get(num).getRemind1());
					pre.setString(11,taskList.get(num).getStartTime());
					pre.setInt(25, taskList.get(num).getRemind1());
					
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					//time2
					pre.setString(12,taskList.get(num).getStartTime());
					pre.setString(13,taskList.get(num).getEndTime());
					pre.setInt(14,taskList.get(num).getRemind2());
					pre.setString(15,taskList.get(num).getStartTime());
					pre.setInt(26, taskList.get(num).getRemind2());
					
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					//time3
					pre.setString(16,taskList.get(num).getStartTime());
					pre.setString(17,taskList.get(num).getEndTime());
					pre.setInt(18,taskList.get(num).getRemind3());
					pre.setString(19,taskList.get(num).getStartTime());
					pre.setInt(27, taskList.get(num).getRemind3());
					
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					//time4
					pre.setString(20,taskList.get(num).getStartTime());
					pre.setString(21,taskList.get(num).getEndTime());
					pre.setInt(22,taskList.get(num).getRemind4());
					pre.setString(23,taskList.get(num).getStartTime());
					pre.setInt(28, taskList.get(num).getRemind4());
					
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					//time5
					pre.setString(24, taskList.get(num).getEndTime());
					
					
					
					
					pre.setInt(1,taskList.get(num).getId());
					pre.setString(2,taskList.get(num).getTaskTitle());
					pre.setString(3,taskList.get(num).getCreateTime());
					pre.setString(4,taskList.get(num).getStartTime());
					pre.setString(5,taskList.get(num).getEndTime());
					if(null!=taskList.get(num).getParentId()){
						pre.setInt(6,taskList.get(num).getParentId());
					}else{
						pre.setString(6,null);
					}
					pre.setInt(7,taskList.get(num).getCreateBy());
					//time1
					pre.setString(8,taskList.get(num).getStartTime());
					pre.setString(9,taskList.get(num).getEndTime());
					pre.setInt(10,taskList.get(num).getRemind1());
					pre.setString(11,taskList.get(num).getStartTime());
					//time2
					pre.setString(12,taskList.get(num).getStartTime());
					pre.setString(13,taskList.get(num).getEndTime());
					pre.setInt(14,taskList.get(num).getRemind2());
					pre.setString(15,taskList.get(num).getStartTime());
					//time3
					pre.setString(16,taskList.get(num).getStartTime());
					pre.setString(17,taskList.get(num).getEndTime());
					pre.setInt(18,taskList.get(num).getRemind3());
					pre.setString(19,taskList.get(num).getStartTime());
					//time4
					pre.setString(20,taskList.get(num).getStartTime());
					pre.setString(21,taskList.get(num).getEndTime());
					pre.setInt(22,taskList.get(num).getRemind4());
					pre.setString(23,taskList.get(num).getStartTime());
					//time5
					pre.setString(24, taskList.get(num).getEndTime());
					
					pre.setInt(25, taskList.get(num).getRemind1());
					pre.setInt(26, taskList.get(num).getRemind2());
					pre.setInt(27, taskList.get(num).getRemind3());
					pre.setInt(28, taskList.get(num).getRemind4());
				}
				
				@Override
				public int getBatchSize() {
					return 1;
				}
			};
			return daoTemplate.batchUpdate(sql.toString(),setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}*/
	/*public void addTaskIng(SysTask sysTask, String database) {
		String tsql1 = " date_format(TIMESTAMPADD(MINUTE,(TIMESTAMPDIFF(MINUTE,?,?))*((100-?)/100),?),'%Y-%m-%d %H:%i'), ";
		StringBuffer sql = new StringBuffer("insert into "+database+".sys_task_ing(task_id,task_title,create_time,start_time,end_time,parent_id,create_by,time1,time2,time3,time4,time5,remind1,remind2,remind3,remind4) ");
		sql.append(" values(?,?,?,?,?,?,?,").append(tsql1).append(tsql1).append(tsql1).append(tsql1).append(" date_format(TIMESTAMPADD(MINUTE,-5,?),'%Y-%m-%d %H:%i'),?,?,?,?) ");
		try{
			String startTime = sysTask.getStartTime();
			String endTime = sysTask.getEndTime();
			daoTemplate.update(sql.toString(), sysTask.getId(),sysTask.getTaskTitle(),sysTask.getCreateTime(),startTime,endTime,null,
					sysTask.getCreateBy(),startTime,endTime,sysTask.getRemind1(),startTime,startTime,endTime,sysTask.getRemind2(),startTime,
					startTime,endTime,sysTask.getRemind3(),startTime,startTime,endTime,sysTask.getRemind4(),startTime,endTime,
					sysTask.getRemind1(),sysTask.getRemind2(),sysTask.getRemind3(),sysTask.getRemind4());
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}*/

    /**
     * @param taskId
     * @param database
     * @创建：作者:YYP 创建时间：2015-6-19
     * @see 删除进行中子表任务
     */
    public void deleteTaskIng(Integer taskId, String database) {
        String sql = "delete from " + database + ".sys_task_ing where task_id=" + taskId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询任务的开始和结束时间
    public Map<String, Object> queryParentTime(Integer parentId, String database) {
        String sql = "select start_time as stime,end_time as etime from " + database + ".sys_task where id=" + parentId;
        try {
            return daoTemplate.queryForMap(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询任务附件
    public List<SysTaskAttachment> queryTaskattachment(Integer tid,
                                                       String database) {
        String sql = "select * from " + database + ".sys_task_attachment where nid=" + tid;
        try {
            return daoTemplate.queryForLists(sql, SysTaskAttachment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询主子任务
    public Page queryTaskByTypeId(String type, Integer taskId, String database, Integer page, Integer rows) {
        StringBuffer sql = new StringBuffer("select t.id,t.task_title,t.create_time,t.status,t.percent,m.member_nm as create_name, ");
        sql.append(" (select m1.member_nm from " + database + ".sys_task_psn tp1 left join " + database + ".sys_mem m1 on tp1.psn_id=m1.member_id where tp1.psn_type=1 and tp1.nid=t.id) as member_nm, ");//执行人
        sql.append(" (select group_concat(m2.member_nm) from " + database + ".sys_task_psn tp2 left join " + database + ".sys_mem m2 on tp2.psn_id=m2.member_id where tp2.psn_type=2 and tp2.nid=t.id) as supervisor ");//执行人
        sql.append(" from " + database + ".sys_task t left join " + database + ".sys_mem m on t.create_by=m.member_id ");
        sql.append(" where 1=1 ");
        if ("1".equals(type)) {//查主任务
            sql.append(" and task_path like '-%-" + taskId + "-'");
        } else if ("2".equals(type)) {//查子任务
            sql.append(" and task_path like '-" + taskId + "-%-'");
        }
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysTask.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询子任务
    public List<SysTask> querChildTask(Integer taskId, String datasource) {
        StringBuffer sql = new StringBuffer("select t.id,t.task_title,t.create_time,t.status,t.percent,m.member_nm as create_name, ");
        sql.append(" (select m1.member_nm from " + datasource + ".sys_task_psn tp1 left join " + datasource + ".sys_mem m1 on tp1.psn_id=m1.member_id where tp1.psn_type=1 and tp1.nid=t.id) as member_nm, ");//执行人
        sql.append(" (select group_concat(m2.member_nm) from " + datasource + ".sys_task_psn tp2 left join " + datasource + ".sys_mem m2 on tp2.psn_id=m2.member_id where tp2.psn_type=2 and tp2.nid=t.id) as supervisor ");//执行人
        sql.append(" from " + datasource + ".sys_task t left join " + datasource + ".sys_mem m on t.create_by=m.member_id ");
        sql.append(" where 1=1 ");
        sql.append(" and task_path like '-" + taskId + "-%-'");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysTask.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //修改主任务的persent进度
    public void updatePersent(Integer nid, Integer percent, String datasource) {
        String sql = "update " + datasource + ".sys_task set percent=" + percent + " where id=" + nid;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //添加任务备份表数据
    public void updateTaskIngBySql(String[] sql) {
        try {
            daoTemplate.batchUpdate(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询任务执行情况统计表
     *
     * @param database
     * @param memId
     * @return
     */
    public List<Map<String, Object>> queryTaskZhiXing(String database, Integer memId, String month) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append("select ")
                    .append("member_company,")
                    .append("branch_name,")
                    .append("member_nm,")
                    .append("end_time as month,")
                    .append(" sum(cq_count)-SUM(IF(v.status='3',1,0)) as cq_count, ") /*超期数量*/
                    .append(" ((sum(cq_count)- SUM(IF(v.status='3',1,0)))/(sum(1)- SUM(IF(v.status='3',1,0))))*100 as cq_rate,")/*超期比例*/
                    .append(" SUM(1)- SUM(IF(v.status='3',1,0)) as total") /*任务总数*/
                    .append(" from ")
                    .append(database).append(".view_TaskZhiXing v")
                    .append(" where v.end_time is not  null ");

            if (!StrUtil.isNull(month)) {
                sql.append(" and v.end_time ='").append(month).append("'");
            }
            sql.append("	group by v.member_company,v.branch_name,v.end_time,v.member_nm");
            return (List<Map<String, Object>>) daoTemplate.queryForList(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //删除任务备份表数据
    public void deleteTaskIngs(String tIds, String database) {
        String sql = "delete from " + database + ".sys_task_ing where id in (" + tIds + ") ";
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询所有子任务时间是否超出主任务
    public Integer queryIfOutTime(String startTime, String endTime, Integer taskId, String database) {
        StringBuffer sql = new StringBuffer("select count(*) from " + database + ".sys_task t where (t.start_time<'");
        sql.append(startTime).append("' or t.end_time>'").append(endTime).append("') and t.id!=" + taskId + " and t.task_path like '-" + taskId + "-%'");
        try {
            return daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据任务id查询责任人
    public Integer queryPsnId(Integer taskId, String database) {
        String sql = "select p.psn_id from " + database + ".sys_task_psn p where psn_type=1 and nid=" + taskId;
        try {
            return daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
