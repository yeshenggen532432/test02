package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysCheckInPC;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.repository.company.SysCheckInPcDao;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class SysCheckInPcService {
	@Resource
	private SysCheckInPcDao checkInDaoPC;
	@Resource
	private SysDepartDao departDao;
	@Resource
	private SysDeptmempowerDao deptmempowerDao;

	/**
	  *@see 分页查询签到记录
	  *@param checkIn
	  *@param page
	  *@param rows
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Jul 31, 2015
	 */
	public Page page(Integer psnId,String memberNm,Integer branchId,String atime,String btime, String dataTp, Integer memberId,  
			Integer page, Integer rows,String datasource) {
		try{
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
			Page p = checkInDaoPC.queryCheckInByPage(psnId,memberNm,branchId,atime,btime,page,rows,datasource, mId, allDepts, invisibleDepts);
			List<SysCheckInPC> list = p.getRows();
			if(list.size() == 0)return p;
			String ids = "";
			for(SysCheckInPC vo: list)
			{
				if(ids.length() == 0)ids = vo.getId().toString();
				else ids = ids + "," + vo.getId();
			}
			List<SysCheckinPic> subList = this.checkInDaoPC.querycheckInPic(ids, datasource);
			for(SysCheckInPC vo: list)
			{
				List<SysCheckinPic> picList = new ArrayList<SysCheckinPic>();
				for(SysCheckinPic pic: subList)
				{
					if(vo.getId().intValue() == pic.getCheckinId().intValue())
					{
						picList.add(pic);
					}
				}
				vo.setPicList(picList);
			}
			return p;
		}catch (Exception e) {
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

	/**
	  *@see 根据条件查询签到记录（list）
	  *@param memNm
	  *@param time1
	  *@param time2
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 3, 2015
	 */
	public List<SysCheckInPC> queryCheckInList(String memNm, String time1,
			String time2,Integer branchId, String datasource) {
		try{
			return checkInDaoPC.queryCheckInList(memNm,time1,time2,branchId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	

}
