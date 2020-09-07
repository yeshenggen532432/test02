package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysYfilepwd;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysYfilepwdWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysYfilepwdWebService {
	@Resource
	private SysYfilepwdWebDao yfilepwdWebDao;
	
	/**
	 *说明：添加云文件密码
	 *@创建：作者:llp		创建时间：2016-11-18
	 *@修改历史：
	 *		[序号](llp	2016-11-18)<修改说明>
	 */
	public int addYfilepwd(SysYfilepwd Yfilepwd,String database) {
		try {
			return this.yfilepwdWebDao.addYfilepwd(Yfilepwd, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改云文件密码
	 *@创建：作者:llp		创建时间：：2016-11-18
	 *@修改历史：
	 *		[序号](llp	：2016-11-18)<修改说明>
	 */
	public void updateYfilepwd(String database,String yfPwd,Integer memberId) {
		try {
			this.yfilepwdWebDao.updateYfilepwd(database, yfPwd, memberId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取云文件密码
	 *@创建：作者:llp		创建时间：2016-11-18
	 *@修改历史：
	 *		[序号](llp	2016-11-18)<修改说明>
	 */
	public SysYfilepwd queryYfilepwd(String database,Integer memberId){
		try {
			return this.yfilepwdWebDao.queryYfilepwd(database, memberId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
