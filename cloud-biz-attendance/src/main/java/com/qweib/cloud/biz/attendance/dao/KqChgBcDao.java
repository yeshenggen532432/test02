package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqChgBc;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class KqChgBcDao {
	
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addChgBc(KqChgBc bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_chg_bc", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	
	public int updateStatus(Integer id,Integer status,String database)
	{
		String sql = "update " + database + ".kq_chg_bc set status=" + status + " where id =" + id;
		return this.daoTemplate.update(sql);
	}
	
	public Page queryKqJiaPage(KqChgBc bc, String database, Integer page, Integer limit)
	{
		String sql = "select a.*,b.member_nm,c1.bc_name as bcName1,c2.bc_name as bcName2 from " + database + ".kq_chg_bc a join " + database + ".sys_mem b on a.member_id =b.member_id "
				   + " left join " + database + ".kq_bc c1 on a.bc_id1 = c1.id  left join " + database + ".kq_bc c2 on a.bc_id2 = c2.id  where 1 = 1 ";
		if(bc!= null)
		{
			
			if(!StrUtil.isNull(bc.getMemberNm()))
			{
				sql += " and b.member_nm like '%" + bc.getMemberNm() + "%'";
			}
			if(!StrUtil.isNull(bc.getSdate()))
			{
				sql += " and chg_date>='" + bc.getSdate() + "'";
			}
			if(!StrUtil.isNull(bc.getEdate()))
			{
				sql += " and chg_date<'" + bc.getEdate() + "'";
			}
				
		}
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqChgBc.class);
	}

}
