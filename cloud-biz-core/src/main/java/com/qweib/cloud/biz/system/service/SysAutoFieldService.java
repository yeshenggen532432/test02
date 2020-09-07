package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysAutoField;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysAutoFieldDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysAutoFieldService {
	@Resource
	private SysAutoFieldDao autoFieldDao;


	public Page queryAutoFieldPage(SysAutoField auto,int page,int rows,String database){
		try {
			return this.autoFieldDao.querySysAutoFieldPage(auto, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public List<SysAutoField> queryList(SysAutoField auto, String database){
		try {
			return this.autoFieldDao.queryList(auto,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int addAutoField(SysAutoField auto,String database){
		try {
			return this.autoFieldDao.addSysAutoField(auto, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysAutoField findByName(String name, String database) {
		return  this.autoFieldDao.findByName(name, database);
	}

	public SysAutoField queryAutoFieldById(Integer autoId,String database){
		try {
			return this.autoFieldDao.querySysAutoFieldById(autoId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
    public SysAutoField queryAutoFieldByCode(String code, String database) {
        try {
            return this.autoFieldDao.queryAutoFieldByCode(code, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
	public int updateAutoField(SysAutoField auto,String database){
		try {
			return this.autoFieldDao.updateSysAutoField(auto, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int updateAutoFieldStatus(String database){
        return autoFieldDao.updateAutoFieldStatus(database);
    }
	public int deleteAutoField(Integer id,String database){
		try {
			return this.autoFieldDao.deleteSysAutoField(id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
