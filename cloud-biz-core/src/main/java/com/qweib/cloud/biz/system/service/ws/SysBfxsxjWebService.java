package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfxsxjWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBfxsxjWebService {
	@Resource
	private SysBfxsxjWebDao bfxsxjWebDao;
	
	/**
	 *说明：添加销售小结
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public void addBfxsxj(List<SysBfxsxj> bfxsxjLs,String database) {
		try {
			for(int i=0;i<bfxsxjLs.size();i++){
				this.bfxsxjWebDao.addBfxsxj(bfxsxjLs.get(i), database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改销售小结
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public void updateBfxsxj(List<SysBfxsxj> bfxsxjLs,String database) {
		try {
			for(int i=0;i<bfxsxjLs.size();i++){
				this.bfxsxjWebDao.updateBfxsxj(bfxsxjLs.get(i), database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取销售小结
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public List<SysBfxsxj> queryBfxsxjOne(String database,Integer mid,Integer cid,String xjdate){
		try {
			return this.bfxsxjWebDao.queryBfxsxjOne(database, mid, cid,xjdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除销售小结
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public void deleteBfxsxj(String database,Integer mid,Integer cid) {
		try {
			this.bfxsxjWebDao.deleteBfxsxj(database, mid, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：判断有没有临期
	 *@创建：作者:llp		创建时间：2016-4-29
	 *@修改历史：
	 *		[序号](llp	2016-4-29)<修改说明>
	 */
	public int queryBfxsxjByCount(String database,Integer mid,Integer cid,String dates){
		try {
			return this.bfxsxjWebDao.queryBfxsxjByCount(database, mid, cid, dates);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取销售小结上次信息
	 *@创建：作者:llp		创建时间：2016-4-29
	 *@修改历史：
	 *		[序号](llp	2016-4-29)<修改说明>
	 */
	public SysBfxsxj queryBfxsxjOneSc(String database,Integer mid,Integer cid){
		try {
			return this.bfxsxjWebDao.queryBfxsxjOneSc(database, mid, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
