package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerLevelRate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerLevelRateDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryCustomerLevelRate(SysCustomerLevelRate levelRate, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_customer_level_rate a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomerLevelRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysCustomerLevelRate> queryList(SysCustomerLevelRate levelRate, String database,String waretypeIds){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_customer_level_rate a ");
		sql.append(" where 1=1 and a.rate!=0 and a.rate!='' and a.rate is not null ");
    	if(levelRate!=null){
    		if(!StrUtil.isNull(levelRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(levelRate.getRelaId());
			}
    		if(!StrUtil.isNull(levelRate.getWaretypeId())){
				sql.append(" and a.waretype_id=").append(levelRate.getWaretypeId());
			}
    	}
    	if(!StrUtil.isNull(waretypeIds)){
    		sql.append(" and a.waretype_id in (").append(waretypeIds).append(")");
		}
		sql.append(" order by a.waretype_id asc");
    	return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelRate.class);
    }


	public int addCustomerLevelRate(SysCustomerLevelRate levelRate, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_customer_level_rate", levelRate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelRate queryCustomerLevelRateById(Integer levelRateId, String database){
		String sql = "select * from "+database+".sys_customer_level_rate where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysCustomerLevelRate.class, levelRateId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelRate queryCustomerLevelByTypeIdAndLevelId(Integer levelId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_customer_level_rate where waretype_id=? and rela_Id=?";
		try{
			List<SysCustomerLevelRate> list = this.daoTemplate.queryForLists(sql, SysCustomerLevelRate.class,wareId,levelId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int updateCustomerLevelRate(SysCustomerLevelRate levelRate, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", levelRate.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_customer_level_rate", levelRate, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteCustomerLevelRate(Integer id,String database){
		String sql = " delete from "+database+".sys_customer_level_rate where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteCustomerLevelRateAll(String database){
		String sql = "delete from "+database+".sys_customer_level_rate";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerLevelRate queryCustomerLevelRate(SysCustomerLevelRate levelRate, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_customer_level_rate");
			sb.append(" where 1=1");
			if(null != levelRate){
				if(!StrUtil.isNull(levelRate.getRelaId())){
					sb.append(" and rela_id = " + levelRate.getRelaId());
				}
				if(!StrUtil.isNull(levelRate.getWaretypeId())){
					sb.append(" and waretype_id = " + levelRate.getWaretypeId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysCustomerLevelRate.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	/**
	 * 获取有设置二级商品类别折扣率的商品类别
	 * @param levelRate
	 * @param database
	 * @return
	 */
	public List<SysCustomerLevelRate> querySubTypeRateList(SysCustomerLevelRate levelRate, String database){
		StringBuffer sql = new StringBuffer(" select a.rela_id,b.waretype_pid as waretype_id  from "+database+".sys_customer_level_rate a ");
		sql.append(" left join "+database+".sys_waretype b on a.waretype_id=b.waretype_id where b.waretype_pid!=0 ");
		sql.append(" and a.rate!=0 and a.rate!='' and a.rate is not null ");
		if(levelRate!=null){
			if(!StrUtil.isNull(levelRate.getRelaId())){
				sql.append(" and a.rela_Id = ").append(levelRate.getRelaId());
			}
		}
		sql.append(" group by a.rela_id,b.waretype_pid");
		return this.daoTemplate.queryForLists(sql.toString(), SysCustomerLevelRate.class);
	}

}
