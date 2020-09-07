package com.qweib.cloud.repository.job;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.job.SysCronJob;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCronJobDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 增加作业记录
     *
     * @param job
     * @return
     */
    public int add(SysCronJob job) {
        try {
            //costRec.setNewTime(new Date());
            job.setCreateTime(new Date());
            job.setState(0);
            return this.daoTemplate.addByObject("publicplat.sys_cron_job", job);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 操作成功作业
     *
     * @param jobName
     * @return
     */
    public int updateSuccess(String jobName) {
        try {
            String sql = "select * from publicplat.sys_cron_job where job_name=?";
            SysCronJob oldJob = this.daoTemplate.queryForObj(sql, SysCronJob.class, jobName);
            oldJob.setUpdateTime(new Date());
            oldJob.setState(1);
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("job_name", jobName);
            return this.daoTemplate.updateByObject("publicplat.sys_cron_job", oldJob, whereParam, "job_name");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 待执行操作成功作业列表
     */
    public List<SysCronJob> findWaitAll() {
        try {
            String sql = "select * from publicplat.sys_cron_job where state=0";
            return this.daoTemplate.queryForLists(sql, SysCronJob.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 增加作业记录
     *
     * @param jobName
     * @return
     */
    public int del(String jobName) {
        try {
            return this.daoTemplate.update("delete from publicplat.sys_cron_job where job_name=?", jobName);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
