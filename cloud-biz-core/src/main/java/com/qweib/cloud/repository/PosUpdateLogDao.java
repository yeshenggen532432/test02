package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.PosUpdateDetail;
import com.qweib.cloud.core.domain.PosUpdateLog;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class PosUpdateLogDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addUpdateLog1(String msg,String database)
	{
		try {	
		PosUpdateLog rec = new PosUpdateLog();
		String dateStr = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
		rec.setUpdateTime(dateStr);
		rec.setUpdateType(msg);
		deleteByType(msg,database);
		return this.addUpdateLog(rec, database);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int addUpdateLog(PosUpdateLog bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".pos_update_log", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateUpdateLog(PosUpdateLog bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".pos_update_log", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteByType(String typeName,String database)
	{
		String sql = "delete from " + database + ".pos_update_log where update_type='" + typeName + "'";
		this.daoTemplate.update(sql);
	}
	
	public PosUpdateLog getLogByType(String updateType,String database)
	{
		String sql = "select * from " + database + ".pos_update_log where update_type = '" + updateType + "'";
		List<PosUpdateLog> list = this.daoTemplate.queryForLists(sql, PosUpdateLog.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}
	
	public List<PosUpdateLog> queryAll(String database)
	{
		String sql = "select * from " + database + ".pos_update_log ";
		return this.daoTemplate.queryForLists(sql, PosUpdateLog.class);
	}

	public int saveUpdateDetail(Integer wareId,String database)
	{
		PosUpdateDetail bo = this.getDetailById(wareId,"商品信息",database);
		if(bo!= null)
		{
			bo.setUpdateTime(new Date());
			this.updateUpdateDetail(bo,database);
		}
		else
		{
			bo = new PosUpdateDetail();
			bo.setObjId(wareId);
			bo.setUpdateTime(new Date());
			bo.setUpdateType("商品信息");
			this.addUpdateDetail(bo,database);
		}
		return  1;
	}
	
	public int addUpdateDetail(PosUpdateDetail bo, String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".pos_update_detail", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	
	public int updateUpdateDetail(PosUpdateDetail bo, String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".pos_update_detail", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public PosUpdateDetail getDetailById(Integer objId, String updateType, String database)
	{
		String sql = "select * from " + database + ".pos_update_detail where obj_id =" + objId.toString() + " and update_type='" + updateType + "'";
		List<PosUpdateDetail> list = this.daoTemplate.queryForLists(sql, PosUpdateDetail.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

}
