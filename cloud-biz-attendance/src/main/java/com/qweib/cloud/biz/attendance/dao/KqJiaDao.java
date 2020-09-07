package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqJia;
import com.qweib.cloud.biz.attendance.model.KqJiaDetail;
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
public class KqJiaDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addKqJia(KqJia bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_jia", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateKqJia(KqJia bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_jia", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteKqJia(Integer id,String database )
	{
		String sql = "delete from "+database+".kq_jia where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryKqJiaPage(KqJia jia, String database, Integer page, Integer limit)
	{
		String sql = "select a.*,b.member_nm from " + database + ".kq_jia a join " + database + ".sys_mem b on a.member_id =b.member_id where 1 = 1 ";
		if(jia!= null)
		{
			if(!StrUtil.isNull(jia.getBranchId()))
			{
				if(jia.getBranchId().intValue() > 0)
				{
					sql += " and b.branch_id=" + jia.getBranchId();
				}
			}
			if(!StrUtil.isNull(jia.getMemberNm()))
			{
				sql += " and b.member_nm like '%" + jia.getMemberNm() + "%'";
			}
			if(!StrUtil.isNull(jia.getSdate()))
			{
				sql += " and jia_date>='" + jia.getSdate() + "'";
			}
			if(!StrUtil.isNull(jia.getEdate()))
			{
				sql += " and jia_date<'" + jia.getEdate() + "'";
			}
				
		}
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqJia.class);
	}
	////////////////////////////////////////////////////明细
	public int addJiaDetail(KqJiaDetail bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_jia_detail", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteJiaDetail(Integer mastId,String database)
	{
		String sql = "delete from " + database + ".kq_jia_detail where mast_id=" + mastId.toString();
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateStatus(Integer jiaId,Integer status,String database)
	{
		String sql = "update " + database + ".kq_jia set status=" + status + " where id =" + jiaId;
		return this.daoTemplate.update(sql);
	}
	
	public List<KqJiaDetail> queryJiaDetail(String sdate,String edate,String database)
	{
		String sql = "select * from " + database + ".kq_jia_detail where kq_date>='" + sdate + "' and kq_date<'" + edate + "'";
		return this.daoTemplate.queryForLists(sql, KqJiaDetail.class);
	}
	

}
