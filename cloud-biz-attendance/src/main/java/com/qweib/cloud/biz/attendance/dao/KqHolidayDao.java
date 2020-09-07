package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqHoliday;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class KqHolidayDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addHoliday(KqHoliday bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_holiday", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateHoliday(KqHoliday bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_holiday", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteHoliday(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_holiday where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryHolidayPage(KqHoliday day, String database, Integer page, Integer limit)
	{
		String sql = "select * from " + database + ".kq_holiday where 1 = 1 ";
		if(!StrUtil.isNull(day.getYear()))
		{
			String sdate = day.getYear() + "-01-01";
			Integer year = Integer.parseInt(day.getYear());
			if(year == 0)year = 2018;
			year++;
			String edate = year.toString() + "-01-01";
			sql += " and start_date>='" + sdate + "' and start_date<'" + edate + "' ";
		}
		if(!StrUtil.isNull(day.getDayName()))
		{
			sql += " and day_name like'%" + day.getDayName() + "%'";
		}
		sql += " order by start_date desc ";
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqHoliday.class);
	}
	
	public boolean isInJieJia(String ymd,String database)
	{
		String sql = "select * from " + database + ".kq_holiday where start_date<='" + ymd + "' and end_date>='" + ymd + "'";
		List<KqHoliday> list = this.daoTemplate.queryForLists(sql, KqHoliday.class);
		if(list.size() > 0)return true;
		return false;
	}
	
	
	public KqHoliday getHoliday(Integer id,String database)
	{
		String sql = "select * from " + database + ".kq_holiday where id = " + id.toString();
		List<KqHoliday> list = this.daoTemplate.queryForLists(sql,KqHoliday.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

}
