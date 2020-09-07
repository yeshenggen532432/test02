package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqHolidayDao;
import com.qweib.cloud.biz.attendance.model.KqHoliday;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class KqHolidayService {
	@Resource
	private KqHolidayDao holidayDao;
	
	
	public int addHoliday(KqHoliday bo,String database)
	{
		return this.holidayDao.addHoliday(bo, database);
	}
	
	public int updateHoliday(KqHoliday bo,String database)
	{
		return this.holidayDao.updateHoliday(bo, database);
	}
	
	public int deleteHoliday(Integer id,String database)
	{
		return this.holidayDao.deleteHoliday(id, database);
	}
	
	public Page queryHolidayPage(KqHoliday day, String database, Integer page, Integer limit)
	{
		return this.holidayDao.queryHolidayPage(day, database, page, limit);
	}
	
	public KqHoliday getHoliday(Integer id,String database)
	{
		return this.holidayDao.getHoliday(id, database);
	}
	
}
