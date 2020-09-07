package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysTaskMsg;
import com.qweib.cloud.repository.ws.SysTaskMsgDao;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysTaskMsgService {
	@Resource
	private SysTaskMsgDao taskMsgDao;
	/**
	 *说明：添加催办消息
	 *@创建：作者:llp		创建时间：2015-2-5
	 *@修改历史：
	 *		[序号](llp	2015-2-5)<修改说明>
	 */
	public int addSysTaskMsg(SysTaskMsg taskMsg,String database){
		try{
			this.taskMsgDao.addSysTaskMsg(taskMsg, database);
			return taskMsgDao.getAotoId();
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public void addSysTaskMsgs(List<SysTaskMsg> taskMsgList,String database){
		try{
			for(int i=0;i<taskMsgList.size();i++){
				this.taskMsgDao.addSysTaskMsg(taskMsgList.get(i), database);
			}
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	/**
	 *说明：根据手机号查被邀请信息
	 *@创建：作者:llp		创建时间：2015-2-5
	 *@修改历史：
	 *		[序号](llp	2015-2-5)<修改说明>
	 */
	public SysTaskMsg queryTaskMsgByTel(String tel,String database){
		return this.taskMsgDao.queryTaskMsgByTel(tel, database);
	}
	public void addTaskMsgs(List<SysTaskMsg> tMsgs, String database) {
		taskMsgDao.addTaskMsgs(tMsgs,database);
	}
}
