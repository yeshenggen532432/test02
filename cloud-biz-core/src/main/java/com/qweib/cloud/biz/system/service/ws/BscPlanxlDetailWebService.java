package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscPlanxlDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.BscPlanxlDetailWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscPlanxlDetailWebService {
	@Resource
	private BscPlanxlDetailWebDao planxlDetailWebDao;
	
	/**
	 *说明：分页查询计划线路详情
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public Page queryBscPlanxlDetailWeb(String database,Integer page,Integer limit,Integer xlId){
		try {
			return this.planxlDetailWebDao.queryBscPlanxlDetailWeb(database, page, limit, xlId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加计划线路详情
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public int addBscPlanxlDetailWeb(BscPlanxlDetail planxlDetail,String database) {
		try {
			return this.planxlDetailWebDao.addBscPlanxlDetailWeb(planxlDetail, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除计划线路详情
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public void deleteBscPlanxlDetailWeb(String database,Integer xlId,String cids) {
		try {
			this.planxlDetailWebDao.deleteBscPlanxlDetailWeb(database, xlId, cids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：查询计划线路详情ls
	 *@创建：作者:llp		创建时间：2016-8-16
	 *@修改历史：
	 *		[序号](llp	2016-8-16)<修改说明>
	 */
	public List<BscPlanxlDetail> queryPlanxlDetaills(String database,Integer xlId){
		try {
			return this.planxlDetailWebDao.queryPlanxlDetaills(database, xlId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
