package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysTaskAttachment;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.company.SysTaskAttachmentDao;
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
public class SysTaskAttachmentService {
	
	@Resource
	private SysTaskAttachmentDao taskAttachmentDao;
	
	/**
	 * 添加任务
	 * @param task
	 * @param database 
	 * @return
	 */
	public int addTaskAttachment(SysTaskAttachment task, String database){
		try{
			return taskAttachmentDao.addTaskAttachment(task,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据ID查询附件信息
	 * @param database 
	 * @param task
	 * @return
	 */
	public SysTaskAttachment queryById(Integer id, String database) {
		try{
			return taskAttachmentDao.queryById(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID查询所有附件信息
	 * @param database 
	 * @param i
	 * @return
	 */
	public List<SysTaskAttachment> queryForList(String id, String database) {
		try{
			return taskAttachmentDao.queryForList(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 删除附件信息
	 * @param i
	 * @return
	 */
	public void deleteByid(Integer id, String database) {
		try{
			taskAttachmentDao.deleteByid(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据进度ID获取附件
	 * @param i
	 * @return
	 */
	public List<SysTaskAttachment> queryFeedBackList(Integer id, String datebase) {
		try{
			return taskAttachmentDao.queryFeedBackList(id,datebase);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID获取附件
	 * @param database
	 * @param ids
	 * @return
	 */
	public List<SysTaskAttachment> queryForListByNid(String database,
			List<Integer> ids) {
		try{
			return taskAttachmentDao.queryForListByNid(database,ids);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID获取附件
	 * @param database
	 * @param ids
	 * @return
	 */
	public List<SysTaskAttachment> queryForlistByPid(String database,
			List<Integer> ids) {
		try{
			return taskAttachmentDao.queryForlistByPid(database,ids);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *@see 根据tempid查询附件信息
	  *@param attTempId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-7-15
	 */
	public List<SysTaskAttachment> queryAttByTempid(String attTempId,
			String database) {
		try{
			return taskAttachmentDao.queryAttByTempid(attTempId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *@see 根据多个attid删除附件
	  *@param attachmentId
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-7-15
	 */
	public Integer deleteByids(String attachmentId, String database) {
		try{
			return taskAttachmentDao.deleteByids(attachmentId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//根据多个id查询信息
	public List<SysTaskAttachment> queryAttByids(String attachmentId,
			String database) {
		try{
			return taskAttachmentDao.queryAttByids(attachmentId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//更新附件对应的任务id
	public void updateAtt(String attTempId,Integer tid, String database) {
		try{
			 taskAttachmentDao.updateAtt(attTempId,tid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//更新附件对应的反馈任务id
	public void updateAttForFeedId(String attTempId, Integer fid,
			String database) {
		try{
			 taskAttachmentDao.updateAttForFeedId(attTempId,fid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//更新附件对应的知识点id
	public void updateAttForRefId(String attTempId, Integer id,
			String datasource) {
		try{
			 taskAttachmentDao.updateAttForRefId(attTempId,id,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//根据任务nid查询附件信息
	public List<SysTaskAttachment> queryAttBynid(Integer nid, String database) {
		try{
			return taskAttachmentDao.queryAttBynid(nid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
