package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.BscTrue;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.BscTrueDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class BscTrueService {
	@Resource
	private BscTrueDao bscTrueDao;
	/**
	 * 真心话分页查询
	 */
	public Page page(BscTrue bsctrue, Integer page, Integer rows,String database){
		try {
			return this.bscTrueDao.page(bsctrue, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 通过ID获取真心话信息
	 */
	public BscTrue queryTrueById(Integer id,String database) {
		try {
			return this.bscTrueDao.queryTrueById(id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 * 添加
	 */
	public int addTrue(BscTrue bsctrue,String database) {
		try{
			int i = this.bscTrueDao.addTrue(bsctrue,database);
			if(i!=1){
				throw new ServiceException("添加出错");
			}
			return i;
		}catch(Exception ex){
			throw new ServiceException(ex);
		}		
	}
	/**
	 * 修改
	 */
	public int updateTrue(BscTrue bsctrue,String database) {
		try{
			int i = this.bscTrueDao.updateTrue(bsctrue,database);
			if(i!=1){
				throw new ServiceException("修改出错");
			}
			return i;
		}catch(Exception ex){
			throw new ServiceException(ex);
		}
		
	}
	/**
	 * 删除
	 */
	public int[] deletetrue(Integer[] ids,String database){
		try {
			return this.bscTrueDao.deletetrue(ids,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
