package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysPrintRecordDao;
import com.qweib.cloud.core.domain.SysPrintRecord;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysPrintRecordService {
	@Resource
	private SysPrintRecordDao printRecordDao;
	
	
	public Page queryPrintRecordPage(SysPrintRecord printRecord,int page,int rows,String database){
		try {
			return this.printRecordDao.querySysPrintRecordPage(printRecord, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysPrintRecord> queryList(SysPrintRecord printRecord, String database){
		try {
			return this.printRecordDao.queryList(printRecord,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public Integer queryPrintCount(SysPrintRecord print, String database){
		try {
			return this.printRecordDao.queryPrintCount(print, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public List queryPrintCountList(SysPrintRecord print, String database){
		try {
		return this.printRecordDao.queryPrintCountList(print,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int addPrintRecord(SysPrintRecord printRecord,String database){
		try {
			return this.printRecordDao.addSysPrintRecord(printRecord, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	

	public SysPrintRecord queryPrintRecordById(Integer autoId,String database){
		try {
			return this.printRecordDao.querySysPrintRecordById(autoId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int updatePrintRecord(SysPrintRecord printRecord,String database){
		try {
			return this.printRecordDao.updateSysPrintRecord(printRecord, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int deletePrintRecord(Integer id,String database){
		try {
			return this.printRecordDao.deleteSysPrintRecord(id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
