package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysFixedField;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysFixedFieldDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysFixedFieldService {
	@Resource
	private SysFixedFieldDao fixedFieldDao;


	public Page queryFixedFieldPage(SysFixedField fixedField,int page,int rows,String database){
		try {
			return this.fixedFieldDao.querySysFixedFieldPage(fixedField, page, rows, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public List<SysFixedField> queryList(SysFixedField fixedField, String database){
		try {
			return this.fixedFieldDao.queryList(fixedField,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int addFixedField(SysFixedField fixedField,String database){
		try {
			return this.fixedFieldDao.addSysFixedField(fixedField, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysFixedField findByName(String name, String database) {
		return  this.fixedFieldDao.findByName(name, database);
	}

	public SysFixedField queryFixedFieldById(Integer fdId,String database){
		try {
			return this.fixedFieldDao.querySysFixedFieldById(fdId, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
    public SysFixedField queryFixedFieldByCode(String code, String database) {
        try {
            return this.fixedFieldDao.queryFixedFieldByCode(code, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
	public int updateFixedField(SysFixedField fixedField,String database){
		try {
			return this.fixedFieldDao.updateSysFixedField(fixedField, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int deleteFixedField(Integer id,String database){
		try {
			return this.fixedFieldDao.deleteSysFixedField(id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
