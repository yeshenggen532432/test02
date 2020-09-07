package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.domain.SysBflsm;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBflsmWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBflsmWebService {
	@Resource
	private SysBflsmWebDao bflsmWebDao;
	
	/**
	 *说明：根据用户id,日期获取签到信息
	 *@创建：作者:llp		创建时间：2016-11-21
	 *@修改历史：
	 *		[序号](llp	2016-11-21)<修改说明>
	 */
	public List<SysBflsm> queryBflsm(String database,Integer mid,String date){
		try {
			return this.bflsmWebDao.queryBflsm(database, mid, date);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id,客户id,日期获取签退到信息
	 *@创建：作者:llp		创建时间：2016-11-21
	 *@修改历史：
	 *		[序号](llp	2016-11-21)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcByMCD(String database,Integer mid,Integer cid,String date){
		try {
			return this.bflsmWebDao.queryBfgzxcByMCD(database, mid, cid, date);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
