package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysTaskPsn;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.company.SysTaskPsnDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 说明：任务表Service
 * 
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
 */
@Service
public class SysTaskPsnService {

	@Resource
	private SysTaskPsnDao taskPsnDao;

	/**
	 * 添加任务
	 * @param task
	 * @param database 
	 * @return
	 */
	public int addTaskPsn(SysTaskPsn task, String database) {
		try {
			return taskPsnDao.addTaskPsn(task,database);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 根据任务ID获取责任人
	 * @param taskId
	 * @param database
	 * @return
	 */
	public List<SysMember> queryHead(Integer taskId, String database, Integer psnType) {
		try {
			return taskPsnDao.queryHead(taskId,database,psnType);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID删除
	 * @param taskId
	 * @param database
	 * @return
	 */
	public int deleteByTaskId(Integer taskId, String database) {
		try {
			return taskPsnDao.deleteByTaskId(taskId,database);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	/**
	 * 根据任务ID类型删除
	 * @param taskId
	 * @param database
	 * @return
	 */
	public int deleteByTaskId(Integer taskId,Integer state, String database) {
		try{
			return this.taskPsnDao.deleteByTaskId(taskId, state, database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
