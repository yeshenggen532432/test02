package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.company.SysEmpgroupDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

@Service
public class SysEmpgroupService {
	@Resource
	private SysEmpgroupDao sysEmpgroupDao;

	/**
	 *说明：查询员工圈管理
	 *@创建：作者:zrp		创建时间：2015-02-03
	 *@修改历史：
	 *		[序号](zrp	2015-02-03)<修改说明>
	 */
	public Page queryForPage(BscEmpgroup empgroup, Integer page, Integer rows,
							 String datasource) {
		try{
			return this.sysEmpgroupDao.queryForPage(empgroup, page, rows,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据ID删除
	 */
	public int[] deleteByIds(Integer[] ids,String database) {
		try{
			return this.sysEmpgroupDao.deleteByIds(ids,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据圈子获取话题
	 * @param id
	 * @param datasource 
	 * @return
	 */
	public Map<String, Object> queryToPicListById(Integer id,String datasource) {
		try{
			return this.sysEmpgroupDao.queryToPicListById(id,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据话题获取图片路径
	 * @param id
	 * @param datasource 
	 * @return
	 */
	public Map<String, Object> queryPicListById(Integer groupId, String datasource) {
		try{
			return this.sysEmpgroupDao.queryPicListById(groupId,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
}
