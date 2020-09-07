package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysLogisticsDao;
import com.qweib.cloud.core.domain.SysLogistics;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysLogisticsService {
	@Resource
	private SysLogisticsDao logisticsDao;
	
	/**
	 *说明：分页查询物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public Page queryLogistics(SysLogistics logistics,Integer page,Integer limit){
		try {
			return this.logisticsDao.queryLogistics(logistics, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public int addLogistics(SysLogistics logistics){
		try {
			return this.logisticsDao.addLogistics(logistics);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public int updateLogistics(SysLogistics logistics){
		try {
			return this.logisticsDao.updateLogistics(logistics);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public SysLogistics queryLogisticsById(Integer Id){
		try {
			return this.logisticsDao.queryLogisticsById(Id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
