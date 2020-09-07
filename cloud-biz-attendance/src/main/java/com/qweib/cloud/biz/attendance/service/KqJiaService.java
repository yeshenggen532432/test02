package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.*;
import com.qweib.cloud.biz.attendance.model.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class KqJiaService {
	@Resource
	private KqJiaDao jiaDao;
	
	@Resource
	private KqEmpRuleDao empRuleDao;
	
	@Resource
	private KqRuleDao ruleDao;
	
	@Resource
	private KqPbDao pbDao;
	
	@Resource
	private KqBcDao bcDao;
	
	private KqRuleDetail getRuleBc(Date curDate,KqRule rule)
	{
		if(rule.getRuleUnit().intValue() == 0)//天
		{
			int day = DateTimeUtil.getDay(curDate);
			if(rule.getDays().intValue() == 0)return null;
			int cur = day %rule.getDays().intValue();
			if(cur == 0)cur = rule.getDays().intValue();
			for(KqRuleDetail detl: rule.getSubList())
			{
				if(detl.getSeqNo().intValue() == cur)
				{
					return detl;
				}
			}
			return null;
			
		}
		if(rule.getRuleUnit().intValue() == 1)//周
		{
			int week = DateTimeUtil.getWeekByDate(curDate);
			if(week == 1)week = 7;
			else week--;
			for(KqRuleDetail detl: rule.getSubList())
			{
				if(detl.getSeqNo().intValue() == week)
				{
					return detl;
				}
			}
			return null;
			
		}
		if(rule.getRuleUnit().intValue() == 2)//月
		{
			int day = DateTimeUtil.getDay(curDate);
			for(KqRuleDetail detl: rule.getSubList())
			{
				if(detl.getSeqNo().intValue() == day)
				{
					return detl;
				}
			}
			return null;
			
		}
		return null;
	}
	
	private BigDecimal getBcHours(KqBc bc) throws Exception
	{
		List<KqBcTimes> timeList = bc.getSubList();
		Integer minutes = 0;
		String yymmdd = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
		if(timeList.size() > 0)
		{
			KqBcTimes t1 = timeList.get(0);
			Date bcStart = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getStartTime() + ":00",  "yyyy-MM-dd HH:mm:ss");
									
			Date bcEnd = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getEndTime() + ":00",  "yyyy-MM-dd HH:mm:ss");
			
			minutes = DateTimeUtil.getMinutes(bcStart,bcEnd);
		}
		if(timeList.size() > 1)
		{
			KqBcTimes t1 = timeList.get(1);
			Date bcStart = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getStartTime() + ":00",  "yyyy-MM-dd HH:mm:ss");
									
			Date bcEnd = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getEndTime() + ":00",  "yyyy-MM-dd HH:mm:ss");
			
			minutes += DateTimeUtil.getMinutes(bcStart,bcEnd);
		}
		double f = minutes;
		f = f/60;
		return new BigDecimal(f);
		
	}
	
	public int addKqJia(KqJia jia,String database) throws Exception
	{
		Date dtStart = DateTimeUtil.getStrToDate(jia.getStartTime() + ":00", "yyyy-MM-dd HH:mm:ss");
		Date dtEnd = DateTimeUtil.getStrToDate(jia.getEndTime()+ ":00", "yyyy-MM-dd HH:mm:ss");
		int days =  DateTimeUtil.getDaysDiff(dtStart, dtEnd) + 1;
		String startYmd = DateTimeUtil.getDateToStr(dtStart, "yyyy-MM-dd");
		List<KqJiaDetail> list = new ArrayList<KqJiaDetail>();
		BigDecimal sumHours = new BigDecimal(0);
		for(int i = 0;i<days;i++)
		{
			Date curDate = DateTimeUtil.dateTimeAdd(dtStart, 5, i);
			String ymd = DateTimeUtil.getDateToStr(curDate, "yyyy-MM-dd");
			String ymd1 = DateTimeUtil.getDateToStr(dtEnd, "yyyy-MM-dd");
			curDate = DateTimeUtil.getStrToDate(ymd, "yyyy-MM-dd");
			if(curDate.getTime()>dtEnd.getTime())break;
			KqPb pb = this.pbDao.getPbByEmpIdAndDate(ymd, jia.getMemberId(), database);
			KqBc bc = null;
			if(pb!= null)
			{
				bc = this.bcDao.getKqBcById(pb.getBcId(), database);
			}
			if(bc == null)
			{
				KqEmpRule empRule = this.empRuleDao.getRuleByEmpId(jia.getMemberId(), database);
				if(empRule == null)continue;
				KqRule rule = this.ruleDao.getRuleById(empRule.getRuleId(), database);
				if(rule == null)continue;
				List<KqRuleDetail> detailList = this.ruleDao.queryDetailList(rule.getId().toString(), database);
				rule.setSubList(detailList);
				KqRuleDetail ruleDetail = this.getRuleBc(curDate, rule);
				if(ruleDetail == null)continue;
				bc = this.bcDao.getKqBcById(ruleDetail.getBcId(), database);
			}
			if(bc == null)continue;//找不到排班记录不需要请假
			List<KqBcTimes> timeList = this.bcDao.queryBcTimes(bc.getId().toString(), database);
			bc.setSubList(timeList);
			if(timeList.size() == 0)continue;
			KqBcTimes timeVo = timeList.get(0);
			Date bcStart = DateTimeUtil.getStrToDate(ymd + " " + timeVo.getStartTime() + ":00", "yyyy-MM-dd HH:mm:ss");
			Date bcEnd = DateTimeUtil.getStrToDate(ymd + " " + timeVo.getEndTime() + ":00", "yyyy-MM-dd HH:mm:ss");
			if(timeList.size() > 1)
			{
				timeVo = timeList.get(1);
				bcEnd = DateTimeUtil.getStrToDate(ymd + " " + timeVo.getEndTime() + ":00", "yyyy-MM-dd HH:mm:ss");
			}
			KqJiaDetail detl = new KqJiaDetail();
			detl.setHours(new BigDecimal(0));
			detl.setKqDate(ymd);
			detl.setMastId(0);
			detl.setMemberId(jia.getMemberId());
			Integer minutes = 0;
			BigDecimal hours = new BigDecimal(0);
			if(ymd1.equals(ymd))//最后一天
			{
				if(startYmd.equals(ymd1))
				{
					if(dtEnd.getTime() > bcEnd.getTime())dtEnd = bcEnd;
					if(dtStart.getTime() < bcStart.getTime())dtStart = bcStart;
					minutes = DateTimeUtil.getMinutes(dtStart, dtEnd);
				}
				else
				{
					if(dtEnd.getTime() > bcEnd.getTime())dtEnd = bcEnd;
					
					minutes = DateTimeUtil.getMinutes(bcStart, dtEnd);
				}
				double f = minutes;
				f = f/60;
				hours = new BigDecimal(f);
			}
			else
			{
				hours = this.getBcHours(bc);
			}
			detl.setHours(hours);
			sumHours = sumHours.add(hours);
			list.add(detl);
		}
		jia.setHours(sumHours);
		jia.setDays(new BigDecimal(0));
		jia.setStatus(0);
		jia.setJiaDate(new Date());
		
		int ret = this.jiaDao.addKqJia(jia, database);
		if(ret <1)return 0;
		for(KqJiaDetail detl: list)
		{
			detl.setMastId(ret);
			this.jiaDao.addJiaDetail(detl, database);
		}
		return ret;
	}
	
	public Page queryKqJiaPage(KqJia jia, String database, Integer page, Integer limit) throws Exception
	{
		Page p = this.jiaDao.queryKqJiaPage(jia, database, page, limit);
		List<KqJia> list = p.getRows();
		for(KqJia vo: list)
		{
			vo.setJiaDateStr(DateTimeUtil.getDateToStr(vo.getJiaDate(), "yyyy-MM-dd"));
		}
		return p;
	}
	
	public int updateStatus(Integer jiaId,Integer status,String database)
	{
		return this.jiaDao.updateStatus(jiaId, status, database);
	}

}
