package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysReportCdDao;
import com.qweib.cloud.core.domain.SysReportCd;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysReportCdService {
	@Resource
	private SysReportCdDao reportCdDao;
	
	/**
	 * 
	 *摘要：
	 *@说明：获取日报文字长度设置信息
	 *@创建：作者:llp		创建时间：2017-5-19
	  *@修改历史：
	 *		[序号](llp	2017-5-19)<修改说明>
	 */
	public SysReportCd queryReportCd(String database,Integer id){
		try {
			return this.reportCdDao.queryReportCd(database,id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：修改日报文字长度设置信息
	 *@创建：作者:llp		创建时间：2017-5-19
	  *@修改历史：
	 *		[序号](llp	2017-5-19)<修改说明>
	 */
	public int updateReportCd(SysReportCd reportCd,String database){
		try {
			return this.reportCdDao.updateReportCd(reportCd, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
