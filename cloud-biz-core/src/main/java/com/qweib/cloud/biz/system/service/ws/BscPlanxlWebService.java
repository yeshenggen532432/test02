package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscPlanNew;
import com.qweib.cloud.core.domain.BscPlanSub;
import com.qweib.cloud.core.domain.BscPlanxl;
import com.qweib.cloud.core.domain.BscPlanxlDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.BscPlanxlDetailWebDao;
import com.qweib.cloud.repository.BscPlanxlWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscPlanxlWebService {
	@Resource
	private BscPlanxlWebDao planxlWebDao;
	@Resource
	private BscPlanxlDetailWebDao planxlDetailWebDao;

	/**
	 *说明：分页查询计划线路
	 *创建时间：2016-8-15
	 *(llp	2016-8-15)<修改说明>
	 */
	public Page queryBscPlanxlWeb(String database,Integer mid,Integer pageNo,Integer pageSize,String xlNm){
		try {
			Page page = this.planxlWebDao.queryBscPlanxlWeb(database,mid, pageNo, pageSize, xlNm);
			List<BscPlanxl> list = page.getRows();
			if(list != null && list.size() > 0){
				for (BscPlanxl planXl : list){
					List<BscPlanxlDetail> children = this.planxlWebDao.queryBscPlanxlDetailWeb(database, planXl.getId());
					planXl.setChildren(children);
				}
			}
			return page;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public int addBscPlanxlWeb(BscPlanxl planxl,String database) {
		try {
			this.planxlWebDao.addBscPlanxlWeb(planxl, database);
			int id=this.planxlWebDao.queryAutoId();
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public void updateBscPlanxlWeb(String database,Integer id,String xlNm) {
		try {
			this.planxlWebDao.updateBscPlanxlWeb(database, id, xlNm);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改计划线路
	 */
	public void updateBscPlanxlWeb2(String database,Integer id,String xlNm, String cids) {
		try {
			//删除原来的cids
			this.planxlWebDao.deleteBscPlanxlDetail(database, id);
			//修改线路名称
			this.planxlWebDao.updateBscPlanxlWeb(database, id, xlNm);
			//添加线路cids
			String[] split = cids.split(",");
			for (String s : split) {
				BscPlanxlDetail planxlDetail = new BscPlanxlDetail();
				planxlDetail.setCid(Integer.parseInt(s));
				planxlDetail.setXlId(id);
				this.planxlDetailWebDao.addBscPlanxlDetailWeb(planxlDetail, database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public void deleteBscPlanxlWeb(String database,Integer id) {
		try {
			this.planxlWebDao.deleteBscPlanxlWeb(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
