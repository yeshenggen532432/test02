package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysCustomerHzfsDao;
import com.qweib.cloud.core.domain.SysCustomerHzfs;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCustomerHzfsService {
	
	@Resource
	private SysCustomerHzfsDao hzfsDao;
	
	public int addHzfs(SysCustomerHzfs bo,String database)
	{
		int ret= 0;
		if(bo.getId()!= null)
		{
			if(bo.getId().intValue() == 0)bo.setId(null);
		}
		if(bo.getId() == null)
		ret = this.hzfsDao.addHzfs(bo, database);
		else
			ret = this.hzfsDao.updateHzfs(bo, database);
		return ret;
	}
	
	public List<SysCustomerHzfs> queryHzfsList(String database)
	{
		return this.hzfsDao.queryHzfsList(database);
	}
	
	public SysCustomerHzfs getHzfsByName(String hzfsNm,String database)
	{
		return this.hzfsDao.getByName(hzfsNm, database);
	}
	
	public SysCustomerHzfs getHzfsById(Integer id,String database)
	{
		return this.hzfsDao.getById(id, database);
	}
	
	public int deleteHzfs(String ids,String database)
	{
		return this.hzfsDao.deleteHzfs(ids, database);
	}

}
