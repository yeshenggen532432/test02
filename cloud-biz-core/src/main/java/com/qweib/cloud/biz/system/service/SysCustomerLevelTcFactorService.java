package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysCustomerLevelTcFactor;
import com.qweib.cloud.repository.SysCustomerLevelTcFactorDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCustomerLevelTcFactorService {
	@Resource
	private SysCustomerLevelTcFactorDao customerLevelTcFactorDao;

	public Page queryCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor,int page,int rows,String database){
		return customerLevelTcFactorDao.queryCustomerLevelTcFactor(levelTcFactor, page, rows, database);
	}
	
    public List<SysCustomerLevelTcFactor> queryList(SysCustomerLevelTcFactor levelTcFactor, String database){
    	return customerLevelTcFactorDao.queryList(levelTcFactor, database);
    }
	
	
	public int addCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor,String database){
		return customerLevelTcFactorDao.addCustomerLevelTcFactor(levelTcFactor, database);
	}
	
	public SysCustomerLevelTcFactor queryCustomerLevelTcFactorById(Integer levelTcFactorId,String database){
		
		return customerLevelTcFactorDao.queryCustomerLevelTcFactorById(levelTcFactorId, database);
	}

	public int updateCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor,String database){
		return customerLevelTcFactorDao.updateCustomerLevelTcFactor(levelTcFactor, database);
	}
	
	public int deleteCustomerLevelTcFactor(Integer id,String database){
		return customerLevelTcFactorDao.deleteCustomerLevelTcFactor(id, database);
	}
	
	public void deleteCustomerLevelAll(String database){
		customerLevelTcFactorDao.deleteCustomerLevelTcFactorAll(database);
		
	}

	public SysCustomerLevelTcFactor queryCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor,String database){

		return customerLevelTcFactorDao.queryCustomerLevelTcFactor(levelTcFactor, database);
	}

	public SysCustomerLevelTcFactor queryCustomerLevelTcFactorByWareIdAndLevelId(Integer levelId,Integer wareId,String database){
		return customerLevelTcFactorDao.queryCustomerLevelTcFactorByWareIdAndLevelId(levelId,wareId,database);
	}
}
