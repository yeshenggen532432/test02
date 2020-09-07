package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysQdtypeDao;
import com.qweib.cloud.core.domain.SysQdtype;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQdtypeService {
	@Resource
	private SysQdtypeDao qdtypeDao;
	
	/**
	 *说明：分页查询渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public Page queryQdtypePage(SysQdtype qdtype,String database,Integer page,Integer limit){
		try {
			return this.qdtypeDao.queryQdtypePage(qdtype, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public List<SysQdtype> queryList(SysQdtype qdtype,String database){
		try {
			return this.qdtypeDao.queryList(qdtype, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int addQdtype(SysQdtype qdtype,String database){
		try {
			return this.qdtypeDao.addQdtype(qdtype, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int updateQdtype(SysQdtype qdtype,String database){
		try {
			return this.qdtypeDao.updateQdtype(qdtype, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public SysQdtype queryQdtypeById(Integer Id,String database){
		try {
			return this.qdtypeDao.queryQdtypeById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取渠道类型列表
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public List<SysQdtype> queryQdtypels(String database){
		try {
			return this.qdtypeDao.queryQdtypels(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int deleteQdtypeById(Integer Id,String database){
		try {
			return this.qdtypeDao.deleteQdtypeById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
		
	}

	/**
	 *说明：根据type名称获取渠道类型
	 */
	public SysQdtype queryQdtypeByName(String name,String database){
		try {
			return this.qdtypeDao.queryQdtypeByName(name, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
