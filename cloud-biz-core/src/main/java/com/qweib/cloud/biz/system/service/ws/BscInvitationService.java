package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscInvitation;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.BscInvitationDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscInvitationService {
	@Resource
	private BscInvitationDao invitationDao;

	

	/**
	  *@see 添加邀请信息记录
	  *@param ivMsgs
	  *@创建：作者:YYP		创建时间：2015-4-2
	 */
	public void addInvitationMsgs(List<BscInvitation> ivMsgs) {
		try{
			invitationDao.addInvitationMsgs(ivMsgs);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}



	/**
	  *@see 修改同意或不同意操作
	  *@param receiveId
	  *@param memId
	  *@param belongId
	  *@param tp
	  *@param idTp
	  *@创建：作者:YYP		创建时间：2015-4-3
	 */
	public Integer updateInAgree(Integer receiveId, Integer memId, Integer belongId,
			String tp, String idTp) {
		try{
			return invitationDao.updateInAgree(receiveId,memId,belongId,tp,idTp);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
