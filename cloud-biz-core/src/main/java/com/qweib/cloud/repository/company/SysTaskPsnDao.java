package com.qweib.cloud.repository.company;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysTaskPsn;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 说明：任务相关人DAO
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
@Repository
public class SysTaskPsnDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加任务相关人
     *
     * @param task
     * @param database
     * @return
     */
    public int addTaskPsn(SysTaskPsn task, String database) {
        try {
            return daoTemplate.addByObject(database + ".sys_task_psn", task);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID获取责任人
     *
     * @param taskId
     * @param database
     * @return
     */
    public List<SysMember> queryHead(Integer taskId, String database, Integer psnType) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select mem.member_id,mem.member_nm,member_head from " + database + ".sys_task_psn psn");
            sql.append(" join " + database + ".sys_mem mem on psn.psn_id = mem.member_id ");
            sql.append(" where psn.nid = ? and psn.psn_type = ?");
            return daoTemplate.queryForLists(sql.toString(), SysMember.class, taskId, psnType);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID删除
     *
     * @param taskId
     * @param database
     * @return
     */
    public int deleteByTaskId(Integer taskId, String database) {
        try {
            String sql = "delete from " + database + ".sys_task_psn where nid=?";
            return daoTemplate.update(sql, taskId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID类型删除
     *
     * @param taskId
     * @param database
     * @return
     */
    public int deleteByTaskId(Integer taskId, Integer state, String database) {
        try {
            String sql = "delete from " + database + ".sys_task_psn where nid=? and psn_type=?";
            return daoTemplate.update(sql, taskId, state);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
	/*public List<SysTaskPsn> queryMemAll(Integer taskId, String database) {
		try{
			StringBuffer sql = new StringBuffer();
			sql.append("select * from "+database+".sys_task_psn where nid = ?");
			return daoTemplate.queryForLists(sql.toString(), SysTaskPsn.class, taskId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}*/
}
