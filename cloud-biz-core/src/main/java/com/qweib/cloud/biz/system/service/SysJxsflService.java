package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysJxsflDao;
import com.qweib.cloud.core.domain.SysJxsfl;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysJxsflService {
	@Resource
	private SysJxsflDao jxsflDao;
	
	/**
	 *说明：分页查询经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsflPage(SysJxsfl Jxsfl,String database,Integer page,Integer limit){
		try {
			return this.jxsflDao.queryJxsflPage(Jxsfl, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxsfl(SysJxsfl Jxsfl,String database){
		try {
			return this.jxsflDao.addJxsfl(Jxsfl, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxsfl(SysJxsfl Jxsfl,String database){
		try {
			return this.jxsflDao.updateJxsfl(Jxsfl, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxsfl queryJxsflById(Integer Id,String database){
		try {
			return this.jxsflDao.queryJxsflById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsflById(Integer Id,String database){
		try {
			return this.jxsflDao.deleteJxsflById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
