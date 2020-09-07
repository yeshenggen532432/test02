package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqEmpRuleDao;
import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class KqEmpRuleService {
	
	@Resource
	private KqEmpRuleDao empRuleDao;
	
	
	public int addEmpRule(String empIds,Integer ruleId,String database)
	{
		String []idStr = empIds.split(",");
		for(int i = 0;i<idStr.length;i++)
		{
			KqEmpRule bo = new KqEmpRule();
			Integer empId = Integer.parseInt(idStr[i]);
			if(empId == 0)
			{
				throw new ServiceException("参数错误");
			}
			bo.setMemberId(empId);
			bo.setRuleId(ruleId);
			this.empRuleDao.deleteEmpRuleByEmpId(empId, database);
			int ret = this.empRuleDao.addEmpRule(bo, database);
			if(ret == 0)
			{
				throw new ServiceException("保存失败");
			}
			
		}
		return 1;
	}
	
	public Page queryEmpRulePage(KqEmpRule rule, String database, Integer page, Integer limit)
	{
		return this.empRuleDao.queryKqEmpRulePage(rule, database, page, limit);
	}

}
