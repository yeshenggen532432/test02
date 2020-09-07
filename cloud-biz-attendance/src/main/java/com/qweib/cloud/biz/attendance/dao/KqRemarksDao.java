package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.biz.attendance.model.KqRemarks;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class KqRemarksDao {
	
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addRemarks(KqRemarks bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_remarks", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateRemarks(KqRemarks bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_remarks", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteRemarks(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_remarks where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public int deleteRemarks1(KqRemarks bo,String database)
	{
		String sql = "delete from "+database+".kq_remarks where kq_date='"+bo.getKqDate() + "' and member_id=" + bo.getMemberId();
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public List<KqRemarks> queryRemarksList(KqEmpRule bo,String database)
	{
		String sql = "select a.*,e.member_nm from " + database + ".kq_remarks a join " + database + ".sys_mem e on a.member_id = e.member_id ";
		if(bo.getBranchId() != null)
		{
			if(bo.getBranchId().intValue() > 0)
			{
				sql += " join " + database + ".sys_depart d on e.branch_id = d.branch_id ";
			}
		}
		sql += " where 1  = 1 ";
		
		if(bo.getBranchId() != null)
		{
			if(bo.getBranchId().intValue() > 0)
			{
				sql += " and e.branch_id =" + bo.getBranchId();
			}
		}
		if(!StrUtil.isNull(bo.getMemberNm()))
		{
			sql += " and e.member_nm like '%" + bo.getMemberNm() + "%'";
		}
		
		if(!StrUtil.isNull(bo.getSdate()))
		{
			sql += " and a.kq_date>='" + bo.getSdate() + "'";
		}
		if(!StrUtil.isNull(bo.getEdate()))
		{
			sql += " and a.kq_date<='" + bo.getEdate() + "'";
		}
		
		return this.daoTemplate.queryForLists(sql, KqRemarks.class);
	}

}
