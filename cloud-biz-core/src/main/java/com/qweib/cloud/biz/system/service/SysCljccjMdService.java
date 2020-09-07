package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysCljccjMdDao;
import com.qweib.cloud.core.domain.SysCljccjMd;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCljccjMdService {
	@Resource
	private SysCljccjMdDao cljccjMdDao;
	/**
	 *说明：列表查陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public List<SysCljccjMd> queryCljccjMdls(String database){
		try {
			return this.cljccjMdDao.queryCljccjMdls(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：批量修改陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
     *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public void updateCljccjMdLs(List<SysCljccjMd> detail,String database){
		try {
			this.cljccjMdDao.updateCljccjMdLs(detail, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
