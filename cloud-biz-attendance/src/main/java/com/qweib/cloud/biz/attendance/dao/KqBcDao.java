package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.model.KqBcTimes;
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
public class KqBcDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addBc(KqBc bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_bc", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateBc(KqBc bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_bc", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteBc(Integer id,String database)
	{
		String sql = "delete from "+database+".kq_bc where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateBcStatus(Integer id,Integer status,String database)
	{
		String sql = "update "+database+".kq_bc set status =" + status.toString() + " where id="+id;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryKqBc(KqBc bc, String database, Integer page, Integer limit)
	{
		String sql = "select * from " + database + ".kq_bc where 1 = 1 ";
		if(bc != null)
		{
		if(!StrUtil.isNull(bc.getBcName()))
		{
			sql += " and bc_name like '%" + bc.getBcName() + "%'";
		}
		if(bc.getStatus()!= null)
		{
			if(bc.getStatus().intValue() > 0)sql += " and status = " + bc.getStatus();
		}
		if(!StrUtil.isNull(bc.getAddress()))sql += " and address='" + bc.getAddress() + "'";
		}
		return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, KqBc.class);
	}
	
	public KqBc getKqBcById(Integer id,String database)
	{
		String sql = "select * from " + database + ".kq_bc where id=" + id.toString();
		List<KqBc> list = this.daoTemplate.queryForLists(sql, KqBc.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}
	
	
	/////////////////////////////////////////////////////////////////////////////////
	public int addBcTimes(KqBcTimes bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_bc_times", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteBcTimes(Integer bcId,String database)
	{
		String sql = "delete from "+database+".kq_bc_times where bc_id="+bcId;
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public List<KqBcTimes> queryBcTimes(String bcIds,String database)
	{
		String sql = "select * from " + database + ".kq_bc_times where bc_id in(" + bcIds + ") order by bc_id,id ";
		return this.daoTemplate.queryForLists(sql, KqBcTimes.class);
	}
	
	//////////////////////////////////////////////////////////////
	public List<KqAddress> queryAddress(String database)
	{
		String sql = "select distinct address,longitude,latitude from " + database + ".kq_bc where address <> '' and not (address is null) ";
		List<KqAddress> list = this.daoTemplate.queryForLists(sql, KqAddress.class);
		return list;
	}
	
	public int updateAddress(KqAddress bo,String database)
	{
		String sql = "update " + database + ".kq_bc set address='" + bo.getAddress() + "' where address='" + bo.getAddress1() + "'";
		return this.daoTemplate.update(sql);
	}
	
	public KqBc getBcByAddress(String address,String database)
	{
		String sql = "select * from " + database + ".kq_bc where address='" + address + "'";
		//if(id.intValue() > 0)sql += " and id!= " + id;
		List<KqBc> list = this.daoTemplate.queryForLists(sql, KqBc.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

}
