package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQdTypeTcRate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQdTypeTcRateDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public Page queryQdTypeTcRate(SysQdTypeTcRate qdTypeTcRate, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_qd_type_tc_rate a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysQdTypeTcRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysQdTypeTcRate> queryList(SysQdTypeTcRate qdTypeTcRate, String database){
    	StringBuffer sql = new StringBuffer(" select a.*,b.qdtp_nm from "+database+".sys_qd_type_tc_rate a left join "+database+".sys_qdtype b on a.rela_id = b.id ");
    	sql.append(" where 1=1  ");
    	if(qdTypeTcRate!=null){
    		if(!StrUtil.isNull(qdTypeTcRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(qdTypeTcRate.getRelaId());
			}
			if(!StrUtil.isNull(qdTypeTcRate.getWaretypeId())){
				sql.append(" and a.waretype_id = ").append(qdTypeTcRate.getWaretypeId());
			}
    	}
    	sql.append(" order by a.waretype_id asc");
    	return this.daoTemplate.queryForLists(sql.toString(), SysQdTypeTcRate.class);
    }


	public int addQdTypeTcRate(SysQdTypeTcRate qdTypeTcRate, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_qd_type_tc_rate", qdTypeTcRate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcRate queryQdTypeTcRateById(Integer qdTypeTcRateId, String database){
		String sql = "select * from "+database+".sys_qd_type_tc_rate where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysQdTypeTcRate.class, qdTypeTcRateId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateQdTypeTcRate(SysQdTypeTcRate qdTypeTcRate, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", qdTypeTcRate.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_qd_type_tc_rate", qdTypeTcRate, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteQdTypeTcRate(Integer id,String database){
		String sql = " delete from "+database+".sys_qd_type_tc_rate where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteQdTypeTcRateAll(String database){
		String sql = "delete from "+database+".sys_qd_type_tc_rate";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcRate queryQdTypeTcRate(SysQdTypeTcRate TypeTcRate, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_qd_type_tc_rate");
			sb.append(" where 1=1");
			if(null != TypeTcRate){
				if(!StrUtil.isNull(TypeTcRate.getRelaId())){
					sb.append(" and rela_id = " + TypeTcRate.getRelaId());
				}
				if(!StrUtil.isNull(TypeTcRate.getWaretypeId())){
					sb.append(" and waretype_id = " + TypeTcRate.getWaretypeId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysQdTypeTcRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcRate queryQdTypeTcRateByTypeIdAndRelaId(Integer relaId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_qd_type_tc_rate where waretype_id=? and rela_id=?";
		try{
			List<SysQdTypeTcRate> list = this.daoTemplate.queryForLists(sql, SysQdTypeTcRate.class,wareId,relaId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
