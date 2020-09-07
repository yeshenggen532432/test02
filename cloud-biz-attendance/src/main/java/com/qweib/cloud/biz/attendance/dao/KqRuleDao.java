package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqRule;
import com.qweib.cloud.biz.attendance.model.KqRuleDetail;
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
public class KqRuleDao {
	
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addRule(KqRule bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_rule", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateRule(KqRule bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_rule", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteRule(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_rule where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateRuleStatus(Integer id,Integer status,String database)
	{
		String sql = "update "+database+".kq_rule set status =" + status.toString() + " where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryKqRulePage(KqRule rule, String database, Integer page, Integer limit)
	{
		String sql = "select * from " + database + ".kq_rule where 1 = 1 ";
		if(rule!= null)
		{
		if(!StrUtil.isNull(rule.getRuleName()))
		{
			sql += " and rule_name like '%" + rule.getRuleName() + "%'";
		}
		if(rule.getStatus()!= null)
		{
			if(rule.getStatus().intValue() > 0)sql += " and status = " + rule.getStatus();
		}
		}
		return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, KqRule.class);
	}
	
	public KqRule getRuleById(Integer ruleId,String database)
	{
		String sql = "select * from " + database + ".kq_rule where id= " + ruleId;
		List<KqRule> list = this.daoTemplate.queryForLists(sql, KqRule.class);
		if(list.size() > 0)
			{
				KqRule rule = list.get(0);
				List<KqRuleDetail> subList = this.queryDetailList(rule.getId().toString(), database);
				rule.setSubList(subList);
				return rule;
			}
		return null;
	}
	//////////////////////////////////////////////////////////
	
	public int addDetail(KqRuleDetail bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_rule_detail", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteDetail(Integer ruleId,String database)
	{
		String sql = "delete from "+database+".kq_rule_detail where rule_id="+ruleId;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public List<KqRuleDetail> queryDetailList(String ids,String database)
	{
		String sql = "select a.id,a.rule_id,a.seq_no,ifnull(a.bc_id,0) as bcId,ifnull(b.bc_name,'') as bcName from " + database + ".kq_rule_detail a left join " + database + ".kq_bc b on a.bc_id = b.id where rule_id in(" + ids + ") order by rule_id,a.seq_no ";
		return this.daoTemplate.queryForLists(sql, KqRuleDetail.class);
	}
	
	
}
