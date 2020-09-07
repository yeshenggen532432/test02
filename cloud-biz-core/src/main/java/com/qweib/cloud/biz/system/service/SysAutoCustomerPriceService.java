package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysAutoCustomerPrice;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.repository.SysAutoCustomerPriceDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysAutoCustomerPriceService {
	@Resource
	private SysAutoCustomerPriceDao autoCustomerPriceDao;
	public Page queryAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice,int page,int rows,String database){
		return autoCustomerPriceDao.queryAutoCustomerPrice(autoCustomerPrice, page, rows, database);
	}

	public Page queryCustomerAutoFieldWarePage(SysWare ware, int page, int rows,Integer customerId, String database){
		return autoCustomerPriceDao.queryCustomerAutoFieldWarePage(ware,page,rows,customerId,database);
	}

	public List<SysAutoCustomerPrice> queryList(SysAutoCustomerPrice autoCustomerPrice, String database){
    	return autoCustomerPriceDao.queryList(autoCustomerPrice, database);
    }
	
	
	public int addAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice,String database){
		return autoCustomerPriceDao.addAutoCustomerPrice(autoCustomerPrice, database);
	}
	
	public SysAutoCustomerPrice queryAutoCustomerPriceById(Integer autoCustomerPriceId,String database){
		
		return autoCustomerPriceDao.queryAutoCustomerPriceById(autoCustomerPriceId, database);
	}

	public int updateAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice,String database){
		return autoCustomerPriceDao.updateAutoCustomerPrice(autoCustomerPrice, database);
	}


}
