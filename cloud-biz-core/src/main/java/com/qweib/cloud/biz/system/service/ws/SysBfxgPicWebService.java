package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysBfxgPic;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfxgPicWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBfxgPicWebService {
	@Resource
	private SysBfxgPicWebDao bfxgPicWebDao;
	
	/**
	 *说明：列表查照片
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public List<SysBfxgPic> queryBfxgPicls(String database,Integer ssId,Integer type,Integer xxId){
		try {
			return this.bfxgPicWebDao.queryBfxgPicls(database, ssId, type,xxId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取图片数量1
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	public int queryBfxgPicCount1(String database,Integer ssId,Integer type){
		try {
			return this.bfxgPicWebDao.queryBfxgPicCount1(database, ssId, type);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取图片数量2
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	public int queryBfxgPicCount2(String database,Integer ssId){
		try {
			return this.bfxgPicWebDao.queryBfxgPicCount2(database, ssId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
