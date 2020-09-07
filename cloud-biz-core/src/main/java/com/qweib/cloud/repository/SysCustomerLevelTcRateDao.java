package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerLevelTcRate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerLevelTcRateDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_customer_level_tc_rate a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomerLevelTcRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysCustomerLevelTcRate> queryList(SysCustomerLevelTcRate levelTcRate, String database){
    	StringBuffer sql = new StringBuffer(" select a.*,b.khdj_nm from "+database+".sys_customer_level_tc_rate a  left join "+database+".sys_khlevel b on a.rela_id = b.id ");
		sql.append(" where 1=1  ");
    	if(levelTcRate!=null){
    		if(!StrUtil.isNull(levelTcRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(levelTcRate.getRelaId());
			}
    		if(!StrUtil.isNull(levelTcRate.getWaretypeId())){
				sql.append(" and a.waretype_id=").append(levelTcRate.getWaretypeId());
			}
    	}
		sql.append(" order by a.waretype_id asc");
    	return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelTcRate.class);
    }


	public int addCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_customer_level_tc_rate", levelTcRate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcRate queryCustomerLevelTcRateById(Integer levelTcRateId, String database){
		String sql = "select * from "+database+".sys_customer_level_tc_rate where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysCustomerLevelTcRate.class, levelTcRateId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcRate queryCustomerLevelTcRateByTypeIdAndLevelId(Integer levelId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_customer_level_tc_rate where waretype_id=? and rela_Id=?";
		try{
			List<SysCustomerLevelTcRate> list = this.daoTemplate.queryForLists(sql, SysCustomerLevelTcRate.class,wareId,levelId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int updateCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", levelTcRate.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_customer_level_tc_rate", levelTcRate, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteCustomerLevelTcRate(Integer id,String database){
		String sql = " delete from "+database+".sys_customer_level_tc_rate where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteCustomerLevelTcRateAll(String database){
		String sql = "delete from "+database+".sys_customer_level_tc_rate";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcRate queryCustomerLevelTcRate(SysCustomerLevelTcRate levelTcRate, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_customer_level_tc_rate");
			sb.append(" where 1=1");
			if(null != levelTcRate){
				if(!StrUtil.isNull(levelTcRate.getRelaId())){
					sb.append(" and rela_id = " + levelTcRate.getRelaId());
				}
				if(!StrUtil.isNull(levelTcRate.getWaretypeId())){
					sb.append(" and waretype_id = " + levelTcRate.getWaretypeId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysCustomerLevelTcRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
