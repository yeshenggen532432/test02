package com.qweib.cloud.biz.attendance.dao;

import com.qweib.cloud.biz.attendance.model.KqPb;
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
public class KqPbDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	
	public int addKqPb(KqPb bo,String database)
	{
		try {			
			return this.daoTemplate.addByObject(""+database+".kq_pb", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int updateKqPb(KqPb bo,String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".kq_pb", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteKqPb(KqPb bo,String database)
	{
		String sql = "delete from " + database + ".kq_pb where 1 = 1 ";
		if(bo != null)
		{
			if(!StrUtil.isNull(bo.getId()))sql += " and id =" + bo.getId();
			if(!StrUtil.isNull(bo.getMemberId()))sql+= " and member_id =" + bo.getMemberId();
			if(!StrUtil.isNull(bo.getSdate()))sql += " and bc_date>='" + bo.getSdate() + "'";
			if(!StrUtil.isNull(bo.getEdate()))sql += " and bc_date<='" + bo.getEdate() + "'";
			if(!StrUtil.isNull(bo.getBcDate()))sql += " and bc_date='" + bo.getBcDate() + "'";
			
		}
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteKqPb1(String ids,String sdate,String edate,String database)
	{
		String sql = "delete from " + database + ".kq_pb where member_id in(" + ids + ")";
		sql += " and bc_date>='" + sdate + "' and bc_date<='" + edate + "'";
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int deleteKqPbByEmpDate(Integer memberId,String kqDate,String database)
	{
		String sql = "delete from " + database + ".kq_pb where member_id=" + memberId.toString() + " and bc_date='" + kqDate + "'";
		try{
			return this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public Page queryKqPbPage(KqPb bo, String database, Integer page, Integer limit)
	{
		String sql = "select a.*,b.bc_name,c.member_nm from " + database + ".kq_pb a left join " + database + ".kq_bc b on a.bc_id = b.id "
				   + " join " + database + ".sys_mem c on a.member_id = c.member_id where 1 = 1 ";
		if(bo != null)
		{
			
			if(!StrUtil.isNull(bo.getMemberId()))sql+= " and a.member_id =" + bo.getMemberId();
			if(!StrUtil.isNull(bo.getSdate()))sql += " and a.bc_date>='" + bo.getSdate() + "'";
			if(!StrUtil.isNull(bo.getEdate()))sql += " and a.bc_date<='" + bo.getEdate() + "'";
			
		}
		return this.daoTemplate.queryForPageByMySql(sql, page, limit, KqPb.class);
	}
	
	public KqPb getPbByEmpIdAndDate(String kqDate,Integer memberId,String database)
	{
		String sql = "select * from " + database + ".kq_pb where member_id =" + memberId.toString() + " and bc_date='" + kqDate + "'";
		List<KqPb> list = this.daoTemplate.queryForLists(sql, KqPb.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

}
