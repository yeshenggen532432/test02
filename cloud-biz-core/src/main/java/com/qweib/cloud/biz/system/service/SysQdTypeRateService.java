package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysQdTypeRate;
import com.qweib.cloud.repository.SysQdTypeRateDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQdTypeRateService {
	@Resource
	private SysQdTypeRateDao qdTypeRateDao;
	
	
	public Page queryQdTypeRate(SysQdTypeRate levelRate,int page,int rows,String database){
		return qdTypeRateDao.queryQdTypeRate(levelRate, page, rows, database);
	}
	
    public List<SysQdTypeRate> queryList(SysQdTypeRate levelRate, String database){
    	return qdTypeRateDao.queryList(levelRate, database,"");
    }
	
	
	public int addQdTypeRate(SysQdTypeRate levelRate,String database){
		return qdTypeRateDao.addQdTypeRate(levelRate, database);
	}
	
	public SysQdTypeRate queryQdTypeRateById(Integer levelRateId,String database){
		
		return qdTypeRateDao.queryQdTypeRateById(levelRateId, database);
	}

	public int updateQdTypeRate(SysQdTypeRate levelRate,String database){
		return qdTypeRateDao.updateQdTypeRate(levelRate, database);
	}
	
	public int deleteQdTypeRate(Integer id,String database){
		return qdTypeRateDao.deleteQdTypeRate(id, database);
	}
	
	public void deleteQdTypeAll(String database){
		qdTypeRateDao.deleteQdTypeRateAll(database);
	}

	public SysQdTypeRate queryQdTypeRate(SysQdTypeRate typeRate,String database){

		return qdTypeRateDao.queryQdTypeRate(typeRate, database);
	}

	public SysQdTypeRate queryQdTypeRateByTypeIdAndRelaId(Integer relaId,Integer wareId,String database){
		return qdTypeRateDao.queryQdTypeRateByTypeIdAndRelaId(relaId,wareId,database);
	}

	public List<SysQdTypeRate> querySubTypeRateList(SysQdTypeRate qdTypeRate, String database){
		return qdTypeRateDao.querySubTypeRateList(qdTypeRate,database);
	}
}
