package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysCustomerImportMain;
import com.qweib.cloud.core.domain.SysCustomerImportSub;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysCustomerImportMainDao;
import com.qweib.cloud.repository.SysCustomerImportSubDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCustomerImportMainService {
	@Resource
	private SysCustomerImportMainDao sysCustomerImportMainDao;
	@Resource
	private SysCustomerImportSubDao sysCustomerImportSubDao;
	
	
	public Page queryPage(SysCustomerImportMain main,int page,int rows,String database){
		try {
			return this.sysCustomerImportMainDao.queryPage(main, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public Page querySubPage(SysCustomerImportSub sub,int page,int rows,String database){
		try {
			return this.sysCustomerImportSubDao.queryPage(sub, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysCustomerImportMain> queryList(SysCustomerImportMain main, String database){
		try {
			return this.sysCustomerImportMainDao.queryList(main,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int add(SysCustomerImportMain main,String database){
		try {
			int mastId = this.sysCustomerImportMainDao.add(main, database);
			List<SysCustomerImportSub> list = main.getList();
			if(list!=null){
				for(int i=0;i<list.size();i++){
					SysCustomerImportSub sub = list.get(i);
					sub.setMastId(mastId);
					sysCustomerImportSubDao.add(sub,database);
				}
			}
			return mastId;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	public SysCustomerImportMain queryById(Integer main,String database){
		try {
			return this.sysCustomerImportMainDao.queryById(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int update(SysCustomerImportMain main,String database){
		try {
			return this.sysCustomerImportMainDao.update(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

}
