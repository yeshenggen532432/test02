package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqBanDao;
import com.qweib.cloud.biz.attendance.model.KqBan;
import com.qweib.cloud.biz.attendance.model.KqBanDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Service
public class KqBanService {
	
	@Resource
	private KqBanDao banDao;
	
	public int addKqBan(KqBan ban,String database) throws Exception
	{
		ban.setBanDate(new Date());
		ban.setStatus(0);
		Date dtStart = DateTimeUtil.getStrToDate(ban.getStartTime() + ":00", "yyyy-MM-dd HH:mm:ss");
		String ymd = DateTimeUtil.getDateToStr(dtStart, "yyyy-MM-dd");
		String endTime = ymd + " " + ban.getEndTimeStr();
		ban.setEndTime(endTime);
		Date dtEnd = DateTimeUtil.getStrToDate(endTime + ":00", "yyyy-MM-dd HH:mm:ss");
		ban.setBanDate(new Date());
		Integer minutes = DateTimeUtil.getMinutes(dtStart, dtEnd);
		double f = minutes;
		f = f/60;
		BigDecimal hours = new BigDecimal(f);
		ban.setHours(hours);
		KqBanDetail detl = new KqBanDetail();
		detl.setHours(hours);
		detl.setKqDate(ymd);
		detl.setMastId(0);
		detl.setMemberId(ban.getMemberId());
		int ret = this.banDao.addKqBan(ban, database);
		if(ret == 0)return 0;
		detl.setMastId(ret);
		ret = this.banDao.addBanDetail(detl, database);
		if(ret == 0)
		{
			throw new ServiceException("保存失败");
		}
		return ret;
		
	}
	
	public Page queryKqBanPage(KqBan ban, String database, Integer page, Integer limit) throws Exception
	{
		Page p = this.banDao.queryKqBanPage(ban, database, page, limit);
		List<KqBan> list = p.getRows();
		for(KqBan vo: list)
		{
			vo.setBanDateStr(DateTimeUtil.getDateToStr(vo.getBanDate(), "yyyy-MM-dd"));
		}
		return p;
	}
	
	
	public int updateStatus(Integer banId,Integer status,String database)
	{
		return this.banDao.updateStatus(banId, status, database);
	}

}
