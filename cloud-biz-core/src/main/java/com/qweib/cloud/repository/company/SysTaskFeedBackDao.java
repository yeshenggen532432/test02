package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysTaskFeedback;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 说明：任务相关人DAO
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
@Repository
public class SysTaskFeedBackDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 根据任务ID获取任务进度详情
     *
     * @param databse
     * @param taskId
     * @param taskId
     * @param pageSize
     * @param pageNo
     * @return
     */
    public Page queryById(Integer taskId, String databse, Integer pageNo, Integer pageSize) {
        try {
            StringBuffer sql = new StringBuffer("select feed.* from " + databse + ".sys_task_feedback feed");
            sql.append(" where feed.nid=").append(taskId);
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysTaskFeedback.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据进度ID获取任务明细
     *
     * @param feeId
     * @param databse
     * @return
     */
    public SysTaskFeedback queryById(Integer feeId, String dateBase) {
        try {
            String sql = "select feed.* from " + dateBase + ".sys_task_feedback feed where feed.id = ?";
            return this.daoTemplate.queryForObj(sql, SysTaskFeedback.class, feeId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改任务进度
     *
     * @param feed
     * @param dateBase
     */
    public void updateTaskFeed(SysTaskFeedback feed, String dateBase) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", feed.getId());
            this.daoTemplate.updateByObject(dateBase + ".sys_task_feedback", feed, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID获取进度信息
     *
     * @param taskId
     * @param database
     * @return
     */
    public List<SysTaskFeedback> queryByPid(Integer taskId, String database) {
        try {
            String sql = "select * from " + database + ".sys_task_feedback where nid= ?";
            return this.daoTemplate.queryForLists(sql, SysTaskFeedback.class, taskId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //添加任务反馈
    public Integer addFeed(SysTaskFeedback feed, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return this.daoTemplate.addByObject(database + ".sys_task_feedback", feed);

            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
