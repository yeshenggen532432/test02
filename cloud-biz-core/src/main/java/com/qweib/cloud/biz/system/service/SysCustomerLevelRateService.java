package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysCustomerLevelRate;
import com.qweib.cloud.repository.SysCustomerLevelRateDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCustomerLevelRateService {
	@Resource
	private SysCustomerLevelRateDao customerLevelRateDao;
	
	
	public Page queryCustomerLevelRate(SysCustomerLevelRate levelRate,int page,int rows,String database){
		return customerLevelRateDao.queryCustomerLevelRate(levelRate, page, rows, database);
	}
	
    public List<SysCustomerLevelRate> queryList(SysCustomerLevelRate levelRate, String database){
    	return customerLevelRateDao.queryList(levelRate, database,"");
    }
	
	
	public int addCustomerLevelRate(SysCustomerLevelRate levelRate,String database){
		return customerLevelRateDao.addCustomerLevelRate(levelRate, database);
	}
	
	public SysCustomerLevelRate queryCustomerLevelRateById(Integer levelRateId,String database){
		
		return customerLevelRateDao.queryCustomerLevelRateById(levelRateId, database);
	}

	public int updateCustomerLevelRate(SysCustomerLevelRate levelRate,String database){
		return customerLevelRateDao.updateCustomerLevelRate(levelRate, database);
	}
	
	public int deleteCustomerLevelRate(Integer id,String database){
		return customerLevelRateDao.deleteCustomerLevelRate(id, database);
	}
	
	public void deleteCustomerLevelAll(String database){
		customerLevelRateDao.deleteCustomerLevelRateAll(database);
		
	}

	public SysCustomerLevelRate queryCustomerLevelRate(SysCustomerLevelRate levelRate,String database){

		return customerLevelRateDao.queryCustomerLevelRate(levelRate, database);
	}

	public SysCustomerLevelRate queryCustomerLevelByTypeIdAndLevelId(Integer levelId,Integer wareId,String database){
		return customerLevelRateDao.queryCustomerLevelByTypeIdAndLevelId(levelId,wareId,database);
	}

	public List<SysCustomerLevelRate> querySubTypeRateList(SysCustomerLevelRate levelRate, String database){
		return customerLevelRateDao.querySubTypeRateList(levelRate,database);
	}
}
