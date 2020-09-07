package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysCorporationtp;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.SysCorporationtpDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCorporationtpService {
	@Resource
	private SysCorporationtpDao corporationtpDao;
	
	/**
	 *说明：获取公司类型列表
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public List<SysCorporationtp> queryGsTpLs(){
		try {
			return this.corporationtpDao.queryGsTpLs();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
