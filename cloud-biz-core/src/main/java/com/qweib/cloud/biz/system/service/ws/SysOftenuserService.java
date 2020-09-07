package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysOftenuser;
import com.qweib.cloud.repository.ws.SysMemBindDao;
import com.qweib.cloud.repository.ws.SysOftenuserDao;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysOftenuserService {
	@Resource
	private SysOftenuserDao sysOftenuserDao;
	@Resource
	private SysMemBindDao memBindDao;
	
	/**
	 * 添加常用联系人
	 */
	public void addCyuser(String datasource,SysOftenuser oftenuser){
		try{
			sysOftenuserDao.deleteCyuser(datasource, oftenuser.getMemberId(), oftenuser.getBindMemberId());
			 this.sysOftenuserDao.addCyuser(datasource,oftenuser);
			 Integer memberId = oftenuser.getMemberId();
			 Integer bindMemberId = oftenuser.getBindMemberId();
			 Integer info = memBindDao.queryIsMyFriends(memberId,bindMemberId,1);//查询是否为好友关系
			 if(info>0){//设置好友常用
				 memBindDao.updateMemberbindByused("1", memberId,bindMemberId);
			 }
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 删除常用联系人
	 */
	public void deleteCyuser(String datasource,Integer memberId,Integer cyId){
		try{
			 this.sysOftenuserDao.deleteCyuser(datasource,memberId, cyId);
			 Integer info = memBindDao.queryIsMyFriends(memberId,cyId,1);//查询是否为好友关系
			 if(info>0){//设置好友常用
				 memBindDao.updateMemberbindByused("2", memberId,cyId);
			 }
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
