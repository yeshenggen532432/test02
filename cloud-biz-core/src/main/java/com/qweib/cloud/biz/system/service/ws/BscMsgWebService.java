package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscDeptMsg;
import com.qweib.cloud.core.domain.BscTrueMsg;
import com.qweib.cloud.repository.ws.BscMsgWebDao;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscMsgWebService {
	@Resource
	private BscMsgWebDao bscMsgWebDao;

	/**
	  *@see 添加部门消息
	  *@param deptMsg
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-3-10
	 */
	public int addDeptMsg(BscDeptMsg deptMsg, String database) {
		try{
			return bscMsgWebDao.addDeptMsg(deptMsg,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	/**
	  *@see 添加真心话聊天信息
	  *@param trueMsg
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-3-17
	 */
	public int addTrueMsg(BscTrueMsg trueMsg, String database) {
		try{
			return bscMsgWebDao.addTrueMsg(trueMsg,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询聊天记录
	  *@param pId
	  *@param id
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-3-17
	 */
	public List queryNextMsg(Integer pId, Integer id,String tp,
			String database) {
		try{
			return bscMsgWebDao.queryNextMsg(pId,id,tp,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

}
