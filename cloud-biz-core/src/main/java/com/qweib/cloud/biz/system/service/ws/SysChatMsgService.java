package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscEmpGroupMsg;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.repository.ws.SysChatMsgDao;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * @说明：聊天信息层webService
 * @创建者： 作者：YJP 创建时间：2014-5-7
 *
 */
@Service
public class SysChatMsgService {
	@Resource
	private SysChatMsgDao sysChatMsgDao;
	
	/**
	 * @说明：保存系统聊天信息（单条）
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param scm	保存
	 * @return int
	 */
	public int addChatMsg(SysChatMsg scm,String datasource){
		int result = this.sysChatMsgDao.addChatMsg(scm,datasource);
		if(result>0){
			result = sysChatMsgDao.getIdentity();
		}
		return result ;
	}
	
	/**
	 * @说明：批量插入聊天信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param scm	保存
	 * @return int
	 */
	public int addChatMsg(List<SysChatMsg>  scms,String datasource){
		int[] result ;
//		if(scms.size()>0){
//			for (int i = 0; i < scms.size(); i++) {
//				result = this.sysChatMsgDao.addChatMsg(scms.get(i),datasource);
//			}
//		}
		if(null!=datasource){
			result = sysChatMsgDao.addBatchMsg(scms,datasource);
		}else{
			result = sysChatMsgDao.addBatchpublicMsg(scms);
		}
		//返回结果
		if(result.length>0){
			return 1 ;
		}else{
			return 0 ;
		}
	}
	/**
	 * @说明：批量插入聊天信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param scm	保存
	 * @return int
	 */
	public void addChatMsg2(List<SysChatMsg>  scms,String datasource){
		if(scms.size()>0){
			for (int i = 0; i < scms.size(); i++) {
				this.sysChatMsgDao.addChatMsg(scms.get(i),datasource);
			}
		}
	}
	/**
	 * @说明：删除系统聊天信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param scm	保存
	 * @return int
	 */
	public int deleteChatMsg(Integer msgId,String datasource){
		return this.sysChatMsgDao.deleteChatMsg(msgId,datasource);
	}
	

	/**
	 * @说明： 得到发给自己的信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param memberId 成员ID
	 * @return 消息集合
	 */
	public List<SysChatMsg> getMyMessage(Integer receiveId,Integer memberId,String datasource){
		List<SysChatMsg> list = this.sysChatMsgDao.getMyMessage(receiveId,memberId,null,0,datasource);
		/*if(list.size()>=200){
		List<Integer> intList = new ArrayList<Integer>();
		for (int i = 0; i < list.size(); i++) {
			intList.add(list.get(i).getMsgId());
		}
		sysChatMsgDao.deltesMsgNotIn(intList);//删除超过200条的未读消息
		}*/
		return list;
	}
	
	/**
	 * @说明： 得到发给自己的信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param memberId 成员ID
	 * @return 消息集合
	 */
	public List<SysChatMsg> updateMyMessageByDelete(Integer receiveId,Integer memberId,String datasource){
		List<SysChatMsg> list = this.sysChatMsgDao.getMyMessage(receiveId,memberId,null,0,datasource);
		if(list!=null && list.size()!=0){
			List<Integer> intList = new ArrayList<Integer>();
			for (int i = 0; i < list.size(); i++) {
				intList.add(list.get(i).getMsgId());
			}
			sysChatMsgDao.deltesMsg(intList,datasource);
		}
		//sysChatMsgDao.deltesMsgByMem(receiveId,memberId,0);//删除所有未读消息
		return list;
		
	}
	
	public List<SysChatMsg> getMyMessage(Integer receiveId,Integer memberId,Integer receiveSide,Integer isReady,String datasource){
		return this.sysChatMsgDao.getMyMessage(receiveId,memberId,receiveSide,isReady,datasource);
	}
	
	
	/**
	 * @说明： 根据msgID 提取消息
	 * @param msgId 消息ID
	 * @return 消息
	 */
	public SysChatMsg getMyMessageByMsgId(Integer msgId,String datasource){
		return this.sysChatMsgDao.getMyMessageByMsgId(msgId,datasource);
	}
	/**
	 * @说明： 根据ID 提取消息
	 * @param msgId 消息ID
	 * @return 消息
	 */
	public SysChatMsg getMyMessageById(Integer Id,String datasource){
		return this.sysChatMsgDao.getMyMessageById(Id,datasource);
	}
	
	
	/**
	 * @说明： 删除发给自己的信息
	 * @创建者： 作者：YJP 创建时间：2014-5-7
	 * @param memberId 成员ID
	 * @return 消息集合
	 */
	public int deletesMsg(List<Integer> msgId,String datasource){
		return this.sysChatMsgDao.deltesMsg(msgId,datasource);
	}
	
	/**
	 * @说明：修改读取状态
	 * @param memberId 成员ID
	 * @return 消息集合
	 */
	public int updateReadMsg(List<Integer> msgId,String datasource){
		return this.sysChatMsgDao.updateReadMsg(msgId,datasource);
	}
	
	/**
	 * @说明： 删除发给自己的新闻信息
	 *  @创建者： 作者：YJP 创建时间：2014-5-22
	 * @param memberId 成员ID
	 * @return 消息集合
	 */
	public int deltesNewMsg(Integer memberId,String datasource){
		return this.sysChatMsgDao.deltesNewMsg(memberId,datasource);
	}
	
	public int addGroupMsg(BscEmpGroupMsg empMsg,String datasource) {
		try{
			return sysChatMsgDao.addGroupMsg(empMsg,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 获取tp=32信息数
	  *@创建：作者:llp		创建时间：2016-8-23
	 */
	public int queryMsgJhCount(String database,String pdate){
		try {
			return sysChatMsgDao.queryMsgJhCount(database, pdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * @说明： 判断信息有没有存在
	 * @param 
	 * @return 消息
	 */
	public SysChatMsg getMyMessageByBUid2(Integer memberId,Integer receiveId,Integer belongId,String datasource){
		try {
			return sysChatMsgDao.getMyMessageByBUid2(memberId,receiveId, belongId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public SysChatMsg getMyMessageByBUid(Integer receiveId,Integer belongId,String datasource){
		try {
			return sysChatMsgDao.getMyMessageByBUid(receiveId, belongId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
