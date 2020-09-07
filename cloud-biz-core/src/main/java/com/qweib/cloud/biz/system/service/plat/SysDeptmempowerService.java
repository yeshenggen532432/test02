package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.vo.SysUsrVO;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SysDeptmempowerService {

	@Resource
	private SysDeptmempowerDao deptmempowerDao;
	@Resource
	private SysDepartDao departDao;

	/**
	 * 查询部门人员权限树
	 * @param deptId
	 * @param tp
	 * @param datasource
	 * @return
	 */
	public List<SysUsrVO> queryMempowerForDept(Integer deptId,
											   String tp, String datasource) {
		return deptmempowerDao.queryMempowerForDept(deptId, tp, datasource);
	}

	/**
	 * 保存部门成员权限关系
	 */
	public void updateDeptmempower(Long[] usrIds, Integer deptId,
			String powertp, String datasource) {
		try{
			//删除部门成员权限关系
			this.deptmempowerDao.deleteDeptmempower(deptId, powertp, datasource);
			//批量添加部门成员权限关系
			if(null!=usrIds&&usrIds.length>0){
				this.deptmempowerDao.saveDeptmempower(usrIds, deptId, powertp, datasource);
			}
		}catch(Exception ex){
			throw new ServiceException(ex);
		}
	}
	public Map<String, Object> getPowerDept(String dataTp, Integer memberId, String datasource){
		Map<String, Object> returnMap = new HashMap<String, Object>();
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
		returnMap.put("mId", mId);
		returnMap.put("allDepts", allDepts);
		returnMap.put("invisibleDepts", invisibleDepts);
		return returnMap;
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

	/**
	 * 获取权限部门（可见或不可见）
	 * @param memberId
	 * @param tp
	 * @param datasource
	 * @return
	 */
	public String queryPowerDepts(Integer memberId, String tp, String datasource) {
		String visibleDepts = "";
		Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
		if (null!=visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
			visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
			visibleDepts = visibleDepts.substring(1, visibleDepts.length()-1).replace("-", ",");
		}
		return visibleDepts;
	}

	/**
	 *  获取用户可以查看的用户ids
	 */

	public String getMemberIds(String dataTp, Integer memberId, String datasource,String mIds){
		if(StrUtil.isNotNull(mIds)){
			return mIds;
		}else{
			String departIds = null;//部门
			Map<String, Object> visibleDepartMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, "1", datasource);
			Map<String, Object> invisibleDepartMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, "2", datasource);
			if ("1".equals(dataTp)){//查询全部部门
				Map<String, Object> allDepartMap = departDao.queryAllDeptsForMap(datasource);
				departIds = StrUtil.removeStr((String) allDepartMap.get("depts"), (String) invisibleDepartMap.get("depts"));
			} else if ("2".equals(dataTp)){//部门及子部门
				Map<String, Object> departMap = departDao.queryBottomDepts(memberId, datasource);
				departIds = StrUtil.addStr(StrUtil.removeStr((String) departMap.get("depts"), (String) invisibleDepartMap.get("depts")), (String) visibleDepartMap.get("depts"));
			} else if ("3".equals(dataTp)){//个人
				return "" + memberId;
			}
			if(StrUtil.isNull(departIds)){
				return "";
			}
			List<SysMember> memberList = departDao.queryUserMemBerIds(datasource, departIds);
			if(Collections3.isNotEmpty(memberList)){
				for (SysMember member: memberList) {
					if(StrUtil.isNull(mIds)){
						mIds = "" + member.getMemberId();
					}else {
						mIds += "," + member.getMemberId();
					}
				}
			}
		}
		return mIds;
	}


}
