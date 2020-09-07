package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqBan;
import com.qweib.cloud.biz.attendance.model.KqBanDetail;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class KqBanDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addKqBan(KqBan bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_ban", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateKqBan(KqBan bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_ban", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteKqBan(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_ban where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryKqBanPage(KqBan ban, String database, Integer page, Integer limit)
	{
		String sql = "select a.*,b.member_nm,c.bc_name from " + database + ".kq_ban a join " + database + ".sys_mem b on a.member_id =b.member_id left join " + database + ".kq_bc c on a.bc_id = c.id  where 1 = 1 ";
		if(ban!= null)
		{
			if(!StrUtil.isNull(ban.getBranchId()))
			{
				if(ban.getBranchId().intValue() > 0)
				{
					sql += " and b.branch_id=" + ban.getBranchId();
				}
			}
			if(!StrUtil.isNull(ban.getMemberNm()))
			{
				sql += " and b.member_nm like '%" + ban.getMemberNm() + "%'";
			}
			if(!StrUtil.isNull(ban.getSdate()))
			{
				sql += " and ban_date>='" + ban.getSdate() + "'";
			}
			if(!StrUtil.isNull(ban.getEdate()))
			{
				sql += " and ban_date<'" + ban.getEdate() + "'";
			}
				
		}
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqBan.class);
	}
	////////////////////////////////////////////////////////////////////////////
	public int addBanDetail(KqBanDetail bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_ban_detail", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deletebanDetail(Integer mastId,String database)
	{
		String sql = "delete from " + database + ".kq_ban_detail where mast_id=" + mastId.toString();
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateStatus(Integer banId,Integer status,String database)
	{
		String sql = "update " + database + ".kq_ban set status =" + status + " where id = " + banId;
		return this.daoTemplate.update(sql);
	}
	

}
