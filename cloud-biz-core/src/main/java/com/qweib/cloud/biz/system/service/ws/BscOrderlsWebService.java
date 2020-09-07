package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscOrderls;
import com.qweib.cloud.core.domain.BscOrderlsBb;
import com.qweib.cloud.core.domain.BscOrderlsDetail;
import com.qweib.cloud.repository.BscOrderlsWebDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscOrderlsWebService {
	@Resource
	private BscOrderlsWebDao orderlsWebDao;
	/**
	 *说明：分页查询订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsPage(String database,Integer memId,Integer branchId,Integer zt,Integer page,Integer limit,String kmNm,String sdate,String edate){
		try {
			return this.orderlsWebDao.queryOrderlsPage(database, memId, branchId, zt, page, limit, kmNm, sdate, edate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int addOrderls(BscOrderls order,List<BscOrderlsDetail> detail,String database) {
		try {
			this.orderlsWebDao.addOrderls(order, database);
			int id=this.orderlsWebDao.getAutoId();
			for(BscOrderlsDetail orderlsDetail:detail){
				orderlsDetail.setOrderId(id);
				this.orderlsWebDao.addOrderlsDetail(orderlsDetail, database);
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public void updateOrderls(BscOrderls order,List<BscOrderlsDetail> detail,String database) {
		try {
			this.orderlsWebDao.updateOrderls(order, database);
			this.orderlsWebDao.deleteOrderlsDetail(database, order.getId());
			for(BscOrderlsDetail orderlsDetail:detail){
				orderlsDetail.setOrderId(order.getId());
				this.orderlsWebDao.addOrderlsDetail(orderlsDetail, database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取订单信息
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public BscOrderls queryOrderlsOne(String database,Integer id){
		try {
			return this.orderlsWebDao.queryOrderlsOne(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取订单信息2
	 *@创建：作者:llp		创建时间：2016-9-1
	 *@修改历史：
	 *		[序号](llp	2016-9-1)<修改说明>
	 */
	public BscOrderls queryOrderlsOne2(String database,Integer cid){
		try {
			return this.orderlsWebDao.queryOrderlsOne2(database, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取订单详情
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public List<BscOrderlsDetail> queryOrderlsDetail(String database,Integer orderId){
		try {
			return this.orderlsWebDao.queryOrderlsDetail(database, orderId);
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
	public Page queryOrderlsBbPage(String database,Integer memId,Integer branchId,Integer zt,Integer page,Integer limit,String kmNm,String sdate,String edate,Integer cid){
		try {
			return this.orderlsWebDao.queryOrderlsBbPage(database, memId, branchId, zt, page, limit, kmNm, sdate, edate,cid);
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
	public BscOrderlsBb queryOrderlsBbById(Integer Id,String database){
		try {
			return this.orderlsWebDao.queryOrderlsBbById(Id, database); 
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int addOrderlsBb(BscOrderlsBb orderlsBb,String database) {
		try {
			return this.orderlsWebDao.addOrderlsBb(orderlsBb, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
