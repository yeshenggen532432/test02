package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.biz.attendance.model.KqStat;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Repository
public class KqStatDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public List<KqStat> queryKqStatList(KqEmpRule bo,List<KqEmpRule>empList,String database)
	{
		String empIds = "";
		for(KqEmpRule vo: empList)
		{
			if(empIds.length() == 0)empIds = vo.getMemberId().toString();
			else empIds = empIds + "," + vo.getMemberId();
		}
		//获得排班天数
		String sql = "select member_id,sum(1) as pbDays from " + database + ".kq_detail where bc_id > 0 and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " and kq_status not like '%节假日%'";
		sql += " group by member_id ";
		List<KqStat> list1 = this.daoTemplate.queryForLists(sql, KqStat.class);
		//缺勤
		sql = "select member_id,sum(1) as kgQty from " + database + ".kq_detail where kq_status like '%缺勤%' and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list2 = this.daoTemplate.queryForLists(sql, KqStat.class);
		
		//迟到次数
		sql = "select member_id,sum(1) as cdQty,sum(cd_minute) as cdMinute from " + database + ".kq_detail where kq_status like '%迟到%' and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list3 = this.daoTemplate.queryForLists(sql, KqStat.class);
		//早退次数
		sql = "select member_id,sum(1) as ztQty,sum(zt_minute) as ztMinute from " + database + ".kq_detail where kq_status like '%早退%' and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list4 = this.daoTemplate.queryForLists(sql, KqStat.class);
		//漏卡
		sql = "select member_id,sum(1) as lkQty from " + database + ".kq_detail where kq_status like '%漏卡%' and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list5 = this.daoTemplate.queryForLists(sql, KqStat.class);
		
		//请假
		sql = "select a.member_id,sum(a.hours) as qjQty from " + database + ".kq_jia_detail a join " + database + ".kq_jia b on a.mast_id = b.id  where b.status = 0 and  a.member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and a.kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and a.kq_date<'" + bo.getEdate() + "'";
		sql += " group by a.member_id ";
		List<KqStat> list6 = this.daoTemplate.queryForLists(sql, KqStat.class);
		//加班
		sql = "select a.member_id,sum(a.hours) as jbQty from " + database + ".kq_ban_detail a join " + database + ".kq_ban b on a.mast_id = b.id   where b.status = 0 and a.member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and a.kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and a.kq_date<'" + bo.getEdate() + "'";
		sql += " group by a.member_id ";
		List<KqStat> list7 = this.daoTemplate.queryForLists(sql, KqStat.class);		
		//上班时间长
		sql = "select member_id,sum(minute2) as workHours,sum(1) as monthDays from " + database + ".kq_detail  where member_id in(" + empIds + ") and minute2>0";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list8 = this.daoTemplate.queryForLists(sql, KqStat.class);		
		
		
		sql = "select member_id,sum(1) as outOfQty from " + database + ".kq_detail where kq_status like '%考勤位置错误%' and member_id in(" + empIds + ")";
		if(!StrUtil.isNull(bo.getSdate()))sql += " and kq_date>='" + bo.getSdate() + "'";
		if(!StrUtil.isNull(bo.getEdate()))sql += " and kq_date<'" + bo.getEdate() + "'";
		sql += " group by member_id ";
		List<KqStat> list9 = this.daoTemplate.queryForLists(sql, KqStat.class);
		
		//整合一起
		List<KqStat> retList = new ArrayList<KqStat>();
		for(KqEmpRule emp: empList)
		{
			
			KqStat vo = new KqStat();
			vo.setMemberId(emp.getMemberId());
			vo.setMemberNm(emp.getMemberNm());
			vo.setCdMinute(0);
			vo.setCdQty(0);
			vo.setJbQty(new BigDecimal(0));
			vo.setKgQty(0);
			vo.setLkQty(0);
			vo.setMonthDays(0);
			vo.setPbDays(0);
			vo.setQjQty(new BigDecimal(0));
			vo.setZtMinute(0);
			vo.setZtQty(0);
			vo.setOutOfQty(0);
			vo.setWorkHours(new BigDecimal(0));
			Integer flag = 0;
			for(KqStat vo1: list1)//排班天数
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setPbDays(vo1.getPbDays());
					flag = 1;
				}
			}
			for(KqStat vo1: list2)//缺勤
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setKgQty(vo1.getKgQty());
					//Integer n = vo.getPbDays();
					//n -= vo1.getKgQty();
					//vo.setMonthDays(n);		
					flag = 1;
				}
			}
			for(KqStat vo1: list3)//迟到
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setCdMinute(vo1.getCdMinute());
					vo.setCdQty(vo1.getCdQty());
					flag = 1;
				}
			}
			for(KqStat vo1: list4)//早退
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setZtMinute(vo1.getZtMinute());
					vo.setZtQty(vo1.getZtQty());
					flag = 1;
				}
			}
			for(KqStat vo1: list5)//漏卡
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setLkQty(vo1.getLkQty());
					flag = 1;
				}
			}
			for(KqStat vo1: list6)//请假
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setQjQty(vo1.getQjQty());
					flag = 1;
				}
			}
			for(KqStat vo1: list7)//加班
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setJbQty(vo1.getJbQty());
					flag = 1;
				}
			}
			for(KqStat vo1: list8)
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					BigDecimal tmp = vo1.getWorkHours();
					BigDecimal aa = new BigDecimal(60);
					tmp = tmp.divide(aa,2, BigDecimal.ROUND_UP);
					vo.setWorkHours(tmp);
					flag = 1;
					vo.setMonthDays(vo1.getMonthDays());
				}
			}
			for(KqStat vo1: list9)//超出范围
			{
				if(vo.getMemberId().intValue()== vo1.getMemberId().intValue())
				{
					vo.setOutOfQty(vo1.getOutOfQty());
					flag = 1;
				}
			}
			if(emp.getMemberUse().intValue() == 2&&flag ==0)continue;
			retList.add(vo);
		}
		return retList;
	}
	

}
