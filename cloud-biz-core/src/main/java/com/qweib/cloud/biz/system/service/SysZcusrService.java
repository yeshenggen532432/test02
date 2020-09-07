package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.repository.SysZcusrDao;
import com.qweib.cloud.core.domain.SysZcusr;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysZcusrService {
	@Resource
	private SysZcusrDao zcusrDao;
	@Resource
	private SysDepartDao departDao; 
	@Resource
	private SysDeptmempowerDao deptmempowerDao;
	
	/**
	 * 
	 * 摘要：
	 * @说明：查询用户用于分配用户
	 * @创建：作者:llp 创建时间：2016-6-3
	 * @修改历史： [序号](llp 2016-6-3)<修改说明>
	 */
	public List<Map<String,Object>> queryUsrForRole(Integer zusrId,String database){
		try{
			return this.zcusrDao.queryUsrForRole(zusrId,database);
		}catch(Exception e){
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 * 摘要：
	 * @说明：批量添加人员分配人员
	 * @创建：作者:llp 创建时间：2016-6-3
	 * @修改历史： [序号](llp 2016-6-3)<修改说明>
	 */
	public void addZcUsr(Integer[] cusrIds,Integer zusrId,String database){
		try{
			//删除人员分配用户表
			this.zcusrDao.deleteZcUsr(zusrId, database);
			//批量添加人员分配人员表
			if(null!=cusrIds&&cusrIds.length>0){
				this.zcusrDao.addZcUsr(cusrIds, zusrId, database);
			}
		}catch(Exception ex){
			throw new ServiceException(ex);
		}
	}
	/**
	 *说明：获取人员数组
	 *@创建：作者:llp		创建时间：2016-6-3
	 *@修改历史：
	 *		[序号](llp	2016-6-3)<修改说明>
	 */
	public SysZcusr querycusrIds(String database,Integer zusrId) {
		try {
			return this.zcusrDao.querycusrIds(database, zusrId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取人员数组（总的）
	 *@创建：作者:llp		创建时间：2016-6-30
	 *@修改历史：
	 *		[序号](llp	2016-6-30)<修改说明>
	 */
	public SysZcusr querycusrIdsz(SysLoginInfo info, String dataTp) {
		try {
			String datasource = info.getDatasource();
			Integer memberId = info.getIdKey();
			String depts = "";//部门
			String visibleDepts = "";//可见部门
			String invisibleDepts = "";//不可见部门
			Integer mId = null;//是否个人
			if ("1".equals(dataTp)){//查询全部部门
				Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
				if (null!=allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
					depts = (String) allDeptsMap.get("depts");
				}
			} else if ("2".equals(dataTp)){//部门及子部门
				Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
				if (null!=map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
					String dpt = (String) map.get("depts");
					depts = dpt.substring(0,dpt.length()-1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
				}
			} else if ("3".equals(dataTp)){//个人
				mId = memberId;
			}
			//查询可见部门(如：-4-，-7-4-)
			visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
			//查询不可见部门
			invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
			String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
			return this.zcusrDao.querycusrIdsz(mId, allDepts, invisibleDepts, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	//获取权限部门（可见或不可见）
	private String getPowerDepts(String datasource, Integer memberId,String tp, 
			String visibleDepts) {
		Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
		if (null!=visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
			visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
			visibleDepts = visibleDepts.substring(1, visibleDepts.length()-1).replace("-", ",");
		}
		return visibleDepts;
	}
}
