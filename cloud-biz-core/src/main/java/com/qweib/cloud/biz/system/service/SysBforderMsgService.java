package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysBforderMsgDao;
import com.qweib.cloud.core.domain.SysBforderMsg;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBforderMsgService {
	@Resource
	private SysBforderMsgDao bforderMsgDao;
	
	/**
	 *说明：添加订单提示信息
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public int addBforderMsg(SysBforderMsg orderMsg,String database) {
		try {
			return this.bforderMsgDao.addBforderMsg(orderMsg, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改信息已读2
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public void updateBforderMsgisRead(String database,Integer id) {
		try {
			this.bforderMsgDao.updateBforderMsgisRead(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改信息已读2
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public void updateBforderMsgisRead2(String database,String orderNo) {
		try {
			this.bforderMsgDao.updateBforderMsgisRead2(database, orderNo);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查订单提示信息
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public List<SysBforderMsg> queryBforderMsgls(String database){
		try {
			return this.bforderMsgDao.queryBforderMsgls(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
