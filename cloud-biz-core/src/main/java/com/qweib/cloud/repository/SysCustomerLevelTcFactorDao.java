package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerLevelTcFactor;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerLevelTcFactorDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_customer_level_tc_factor a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomerLevelTcFactor.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysCustomerLevelTcFactor> queryList(SysCustomerLevelTcFactor levelTcFactor, String database){
    	StringBuffer sql = new StringBuffer(" select a.*,b.khdj_nm from "+database+".sys_customer_level_tc_factor a left join "+database+".sys_khlevel b on a.level_id = b.id ");
    	sql.append(" where 1=1 ");
    	if(levelTcFactor!=null){
    		if(!StrUtil.isNull(levelTcFactor.getLevelId())){
				sql.append(" and a.level_Id = ").append(levelTcFactor.getLevelId());
			}
    		if(!StrUtil.isNull(levelTcFactor.getWareId())){
				sql.append(" and a.ware_id=").append(levelTcFactor.getWareId());
			}
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelTcFactor.class);
    }


	public int addCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_customer_level_tc_factor", levelTcFactor);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcFactor queryCustomerLevelTcFactorById(Integer levelTcFactorId, String database){
		String sql = "select * from "+database+".sys_customer_level_tc_factor where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysCustomerLevelTcFactor.class, levelTcFactorId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcFactor queryCustomerLevelTcFactorByWareIdAndLevelId(Integer levelId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_customer_level_tc_factor where ware_id=? and level_Id=?";
		try{
			List<SysCustomerLevelTcFactor> list = this.daoTemplate.queryForLists(sql, SysCustomerLevelTcFactor.class,wareId,levelId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int updateCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", levelTcFactor.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_customer_level_tc_factor", levelTcFactor, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteCustomerLevelTcFactor(Integer id,String database){
		String sql = " delete from "+database+".sys_customer_level_tc_factor where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteCustomerLevelTcFactorAll(String database){
		String sql = "delete from "+database+".sys_customer_level_tc_factor";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelTcFactor queryCustomerLevelTcFactor(SysCustomerLevelTcFactor levelTcFactor, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_customer_level_tc_factor");
			sb.append(" where 1=1");
			if(null != levelTcFactor){
				if(!StrUtil.isNull(levelTcFactor.getLevelId())){
					sb.append(" and level_id = " + levelTcFactor.getLevelId());
				}
				if(!StrUtil.isNull(levelTcFactor.getWareId())){
					sb.append(" and ware_id = " + levelTcFactor.getWareId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysCustomerLevelTcFactor.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
