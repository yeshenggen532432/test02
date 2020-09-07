package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWareImportMain;
import com.qweib.cloud.core.domain.SysWareImportSub;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWareImportMainDao;
import com.qweib.cloud.repository.SysWareImportSubDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysWareImportMainService {
	@Resource
	private SysWareImportMainDao sysWareImportMainDao;
	@Resource
	private SysWareImportSubDao sysWareImportSubDao;
	
	
	public Page queryPage(SysWareImportMain main,int page,int rows,String database){
		try {
			return this.sysWareImportMainDao.queryPage(main, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public Page querySubPage(SysWareImportSub sub,int page,int rows,String database){
		try {
			return this.sysWareImportSubDao.queryPage(sub, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysWareImportMain> queryList(SysWareImportMain main, String database){
		try {
			return this.sysWareImportMainDao.queryList(main,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int add(SysWareImportMain main,String database){
		try {
			int mastId = this.sysWareImportMainDao.add(main, database);
			List<SysWareImportSub> list = main.getList();
			if(list!=null){
				for(int i=0;i<list.size();i++){
					SysWareImportSub sub = list.get(i);
					sub.setMastId(mastId);
					sysWareImportSubDao.add(sub,database);
				}
			}
			return mastId;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	public SysWareImportMain queryById(Integer main,String database){
		try {
			return this.sysWareImportMainDao.queryById(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int update(SysWareImportMain main,String database){
		try {
			return this.sysWareImportMainDao.update(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

}
