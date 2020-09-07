package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysTaskFeedback;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.company.SysTaskFeedBackDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 说明：任务相关人DAO
 * 
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
 */
@Repository
public class SysTaskFeedBackService {
	@Resource
	private SysTaskFeedBackDao taskFeedBackDao;

	/**
	 * 根据任务ID获取任务进度详情
	 * @param taskId
	 * @param databse 
	 * @param pageSize 
	 * @param pageNo 
	 * @return
	 */
	public Page queryById(Integer taskId, String databse, Integer pageNo, Integer pageSize) {
		try{
			return this.taskFeedBackDao.queryById(taskId,databse,pageNo,pageSize);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据进度ID获取任务明细
	 * @param feeId
	 * @param databse 
	 * @return
	 */
	public SysTaskFeedback queryById(Integer feeId, String dateBase) {
		try{
			return this.taskFeedBackDao.queryById(feeId,dateBase);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 修改任务进度
	 * @param feed
	 * @param dateBase
	 */
	public void updateTaskFeed(SysTaskFeedback feed, String dateBase) {
		try{
			this.taskFeedBackDao.updateTaskFeed(feed,dateBase);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID获取进度信息
	 * @param taskId
	 * @param database
	 * @return
	 */
	public List<SysTaskFeedback> queryByPid(Integer taskId, String database) {
		try{
			return this.taskFeedBackDao.queryByPid(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//添加任务反馈
	public Integer addFeed(SysTaskFeedback feed, String database) {
		try{
			return this.taskFeedBackDao.addFeed(feed,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
}
