package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqEmpRule;
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
public class KqEmpRuleDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addEmpRule(KqEmpRule bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_emp_rule", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateEmpRule(KqEmpRule bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_emp_rule", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteEmpRule(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_emp_rule where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteEmpRuleByEmpId(Integer empId,String database)
	{
		String sql = "delete from "+database+".kq_emp_rule where member_id="+empId;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	
	
	public Page queryKqEmpRulePage(KqEmpRule rule, String database, Integer page, Integer limit)
	{
		String sql = "select a.rule_id,a.id,b.member_id,b.member_nm,b.member_mobile,b.member_use,c.rule_name from " + database + ".sys_mem b left join " + database + ".kq_emp_rule a on a.member_id=b.member_id "
				   + " left join " + database + ".kq_rule c on a.rule_id = c.id where 1 = 1 ";
		if(!StrUtil.isNull(rule.getRuleName()))
		{
			sql += " and c.rule_name like '%" + rule.getRuleName() + "%'";
		}
		if(!StrUtil.isNull(rule.getMemberNm()))
		{
			sql += " and b.member_nm like '%" + rule.getMemberNm() + "%'";
		}
		if(rule.getMemberId()!= null)
		{
			if(rule.getMemberId().intValue() > 0)
			{
				sql += " and b.member_id=" + rule.getMemberId().toString();
			}
		}
		if(rule.getMemberUse()!= null)
		{
			if(rule.getMemberUse().intValue() > 0)sql += " and b.member_use ="+ rule.getMemberUse();
		}
		if(rule.getBranchId() != null)
		{
			if(rule.getBranchId().intValue() > 0)
			{
				sql += " and b.branch_id =" + rule.getBranchId();
			}
		}
		sql += " order by b.member_id";
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqEmpRule.class);
	}


	public Page queryKqEmpRulePage1(KqEmpRule rule, String database, Integer page, Integer limit)
	{
		String sql = "select a.rule_id,a.id,b.member_id,b.member_nm,b.member_mobile,b.member_use,c.rule_name from " + database + ".sys_mem b left join " + database + ".kq_emp_rule a on a.member_id=b.member_id "
				+ " left join " + database + ".kq_rule c on a.rule_id = c.id "
				+ " join (select distinct psn_id from " + database + ".sys_checkin where check_time>='" + rule.getSdate() + "' and check_time<'" + rule.getEdate() + "') aa on b.member_id= aa.psn_id ";
		sql += " where 1 = 1 ";
		if(!StrUtil.isNull(rule.getRuleName()))
		{
			sql += " and c.rule_name like '%" + rule.getRuleName() + "%'";
		}
		if(!StrUtil.isNull(rule.getMemberNm()))
		{
			sql += " and b.member_nm like '%" + rule.getMemberNm() + "%'";
		}
		if(rule.getMemberId()!= null)
		{
			if(rule.getMemberId().intValue() > 0)
			{
				sql += " and b.member_id=" + rule.getMemberId().toString();
			}
		}
		if(rule.getMemberUse()!= null)
		{
			if(rule.getMemberUse().intValue() > 0)sql += " and b.member_use ="+ rule.getMemberUse();
		}
		if(rule.getBranchId() != null)
		{
			if(rule.getBranchId().intValue() > 0)
			{
				sql += " and b.branch_id =" + rule.getBranchId();
			}
		}
		sql += " order by b.member_id";
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqEmpRule.class);
	}
	
	public KqEmpRule getRuleByEmpId(Integer memberId,String database)
	{
		String sql = "select * from " + database + ".kq_emp_rule where member_id=" + memberId.toString();
		List<KqEmpRule> list = this.daoTemplate.queryForLists(sql, KqEmpRule.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

}
