package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysUseLog;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.plat.SysUseLogDao;
import com.qweib.cloud.utils.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysUseLogService {
	public static Logger logger = LoggerFactory.getLogger(SysUseLogService.class);
	
	@Resource
	private SysUseLogDao useLogDao;
	
	public Page queryUseLog(SysUseLog uselog,Integer page,Integer limit){
		try {
			return this.useLogDao.queryUseLog( uselog, page, limit);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryCompanyUseLog(SysUseLog uselog,Integer page,Integer limit){
		try {
			return this.useLogDao.queryCompanyUseLog( uselog, page, limit);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public Page queryMemberUseLog(SysUseLog uselog,Integer page,Integer limit){
		try {
			return this.useLogDao.queryMemberUseLog( uselog, page, limit);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public SysUseLog queryUseLogById(Integer id){
		try{
			return this.useLogDao.queryUseLogById(id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public Integer addUseLog(SysUseLog uselog) {
		try{
			return this.useLogDao.addUseLog(uselog);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public Integer getAutoId() {
		try{
			return useLogDao.getAutoId();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
