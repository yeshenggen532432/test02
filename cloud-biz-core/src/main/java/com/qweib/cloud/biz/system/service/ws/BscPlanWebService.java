package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.BscPlanWebDao;
import com.qweib.cloud.repository.BscPlanxlDetailWebDao;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class BscPlanWebService {
	@Resource
	private BscPlanWebDao planWebDao;
	@Resource
	private SysDepartDao departDao;
	@Resource
	private SysDeptmempowerDao deptmempowerDao;
	@Resource
	private BscPlanxlDetailWebDao planxlDetailWebDao;
	
	/**
	 *说明：分页查询计划(我的拜访)
	 *@创建：作者:llp		创建时间：2016-8-2
	 *@修改历史：
	 *		[序号](llp	2016-8-2)<修改说明>
	 */
	public Page queryBscPlanWeb(String database,Integer page,Integer limit,String pdate,Integer mid,Integer branchId,String tp,String mids){
		try {
			return this.planWebDao.queryBscPlanWeb(database, page, limit, pdate, mid, branchId, tp,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	 *说明：分页查询计划(我的拜访)(新的)
	 */
	public BscPlanNew queryBscPlanNewWeb(String database,String pdate,Integer mid){
		try {
			return this.planWebDao.queryBscPlanNewWeb(database, pdate, mid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询计划(下属)(新的)
	 */
	public Page queryBscPlanNewUnderlingWeb(String database, String pdate, int mid, String mids, int pageNo, int pageSize, String visibleBranch, String invisibleBranch){
		try {
			Page page = this.planWebDao.queryBscPlanNewUnderlingWeb(database, pdate, mid, mids, pageNo, pageSize, visibleBranch, invisibleBranch);
			List<BscPlanNew> list = page.getRows();
			if(list != null && list.size() > 0){
				for (BscPlanNew plan : list){
					List<BscPlanSub> subList = this.planWebDao.queryBscPlanSubList(database, plan.getId());
					plan.setSubList(subList);
				}
			}
			return page;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询计划(我的拜访明细)(新的)
	 */
	public Page queryBscPlanSubWeb(String database, Integer pid, Integer mid,Integer page,Integer limit){
		try {
			return this.planWebDao.queryBscPlanSubWeb(database, pid, mid, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	//分页查询计划(下属拜访)
	public Page queryBscPlanWebForUnderling(String datasource,Integer page,Integer limit,String pdate,Integer mid,
			Integer branchId,String tp,String mids, String dataTp){
		try {
			String visibleDepts = "";//可见部门
			String invisibleDepts = "";//不可见部门
			String depts = "";//部门
			if ("1".equals(dataTp)){//查询全部部门
				Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
				if (null!=allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
					depts = (String) allDeptsMap.get("depts");
				}
			} else if ("2".equals(dataTp)){//部门及子部门
				Map<String, Object> map = departDao.queryBottomDepts(mid, datasource);
				if (null!=map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
					String dpt = (String) map.get("depts");
					depts = dpt.substring(0,dpt.length()-1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
				}
			}
			//查询可见部门(如：-4-，-7-4-)
			visibleDepts = getPowerDepts(datasource, mid, "1", visibleDepts);
			//查询不可见部门
			invisibleDepts = getPowerDepts(datasource, mid, "2", invisibleDepts);
			String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
			return this.planWebDao.queryBscPlanWebForUnderling(datasource, page, limit, pdate, mid, branchId, tp,mids, allDepts, invisibleDepts);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	//获取权限部门（可见或不可见）
	private String getPowerDepts(String datasource, Integer memberId, String tp, String visibleDepts) {
		Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
		if (null!=visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
			visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
			visibleDepts = visibleDepts.substring(1, visibleDepts.length()-1).replace("-", ",");
		}
		return visibleDepts;
	}
	/**
	 *说明：计划完成数
	 *@创建：作者:llp		创建时间：2016-8-2
	 *@修改历史：
	 *		[序号](llp	2016-8-2)<修改说明>
	 */
	public int queryBscPlanWebCount(String database,String pdate,Integer mid,Integer branchId,String tp,String mids){
		try {
			return this.planWebDao.queryBscPlanWebCount(database, pdate, mid, branchId, tp,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：计划拜访完成数
	 * pid:计划id
	 */
	public int queryBscPlanNewWebCount(String database, Integer pid){
		try {
			return this.planWebDao.queryBscPlanNewWebCount(database, pid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	//计划完成数(下属拜访)
	public int queryBscPlanWebCountForUnderling(String datasource,String pdate,Integer mid,
			Integer branchId,String tp,String mids, String dataTp){
		try {
			String visibleDepts = "";//可见部门
			String invisibleDepts = "";//不可见部门
			String depts = "";//部门
			if ("1".equals(dataTp)){//查询全部部门
				Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
				if (null!=allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
					depts = (String) allDeptsMap.get("depts");
				}
			} else if ("2".equals(dataTp)){//部门及子部门
				Map<String, Object> map = departDao.queryBottomDepts(mid, datasource);
				if (null!=map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
					String dpt = (String) map.get("depts");
					depts = dpt.substring(0,dpt.length()-1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
				}
			}
			//查询可见部门(如：-4-，-7-4-)
			visibleDepts = getPowerDepts(datasource, mid, "1", visibleDepts);
			//查询不可见部门
			invisibleDepts = getPowerDepts(datasource, mid, "2", invisibleDepts);
			String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
			return this.planWebDao.queryBscPlanWebCountForUnderling(datasource, pdate, mid, branchId, tp,mids, allDepts, invisibleDepts);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加计划
	 *@创建：作者:llp		创建时间：2016-8-2
	 *@修改历史：
	 *		[序号](llp	2016-8-2)<修改说明>
	 */
	public int addBscPlanWeb(BscPlan plan,String database) {
		try {
			return this.planWebDao.addBscPlanWeb(plan, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	 *说明：添加计划（新的）
	 */
	public int addBscPlanNewWeb(String database, String pdate, Integer xlId, SysMember member) {
		try {
			//添加拜访计划
			BscPlanNew plan = new BscPlanNew();
			plan.setMid(member.getMemberId());
			plan.setBranchId(member.getBranchId());
			plan.setPdate(pdate);
			plan.setXlid(xlId);
			int id = this.planWebDao.addBscPlanNewWeb(plan, database);

			//添加拜访明细
			List<BscPlanxlDetail> list1 = this.planxlDetailWebDao.queryPlanxlDetaills(database, xlId);
			for (int i = 0; i < list1.size(); i++) {
				BscPlanSub subPlan = new BscPlanSub();
				subPlan.setPid(id);
				subPlan.setCid(list1.get(i).getCid());
				subPlan.setIsWc(2);//1:完成 2：未完成
				this.planWebDao.addBscPlanSubWeb(subPlan, database);
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	 *说明：删除计划
	 *@创建：作者:llp		创建时间：2016-8-2
	 *@修改历史：
	 *		[序号](llp	2016-8-2)<修改说明>
	 */
	public void deleteBscPlanWeb(String database,Integer id) {
		try {
			this.planWebDao.deleteBscPlanWeb(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改计划状态
	 *@创建：作者:llp		创建时间：2016-8-2
	 *@修改历史：
	 *		[序号](llp	2016-8-2)<修改说明>
	 */
	public void updateBscPlanWeb(String database,Integer mid,Integer cid,String pdate) {
		try {
			this.planWebDao.updateBscPlanWeb(database, mid, cid, pdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改计划状态(新的)
	 */
	public void updateBscPlanNewWeb(String database,Integer mid,Integer cid,String pdate) {
		try {
			//查询拜访计划
			//根据拜访计划修改状态
			BscPlanNew plan = this.planWebDao.queryBscPlanNewWeb(database, pdate, mid);
			if(plan != null){
				this.planWebDao.updateBscPlanNewWeb(database, plan.getId(), cid);
			}

		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改计划状态(新的)
	 */
	public void updateBscPlanNewWeb(String database, BscPlanNew plan) {
		try {
			//修改主表
			int updateCount = this.planWebDao.updateBscPlanNewWeb(database, plan);
			//修改明细:1)删除原来的 2）添加
			int deleteCount = this.planWebDao.deleteBscPlanSubWeb(database, plan.getId());
			List<BscPlanxlDetail> list1 = this.planxlDetailWebDao.queryPlanxlDetaills(database, plan.getXlid());
			for (int i = 0; i < list1.size(); i++) {
				BscPlanSub subPlan = new BscPlanSub();
				subPlan.setPid(plan.getId());
				subPlan.setCid(list1.get(i).getCid());
				subPlan.setIsWc(2);//1:完成 2：未完成
				this.planWebDao.addBscPlanSubWeb(subPlan, database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int queryPlanByMCDCount(String database,Integer mid,Integer cid,String pdate){
		try {
			return this.planWebDao.queryPlanByMCDCount(database, mid, cid, pdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取计划信息是否存在
	 *@创建：作者:llp		创建时间：2016-8-9
	 *@修改历史：
	 *		[序号](llp	2016-8-9)<修改说明>
	 */
	public List queryPlanByCids(String cids,Integer mid,String pdate,String database) {
		try {
			return this.planWebDao.queryPlanByCids(cids, mid, pdate, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据日期获取业务员拜访
	 *@创建：作者:llp		创建时间：2016-8-23
	 *@修改历史：
	 *		[序号](llp	2016-8-23)<修改说明>
	 */
	public List queryPlanByPdate(String pdate,String database) {
		try {
			return this.planWebDao.queryPlanByPdate(pdate, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
