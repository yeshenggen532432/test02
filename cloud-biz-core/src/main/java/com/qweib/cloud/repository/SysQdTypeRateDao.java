package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQdTypeRate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQdTypeRateDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public Page queryQdTypeRate(SysQdTypeRate qdTypeRate, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_qd_type_rate a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysQdTypeRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysQdTypeRate> queryList(SysQdTypeRate qdTypeRate, String database,String waretypeIds){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_qd_type_rate a ");
    	sql.append(" where 1=1 and a.rate!=0 and a.rate!='' and a.rate is not null ");
    	if(qdTypeRate!=null){
    		if(!StrUtil.isNull(qdTypeRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(qdTypeRate.getRelaId());
			}
			if(!StrUtil.isNull(qdTypeRate.getWaretypeId())){
				sql.append(" and a.waretype_id = ").append(qdTypeRate.getWaretypeId());
			}
    	}
    	if(!StrUtil.isNull(waretypeIds)){
    		sql.append(" and a.waretype_id in (").append(waretypeIds).append(")");
		}
    	sql.append(" order by a.waretype_id asc");
    	return this.daoTemplate.queryForLists(sql.toString(), SysQdTypeRate.class);
    }


	/**
	 * 获取有设置二级商品类别折扣率的商品类别
	 * @param qdTypeRate
	 * @param database
	 * @return
	 */
	public List<SysQdTypeRate> querySubTypeRateList(SysQdTypeRate qdTypeRate, String database){
		StringBuffer sql = new StringBuffer(" select a.rela_id,b.waretype_pid as waretype_id  from "+database+".sys_qd_type_rate a ");
		sql.append(" left join "+database+".sys_waretype b on a.waretype_id=b.waretype_id where b.waretype_pid!=0 ");
		sql.append(" and a.rate!=0 and a.rate!='' and a.rate is not null ");
		if(qdTypeRate!=null){
			if(!StrUtil.isNull(qdTypeRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(qdTypeRate.getRelaId());
			}
		}
		sql.append(" group by a.rela_id,b.waretype_pid");
		return this.daoTemplate.queryForLists(sql.toString(), SysQdTypeRate.class);
	}

	public int addQdTypeRate(SysQdTypeRate qdTypeRate, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_qd_type_rate", qdTypeRate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeRate queryQdTypeRateById(Integer qdTypeRateId, String database){
		String sql = "select * from "+database+".sys_qd_type_rate where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysQdTypeRate.class, qdTypeRateId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateQdTypeRate(SysQdTypeRate qdTypeRate, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", qdTypeRate.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_qd_type_rate", qdTypeRate, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteQdTypeRate(Integer id,String database){
		String sql = " delete from "+database+".sys_qd_type_rate where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteQdTypeRateAll(String database){
		String sql = "delete from "+database+".sys_qd_type_rate";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeRate queryQdTypeRate(SysQdTypeRate typeRate, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_qd_type_rate");
			sb.append(" where 1=1");
			if(null != typeRate){
				if(!StrUtil.isNull(typeRate.getRelaId())){
					sb.append(" and rela_id = " + typeRate.getRelaId());
				}
				if(!StrUtil.isNull(typeRate.getWaretypeId())){
					sb.append(" and waretype_id = " + typeRate.getWaretypeId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysQdTypeRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeRate queryQdTypeRateByTypeIdAndRelaId(Integer relaId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_qd_type_rate where waretype_id=? and rela_id=?";
		try{
			List<SysQdTypeRate> list = this.daoTemplate.queryForLists(sql, SysQdTypeRate.class,wareId,relaId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
