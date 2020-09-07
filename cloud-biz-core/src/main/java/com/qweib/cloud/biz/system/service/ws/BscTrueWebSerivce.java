package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscTrue;
import com.qweib.cloud.repository.ws.BscTrueWebDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class BscTrueWebSerivce {
	@Resource
	private BscTrueWebDao bscTrueWebDao;
	
	/**
	 * 真心话分页查询
	 */
	public Page page(BscTrue bsctrue, Integer page, Integer rows,String database) {
		try {
			return bscTrueWebDao.page(bsctrue, page, rows,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 通过trueId获取真心话(标题，内容)
	 */
	public BscTrue queryTrueByTid(Integer trueId,String database){
		try {
			return bscTrueWebDao.queryTrueByTid(trueId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
