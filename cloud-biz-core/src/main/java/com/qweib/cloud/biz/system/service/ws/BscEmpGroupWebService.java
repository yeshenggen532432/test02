package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscEmpGroupMember;
import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.repository.ws.SysMemWebDao;
import com.qweib.cloud.core.domain.BscEmpgroupDTO;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class BscEmpGroupWebService {
	@Resource
	private BscEmpGroupWebDao bscEmpGroupWebDao;
	@Resource
	private SysMemWebDao memWebDao;

	public void addGroup(BscEmpgroup empGroup,String memIds,String adminIds,BscEmpGroupMember groupMem,Integer memberId,String database,String isOpen) {
		try{
			Integer groupId = bscEmpGroupWebDao.addGroup(empGroup,database);
			groupMem.setGroupId(groupId);
			bscEmpGroupWebDao.addGroupMem(groupMem,database);
			String time = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
			if("1".equals(isOpen) ){//公开圈
				if(null!=database && !"".equals(database)){
					List<Map<String,Object>> mIds = memWebDao.queryMemIdOutId(memberId,memIds,adminIds,database);//查询除成员外的其他成员ids
					if(null!=mIds.get(0).get("mids")){
						memIds = (String) mIds.get(0).get("mids");
					}
				}
			}else{//私有圈
				if("2".equals(empGroup.getLeadShield())){//批量添加VIP成员
					List<Map<String,Object>> members = memWebDao.queryLeadMemIds(database,memberId,memIds,adminIds);
					if(null!=members.get(0).get("mems")){
						String mems = members.get(0).get("mems").toString();//查询领导ids
						String[] ids = mems.split(",");
						time = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
						bscEmpGroupWebDao.addGroupMems(ids, groupId,"4",time,database);
					}
				}
			}
			//批量添加普通成员
			if(!StrUtil.isNull(memIds)){
				String[] mIds = memIds.split(",");
				bscEmpGroupWebDao.addGroupMems(mIds,groupId,"3",time,database);//批量添加
			}
			//批量添加管理员
			if(!StrUtil.isNull(adminIds)){
				String[] admIds = adminIds.split(",");
				bscEmpGroupWebDao.addGroupMems(admIds,groupId,"2",time,database);//批量添加
			}
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 获取当前用户所在员工圈
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-1-29
	 */
	public Page queryAllGroup(Integer memId,String database,Integer pageNo,Integer pageSize) { 
		try{
//			Page p = new Page();
//			Integer isLead = memWebDao.queryIsLead(memId,database);
//			if(isLead>0){//是领导(所在公司不屏蔽的所有员工圈+其他公司所在的员工圈)
//				p = bscEmpGroupWebDao.queryLeadGroup(memId,database,pageNo,pageSize);
//			}else{//不是领导
//			Page p = bscEmpGroupWebDao.queryAllGroup(memId,pageNo,pageSize);
//			}
			return bscEmpGroupWebDao.queryAllGroup(memId,database,pageNo,pageSize);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 知识库员工圈列表
	  *@param memId
	  *@param database
	  *@param pageNo
	  *@param i
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-21
	 */
	public Page queryGroupKnowledge(Integer memId, String database,String searchContent,
			Integer pageNo, Integer pageSize) {
		try{
			return bscEmpGroupWebDao.queryGroupKnowledge(memId,database,searchContent,pageNo,pageSize);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 查找员工圈所有成员id
	  *@param tpId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-2
	 */
	public List<SysMemDTO> querymIds(Integer tpId,String database) {
		try{
			return bscEmpGroupWebDao.querymIds(tpId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 圈资料详情
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-3
	 */
	public BscEmpgroupDTO queryGroupDetail(Integer groupId,Integer memId,String database) {
		try{
			BscEmpgroupDTO empGroup = bscEmpGroupWebDao.queryGroupDetail(groupId,memId,database);
			if(!"0".equals(empGroup.getInGroup())){//圈成员
				BscEmpGroupMember empMember = bscEmpGroupWebDao.queryGroupMem(memId, groupId,database);
				empGroup.setRole(empMember.getRole());
				empGroup.setRemindFlag(empMember.getRemindFlag());
				empGroup.setTopFlag(empMember.getTopFlag());
			}
			empGroup.setAdminList(bscEmpGroupWebDao.queryGroupMems(groupId,"2",database));//管理员
			empGroup.setMemList(bscEmpGroupWebDao.queryGroupMems(groupId,"3",database));//普通成员
			return empGroup;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
//删除圈成员
	public Integer deleteGroup(Integer groupId, Integer memId,String datasource) {
		try{
			Integer info = null;
			BscEmpgroup emp = bscEmpGroupWebDao.queryGroupById(groupId, datasource);
			if("1".equals(emp.getIsOpen())){//公开圈
				String[] memIds = new String[]{memId.toString()};
				String dateToStr = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
				bscEmpGroupWebDao.updateMemRoleBatch(memIds, groupId, "3",dateToStr, datasource);
				info=1;
			}else{
				info=bscEmpGroupWebDao.deleteGroup(groupId, memId,datasource);
			}
			return info;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 根据id查找圈成员信息
	  *@param memId
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	public BscEmpGroupMember queryGroupMem(Integer memId, Integer groupId,String datasource) {
		try{
			return bscEmpGroupWebDao.queryGroupMem(memId,groupId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询不在圈内的企业成员
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	public Page queryNotInMems(Integer groupId,Integer memId,Integer pageNo,Integer pageSize,String searchContent,String datasource,String ids) {
		try{
			Page p = new Page();
			if(null!=groupId){
				BscEmpgroup emp = bscEmpGroupWebDao.queryGroupById(groupId, datasource);
				if("1".equals(emp.getIsOpen())){
					p = bscEmpGroupWebDao.queryOpenNotInMems(groupId,pageNo,pageSize,datasource);
				}else{
					p=bscEmpGroupWebDao.queryNotInMems(groupId,memId,pageNo,pageSize,searchContent,datasource,ids);
				}
			}else{
				p=bscEmpGroupWebDao.queryNotInMems(groupId,memId,pageNo,pageSize,searchContent,datasource,ids);
			}
			return p; 
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 添加圈成员
	  *@param groupMem
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	public Integer addGroupMem(BscEmpGroupMember groupMem,Integer receiveId,Integer memId,Integer belongId,String tp,String agree,String datasource) {
		try{
//			invitationDao.updateInAgree(receiveId,memId,belongId,tp,agree);
//			taskMsgService.updateInAgree(receiveId,memId,belongId,tp,agree);
			Integer jude = bscEmpGroupWebDao.addGroupMem(groupMem,datasource);
			return jude;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 员工圈置顶或取消置顶
	  *@param groupId
	  *@param isTop
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	public void updateGroupTop(Integer groupId,Integer memId, String isTop,String datasource) {
		try{
			bscEmpGroupWebDao.updateGroupTop(groupId,memId,isTop,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 根据id查询员工圈
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-6
	 */
	public BscEmpgroup queryGroupById(Integer groupId,String database) {
		try{
			return bscEmpGroupWebDao.queryGroupById(groupId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查找圈群主
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-6
	 */
	public SysMemDTO queryAdmins(Integer groupId,String database) {
		try{
			return bscEmpGroupWebDao.queryAdmins(groupId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 免打扰设置
	  *@param groupId
	  *@param remindFlag
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-2-8
	 */
	public void updateGroupRemind(Integer groupId,Integer memId, String remindFlag,String datasource) {
		try{
			 bscEmpGroupWebDao.updateGroupRemind(groupId,memId,remindFlag,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 领导屏蔽或取消屏蔽设置
	  *@param groupId
	  *@param memId
	  *@param leadShield
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-3-6
	 */
	public void updateGroupShield(Integer groupId,
			String leadShield,Integer memberId, String database) {
		List<Map<String,Object>> mems = null;
		try{
			if(!"".equals(database)){
				if("1".equals(leadShield)){//屏蔽
//					if(null!=mems.get(0).get("mems")){
						bscEmpGroupWebDao.deleteGroupMems(groupId,database);//删除vip的圈成员（多个）
//					}
				}else if("2".equals(leadShield)){//不屏蔽
					mems = memWebDao.queryLmemIds(database,memberId,groupId);//查询不在圈内的领导ids
					if(null!=mems.get(0).get("mems")){
						String[] ids = mems.get(0).get("mems").toString().split(",");
						String time = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
						bscEmpGroupWebDao.addGroupMems(ids, groupId,"4",time,database);
					}
				}
			}
			 bscEmpGroupWebDao.updateGroupShield(groupId,leadShield,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
		
	}

	/**
	  *@see 修改圈信息
	  *@param groupId
	  *@param groupNm
	  *@param groupDesc
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-2-10
	 */
	public void updateGroup(Integer groupId, String groupNm, String groupDesc,String groupHead,String datasource) {
		try{
			bscEmpGroupWebDao.updateGroup(groupId,groupNm,groupDesc,groupHead,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询圈成员
	  *@param groupId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-11
	 */
	public List<SysMemDTO> queryGroupAllMem(Integer groupId,String datasource) {
		try{
			List<SysMemDTO> memList = null;
			BscEmpgroup emp = bscEmpGroupWebDao.queryGroupById(groupId, datasource);
			if("1".equals(emp.getIsOpen())){//公开圈
				memList = bscEmpGroupWebDao.queryOpenGroupAllMem(groupId,datasource);
			}else{
				memList = bscEmpGroupWebDao.queryGroupAllMem(groupId,datasource);
			}
			return memList;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 圈聊天查询聊天记录
	  *@param groupId
	  *@param msgId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-12
	 *//*
	public List<BscEmpGroupMsg> queryMsgForNext(Integer groupId, Integer msgId,String database) {
		try{
			 return bscEmpGroupWebDao.queryMsgForNext(groupId,msgId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}*/

	/**
	  *@see 批量添加员工圈成员
	  *@param memIds
	  *@param memId
	  *@param time
	  *@创建：作者:YYP		创建时间：2015-3-3
	 */
	public void addGroupMems(String[] memIds, Integer groupId, String role,
			String time,String datasource) {
		try{
			BscEmpgroup emp = bscEmpGroupWebDao.queryGroupById(groupId, datasource);
			if("1".equals(emp.getIsOpen())){//公开圈
				bscEmpGroupWebDao.updateMemRoleBatch(memIds,groupId,role,time,datasource);
			}else{
				bscEmpGroupWebDao.addGroupMems(memIds,groupId,role,time,datasource);
			}
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询是否在圈里面
	  *@param groupId
	  *@param memId
	  *@return
	  *@创建：作者:YYP		创建时间：2015-4-3
	 */
	public Integer queryIsInGroup(Integer groupId, Integer memId,String datasource) {
		try{
			return  bscEmpGroupWebDao.queryIsInGroup(groupId,memId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	/**
	  *@see 查找圈主+管理员
	  *@param groupId
	  *@param tp
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-18
	 */
	public List<SysMemDTO> queryAdminsAll(Integer groupId, String tp,
			String datasource) {
		return bscEmpGroupWebDao.queryAdminsAll(groupId,tp,datasource);
	}

	/**
	  *@see @功能查询圈成员
	  *@param memId
	  *@param groupId
	  *@param token
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public Page queryAitaMemPage(Integer memId, Integer groupId, String datasource,Integer pageNo,Integer pageSize,String search) {
		try{
			return bscEmpGroupWebDao.queryAitaMemPage(memId,groupId,datasource,pageNo,pageSize,search);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 根据分类id查询圈成员信息
	  *@param sortId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public BscEmpGroupMember queryGroupBySortid(Integer memId,Integer sortId,
			String datasource) {
		try{
			return bscEmpGroupWebDao.queryGroupBySortid(memId,sortId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	
	
}
