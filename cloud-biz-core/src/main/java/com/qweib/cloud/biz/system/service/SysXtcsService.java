package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysXtcsDao;
import com.qweib.cloud.core.domain.SysXtcs;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysXtcsService {
	@Resource
	private SysXtcsDao xtcsDao;
	
	/**
	 *说明：分页查询系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public Page queryXtcsPage(SysXtcs xtcs,String database,Integer page,Integer limit){
		try {
			return this.xtcsDao.queryXtcsPage(xtcs, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public int updateXtcs(SysXtcs xtcs,String database){
		try {
			return this.xtcsDao.updateXtcs(xtcs, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public SysXtcs queryXtcsById(Integer Id,String database){
		try {
			return this.xtcsDao.queryXtcsById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
