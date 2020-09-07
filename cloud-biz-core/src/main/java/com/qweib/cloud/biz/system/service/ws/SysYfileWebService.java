package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysYfile;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysYfileWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysYfileWebService {
	@Resource
	private SysYfileWebDao yfileWebDao;
	
	/**
	 *说明：添加云文件
	 *@创建：作者:llp		创建时间：2016-11-04
	 *@修改历史：
	 *		[序号](llp	2016-11-04)<修改说明>
	 */
	public int addYfile(SysYfile Yfile,String database) {
		try {
			return this.yfileWebDao.addYfile(Yfile, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询云文件
	 *@创建：作者:llp		创建时间：2016-11-04
	 *@修改历史：
	 *		[序号](llp	2016-11-04)<修改说明>
	 */
	public Page queryYfileWeb(String database,Integer memId,Integer tp2,String fileNm,Integer pid,Integer page,Integer limit){
		try {
			return this.yfileWebDao.queryYfileWeb(database, memId, tp2, fileNm, pid, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改云文件
	 *@创建：作者:llp		创建时间：2016-11-7
	 *@修改历史：
	 *		[序号](llp	2016-11-7)<修改说明>
	 */
	public void updatefileNm(String database,String fileNm,Integer id) {
		try {
			this.yfileWebDao.updatefileNm(database, fileNm, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：判断文件名称是否存在
	 *@创建：作者:llp		创建时间：2016-11-7
	 *@修改历史：
	 *		[序号](llp	2016-11-7)<修改说明>
	 */
	public int queryIsfileNm(String database,String fileNm,Integer memberId) {
		try {
			return this.yfileWebDao.queryIsfileNm(database, fileNm, memberId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：移动云文件
	 *@创建：作者:llp		创建时间：2016-11-7
	 *@修改历史：
	 *		[序号](llp	2016-11-7)<修改说明>
	 */
	public void updatefilePid(String database,Integer id,Integer pid,Integer tp2) {
		try {
			this.yfileWebDao.updatefilePid(database, id, pid,tp2);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取文件信息
	 *@创建：作者:llp		创建时间：2016-11-7
	 *@修改历史：
	 *		[序号](llp	2016-11-7)<修改说明>
	 */
	public SysYfile queryYfileById(String database,Integer Id){
		try {
			return this.yfileWebDao.queryYfileById(database, Id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除云文件
	 *@创建：作者:llp		创建时间：2016-11-9
	 *@修改历史：
	 *		[序号](llp	2016-11-9)<修改说明>
	 */
	public void deletefile(String database,Integer memberId,String fileNm) {
		try {
			 this.yfileWebDao.deletefile(database, memberId, fileNm);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除云文件2
	 *@创建：作者:llp		创建时间：2016-11-10
	 *@修改历史：
	 *		[序号](llp	2016-11-10)<修改说明>
	 */
	public void deletefile2(String database,String fileNm) {
		try {
			 this.yfileWebDao.deletefile2(database, fileNm);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取文件信息2
	 *@创建：作者:llp		创建时间：2016-11-9
	 *@修改历史：
	 *		[序号](llp	2016-11-9)<修改说明>
	 */
	public SysYfile queryYfile2(String database,Integer memberId,String fileNm){
		try {
			return this.yfileWebDao.queryYfile2(database, memberId, fileNm);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：判断文件夹底下有没有文件
	 *@创建：作者:llp		创建时间：2016-11-9
	 *@修改历史：
	 *		[序号](llp	2016-11-9)<修改说明>
	 */
	public int queryIsfilePid(String database,Integer id) {
		try {
			return this.yfileWebDao.queryIsfilePid(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取文件信息3
	 *@创建：作者:llp		创建时间：2016-11-10
	 *@修改历史：
	 *		[序号](llp	2016-11-10)<修改说明>
	 */
	public SysYfile queryYfile3(String database,String fileNm){
		try {
			return this.yfileWebDao.queryYfile3(database, fileNm);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
