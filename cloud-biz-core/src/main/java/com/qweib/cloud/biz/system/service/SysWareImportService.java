package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysWareImportDao;
import com.qweib.cloud.core.domain.SysWareImport;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysWareImportService {
	@Resource
	private SysWareImportDao wareImportDao;
	
	
	public Page queryWareImport(SysWareImport ware,int page,int rows,String database){
		try {
			return this.wareImportDao.queryWareImport(ware, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysWareImport> queryList(SysWareImport ware, String database){
		try {
			return this.wareImportDao.queryList(ware,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int addWareImport(SysWareImport ware,String database){
		try {
			return this.wareImportDao.addWareImport(ware, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysWareImport queryWareImportById(Integer wareId,String database){
		try {
			return this.wareImportDao.queryWareImportById(wareId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int updateWareImport(SysWareImport ware,String database){
		try {
			return this.wareImportDao.updateWareImport(ware, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int deleteWareImport(Integer wareId,String database){
		try {
			return this.wareImportDao.deleteWareImport(wareId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int queryWareImportNmCount(String wareNm,String database){
		try {
			return this.wareImportDao.queryWareImportNmCount(wareNm, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int queryWareImportCodeCount(String wareCode,String database){
		try {
			return this.wareImportDao.queryWareImportCodeCount(wareCode, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public void deleteWareImportAll(String database){
		try {
			this.wareImportDao.deleteWareImportAll(database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
