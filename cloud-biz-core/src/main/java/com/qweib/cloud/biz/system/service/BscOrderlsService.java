package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.BscOrderlsDao;
import com.qweib.cloud.core.domain.BscOrderls;
import com.qweib.cloud.core.domain.BscOrderlsBb;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class BscOrderlsService {
	@Resource
	private BscOrderlsDao orderlsDao;
	
	/**
	 *说明：分页查询订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsPage1(BscOrderls order,Integer page,Integer limit){
		try {
			return this.orderlsDao.queryOrderlsPage1(order, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsBbPage1(BscOrderlsBb orderlsBb,Integer page,Integer limit){
		try {
			return this.orderlsDao.queryOrderlsBbPage1(orderlsBb, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *@说明：修改订单审核
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int updateOrderlsSh(String database,Integer id,String sh){
		try {
			return this.orderlsDao.updateOrderlsSh(database, id, sh);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *@说明 修改结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int updateOrderBbJg(String database,BscOrderlsBb orderlsBb){
		try {
			return this.orderlsDao.updateOrderBbJg(database, orderlsBb);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public BscOrderlsBb queryOrderlsBbOne(String database,Integer id){
		try {
			return this.orderlsDao.queryOrderlsBbOne(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
