package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysAddressUpload;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.SysAddressUploadDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysAddressUploadService {
	
	@Resource
	private SysAddressUploadDao sysAddressUploadDao;
	
	
	public int add(SysAddressUpload model,String database){
		try {
			return this.sysAddressUploadDao.add(model, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int update(SysAddressUpload model,String database){
		try {
			return this.sysAddressUploadDao.update(model, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysAddressUpload queryByMemId(Integer memId,String database){
		try {
			return this.sysAddressUploadDao.queryByMemId(memId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	
	
}
