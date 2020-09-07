package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysQdTypeTcRate;
import com.qweib.cloud.repository.SysQdTypeTcRateDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQdTypeTcRateService {
	@Resource
	private SysQdTypeTcRateDao qdTypeTcRateDao;
	
	
	public Page queryQdTypeTcRate(SysQdTypeTcRate levelRate,int page,int rows,String database){
		return qdTypeTcRateDao.queryQdTypeTcRate(levelRate, page, rows, database);
	}
	
    public List<SysQdTypeTcRate> queryList(SysQdTypeTcRate levelRate, String database){
    	return qdTypeTcRateDao.queryList(levelRate, database);
    }
	
	
	public int addQdTypeTcRate(SysQdTypeTcRate levelRate,String database){
		return qdTypeTcRateDao.addQdTypeTcRate(levelRate, database);
	}
	
	public SysQdTypeTcRate queryQdTypeTcRateById(Integer levelRateId,String database){
		
		return qdTypeTcRateDao.queryQdTypeTcRateById(levelRateId, database);
	}

	public int updateQdTypeTcRate(SysQdTypeTcRate levelRate,String database){
		return qdTypeTcRateDao.updateQdTypeTcRate(levelRate, database);
	}
	
	public int deleteQdTypeTcRate(Integer id,String database){
		return qdTypeTcRateDao.deleteQdTypeTcRate(id, database);
	}
	
	public void deleteQdTypeAll(String database){
		qdTypeTcRateDao.deleteQdTypeTcRateAll(database);
		
	}

	public SysQdTypeTcRate queryQdTypeTcRate(SysQdTypeTcRate TypeTcRate,String database){

		return qdTypeTcRateDao.queryQdTypeTcRate(TypeTcRate, database);
	}

	public SysQdTypeTcRate queryQdTypeTcRateByTypeIdAndRelaId(Integer relaId,Integer wareId,String database){
		return qdTypeTcRateDao.queryQdTypeTcRateByTypeIdAndRelaId(relaId,wareId,database);
	}
}
