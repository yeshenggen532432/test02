package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCheckInPC;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysCheckInPcDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	  *@see 分页查询签到记录
	  *@param checkIn
	  *@param page
	  *@param rows
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Jul 31, 2015
	 */
	public Page queryCheckInByPage(Integer memberId, String memberNm, Integer branchId, String atime, String btime, Integer page,
                                   Integer rows, String datasource, Integer mId, String allDepts, String invisibleDepts) {
		StringBuffer sql = new StringBuffer("select c.id,c.location,c.cdzt,(case when d.branch_name is null then '公司本级' else branch_name end) as branch_nm,date_format(c.check_time,'%Y-%m-%d') as cdate,");
		sql.append("m.member_nm,(case when c.tp='1-1' or c.tp='1' then date_format(c.check_time,'%H:%i') else null end) as stime,");
		sql.append("(case when c.tp='1-2' then date_format(c.check_time,'%H:%i') else null end) as etime,DAYOFWEEK(c.check_time) as dateweek");
		sql.append(" from "+datasource+".sys_checkin c,"+datasource+".sys_mem m left join "+datasource+".sys_depart d on m.branch_id=d.branch_id ");
		sql.append(" where c.psn_id=m.member_id and tp!='2' ");
		if(!StrUtil.isNull(memberNm)){
			sql.append(" and m.member_nm like '%"+memberNm+"%' ");
		}
		if(!StrUtil.isNull(atime)){
			sql.append(" and date_format(c.check_time,'%Y-%m-%d')>='"+atime+"' ");
		}
		if(!StrUtil.isNull(btime)){
			sql.append(" and date_format(c.check_time,'%Y-%m-%d')<='"+btime+"' ");
		}
		if(!StrUtil.isNull(branchId)){
			if(branchId!=0){
				sql.append(" and m.branch_id="+branchId+"");
			}
		}
		if(!StrUtil.isNull(memberId))
		{
			if(memberId.intValue() > 0) sql.append(" and c.psn_id=" + memberId);
		}
		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
				sql.append(" AND (m.branch_id IN ("+allDepts+") ");
				sql.append(" OR c.psn_id="+mId+")");
			} else {
				sql.append(" AND m.branch_id IN ("+allDepts+") ");
			}
		}else if (!StrUtil.isNull(mId)) {//个人
			sql.append(" AND c.psn_id="+mId);
		}
		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
			sql.append(" AND m.branch_id NOT IN ("+invisibleDepts+") ");
		}

		sql.append(" order by c.check_time desc");
		try {
			return daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCheckInPC.class);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}

	/**
	  *@see 根据条件查询签到记录（list）
	  *@param memNm
	  *@param time1
	  *@param time2
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 3, 2015
	 */
	public List<SysCheckInPC> queryCheckInList(String memNm, String time1,
                                               String time2, Integer branchId, String datasource) {
		StringBuffer sql = new StringBuffer("select c.id,c.location,c.cdzt,(case when d.branch_name is null then '公司本级' else branch_name end) as branch_nm,date_format(c.check_time,'%Y-%m-%d') as cdate,");
		sql.append("m.member_nm,(case when c.tp='1-1' or c.tp='1' then date_format(c.check_time,'%H:%i') else null end) as stime,");
		sql.append("(case when c.tp='1-2' then date_format(c.check_time,'%H:%i') else null end) as etime,DAYOFWEEK(c.check_time) as dateweek");
		sql.append(" from "+datasource+".sys_checkin c,"+datasource+".sys_mem m left join "+datasource+".sys_depart d on m.branch_id=d.branch_id ");
		sql.append(" where c.psn_id=m.member_id and tp!='2' ");
		if(!StrUtil.isNull(memNm)){
			sql.append(" and m.member_nm like '%"+memNm+"%' ");
		}
		if(!StrUtil.isNull(time1)){
			sql.append(" and date_format(c.check_time,'%Y-%m-%d')>='"+time1+"' ");
		}
		if(!StrUtil.isNull(time2)){
			sql.append(" and date_format(c.check_time,'%Y-%m-%d')<='"+time2+"' ");
		}
		if(!StrUtil.isNull(branchId)){
			sql.append(" and m.branch_id="+branchId+" ");
		}
		sql.append(" order by c.check_time desc");
		try {
			return daoTemplate.queryForLists(sql.toString(), SysCheckInPC.class);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}

	public  List<SysCheckinPic>  querycheckInPic(String ids, String database)
	{
		String sql = "select * from " + database + ".sys_checkin_pic where checkin_id in(" + ids + ") order by checkin_id ";
		return this.daoTemplate.queryForLists(sql, SysCheckinPic.class);
	}

}
