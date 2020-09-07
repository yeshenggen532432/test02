package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysKhfbszDao;
import com.qweib.cloud.core.domain.SysKhfbsz;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysKhfbszService {
	@Resource
	private SysKhfbszDao khfbszDao;
	
	/**
	 * 
	 *摘要：
	 *@说明：查询客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public List<SysKhfbsz> queryKhfbszLs(String database){
		try {
			return this.khfbszDao.queryKhfbszLs(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：批量添加客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public void addKhfbszLs(List<SysKhfbsz> KhfbszLs,String database){
		try {
			this.khfbszDao.addKhfbszLs(KhfbszLs, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：删除客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public void deleteKhfbsz(String database){
		try {
			this.khfbszDao.deleteKhfbsz(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：根据分钟查数据
	 *@创建：作者:llp		创建时间：2017-5-17
	 *@修改历史：
	 *		[序号](llp	2017-5-17)<修改说明>
	 */
	public SysKhfbsz queryKhfbszByFz(Integer fz,String database){
		try {
			return this.khfbszDao.queryKhfbszByFz(fz,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
