package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysQdTypeTcFactor;
import com.qweib.cloud.repository.SysQdTypeTcFactorDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQdTypeTcFactorService {
	@Resource
	private SysQdTypeTcFactorDao qdTypeTcFactorDao;
	
	
	public Page queryQdTypeTcFactor(SysQdTypeTcFactor typeTcFactor,int page,int rows,String database){
		return qdTypeTcFactorDao.queryQdTypeTcFactor(typeTcFactor, page, rows, database);
	}
	
    public List<SysQdTypeTcFactor> queryList(SysQdTypeTcFactor typeTcFactor, String database){
    	return qdTypeTcFactorDao.queryList(typeTcFactor, database);
    }
	
	
	public int addQdTypeTcFactor(SysQdTypeTcFactor typeTcFactor,String database){
		return qdTypeTcFactorDao.addQdTypeTcFactor(typeTcFactor, database);
	}
	
	public SysQdTypeTcFactor queryQdTypeTcFactorById(Integer typeTcFactorId,String database){

		return qdTypeTcFactorDao.queryQdTypeTcFactorById(typeTcFactorId, database);
	}

	public int updateQdTypeTcFactor(SysQdTypeTcFactor typeTcFactor,String database){
		return qdTypeTcFactorDao.updateQdTypeTcFactor(typeTcFactor, database);
	}
	
	public int deleteQdTypeTcFactor(Integer id,String database){
		return qdTypeTcFactorDao.deleteQdTypeTcFactor(id, database);
	}
	
	public void deleteQdTypeAll(String database){
		qdTypeTcFactorDao.deleteQdTypeTcFactorAll(database);
		
	}

	public SysQdTypeTcFactor queryQdTypeTcFactor(SysQdTypeTcFactor TypeTcFactor,String database){

		return qdTypeTcFactorDao.queryQdTypeTcFactor(TypeTcFactor, database);
	}

	public SysQdTypeTcFactor queryQdTypeTcFactorByWareIdAndRelaId(Integer relaId,Integer wareId,String database){
		return qdTypeTcFactorDao.queryQdTypeTcFactorByWareIdAndRelaId(relaId,wareId,database);
	}
}
