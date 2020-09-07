package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysJxsjbDao;
import com.qweib.cloud.core.domain.SysJxsjb;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysJxsjbService {
	@Resource
	private SysJxsjbDao jxsjbDao;
	
	/**
	 *说明：分页查询经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsjbPage(SysJxsjb Jxsjb,String database,Integer page,Integer limit){
		try {
			return this.jxsjbDao.queryJxsjbPage(Jxsjb, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxsjb(SysJxsjb Jxsjb,String database){
		try {
			return this.jxsjbDao.addJxsjb(Jxsjb, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxsjb(SysJxsjb Jxsjb,String database){
		try {
			return this.jxsjbDao.updateJxsjb(Jxsjb, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxsjb queryJxsjbById(Integer Id,String database){
		try {
			return this.jxsjbDao.queryJxsjbById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsjbById(Integer Id,String database){
		try {
			return this.jxsjbDao.deleteJxsjbById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
