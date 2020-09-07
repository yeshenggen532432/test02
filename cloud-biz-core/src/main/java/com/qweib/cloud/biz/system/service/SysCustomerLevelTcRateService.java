package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysCustomerLevelTcRate;
import com.qweib.cloud.repository.SysCustomerLevelTcRateDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCustomerLevelTcRateService {
	@Resource
	private SysCustomerLevelTcRateDao customerLevelTcRateDao;
	
	
	public Page queryCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate,int page,int rows,String database){
		return customerLevelTcRateDao.queryCustomerLevelTcRate(levelTcRate, page, rows, database);
	}
	
    public List<SysCustomerLevelTcRate> queryList(SysCustomerLevelTcRate levelTcRate, String database){
    	return customerLevelTcRateDao.queryList(levelTcRate, database);
    }
	
	
	public int addCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate,String database){
		return customerLevelTcRateDao.addCustomerLevelTcRate(levelTcRate, database);
	}
	
	public SysCustomerLevelTcRate queryCustomerLevelTcRateById(Integer levelTcRateId,String database){
		
		return customerLevelTcRateDao.queryCustomerLevelTcRateById(levelTcRateId, database);
	}

	public int updateCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate,String database){
		return customerLevelTcRateDao.updateCustomerLevelTcRate(levelTcRate, database);
	}
	
	public int deleteCustomerLevelTcRate(Integer id,String database){
		return customerLevelTcRateDao.deleteCustomerLevelTcRate(id, database);
	}
	
	public void deleteCustomerLevelAll(String database){
		customerLevelTcRateDao.deleteCustomerLevelTcRateAll(database);
		
	}

	public SysCustomerLevelTcRate queryCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate,String database){

		return customerLevelTcRateDao.queryCustomerLevelTcRate(levelTcRate, database);
	}

	public SysCustomerLevelTcRate queryCustomerLevelByTypeIdAndLevelId(Integer levelId,Integer wareId,String database){
		return customerLevelTcRateDao.queryCustomerLevelTcRateByTypeIdAndLevelId(levelId,wareId,database);
	}
}
