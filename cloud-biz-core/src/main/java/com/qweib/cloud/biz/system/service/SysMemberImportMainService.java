package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysMemberImportMain;
import com.qweib.cloud.core.domain.SysMemberImportSub;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysMemberImportMainDao;
import com.qweib.cloud.repository.SysMemberImportSubDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysMemberImportMainService {
	@Resource
	private SysMemberImportMainDao sysMemberImportMainDao;
	@Resource
	private SysMemberImportSubDao sysMemberImportSubDao;
	
	
	public Page queryPage(SysMemberImportMain main,int page,int rows,String database){
		try {
			return this.sysMemberImportMainDao.queryPage(main, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public Page querySubPage(SysMemberImportSub sub,int page,int rows,String database){
		try {
			return this.sysMemberImportSubDao.queryPage(sub, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysMemberImportMain> queryList(SysMemberImportMain main, String database){
		try {
			return this.sysMemberImportMainDao.queryList(main,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int add(SysMemberImportMain main,String database){
		try {
			int mastId = this.sysMemberImportMainDao.add(main, database);
			List<SysMemberImportSub> list = main.getList();
			if(list!=null){
				for(int i=0;i<list.size();i++){
					SysMemberImportSub sub = list.get(i);
					sub.setMastId(mastId);
					sysMemberImportSubDao.add(sub,database);
				}
			}
			return mastId;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	public SysMemberImportMain queryById(Integer main,String database){
		try {
			return this.sysMemberImportMainDao.queryById(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int update(SysMemberImportMain main,String database){
		try {
			return this.sysMemberImportMainDao.update(main, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

}
