package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysJxsztDao;
import com.qweib.cloud.core.domain.SysJxszt;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysJxsztService {
	@Resource
	private SysJxsztDao jxsztDao;
	
	/**
	 *说明：分页查询经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsztPage(SysJxszt Jxszt,String database,Integer page,Integer limit){
		try {
			return this.jxsztDao.queryJxsztPage(Jxszt, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxszt(SysJxszt Jxszt,String database){
		try {
			return this.jxsztDao.addJxszt(Jxszt, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxszt(SysJxszt Jxszt,String database){
		try {
			return this.jxsztDao.updateJxszt(Jxszt, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxszt queryJxsztById(Integer Id,String database){
		try {
			return this.jxsztDao.queryJxsztById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsztById(Integer Id,String database){
		try {
			return this.jxsztDao.deleteJxsztById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
