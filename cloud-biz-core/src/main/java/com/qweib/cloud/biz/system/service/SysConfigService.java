package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysConfigDao;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysConfigService {
	@Resource
	private SysConfigDao configDao;
	
	
	public Page queryConfigPage(SysConfig config,int page,int rows,String database){
		try {
			return this.configDao.querySysConfigPage(config, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysConfig> queryList(SysConfig config, String database){
		try {
			return this.configDao.queryList(config,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int addConfig(SysConfig config,String database){
		try {
			return this.configDao.addSysConfig(config, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public SysConfig querySysConfigByCode(String code, String database){
		try {
			return this.configDao.querySysConfigByCode(code, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysConfig queryConfigById(Integer autoId,String database){
		try {
			return this.configDao.querySysConfigById(autoId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int updateConfig(SysConfig config,String database){
		try {
			return this.configDao.updateSysConfig(config, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int deleteConfig(Integer id,String database){
		try {
			return this.configDao.deleteSysConfig(id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
